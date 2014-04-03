/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

/**
 * 
 */
package uk.ac.sussex.general;

import java.util.List;
import java.util.concurrent.TimeUnit;

import uk.ac.sussex.handlers.*;
import uk.ac.sussex.utilities.GameVersionHelper;
import uk.ac.sussex.utilities.Logger;

import com.smartfoxserver.v2.SmartFoxServer;
import com.smartfoxserver.v2.core.SFSEventType;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.entities.variables.RoomVariable;
import com.smartfoxserver.v2.entities.variables.SFSRoomVariable;
import com.smartfoxserver.v2.exceptions.SFSVariableException;
import com.smartfoxserver.v2.extensions.SFSExtension;

/**
 * @author em97
 *
 */
public class GameBackend extends SFSExtension {

	/* (non-Javadoc)
	 * @see com.smartfoxserver.v2.extensions.ISFSExtension#init()
	 */
	public void init() {
		Object[] startMessage = {"Starting GameBackend extension"};
		trace(startMessage);
		
		//Update the room variable on Lobby?
		Zone currentZone = this.getParentZone();
		Room lobby = currentZone.getRoomByName("Lobby");
		List<RoomVariable> roomVariables = lobby.getVariables();
		RoomVariable roomTitleVariable = new SFSRoomVariable("version", GameVersionHelper.CURRENT_VERSION, false, true, false);
		roomVariables.add(roomTitleVariable);
		try {
			lobby.setVariable(roomTitleVariable);
		} catch (SFSVariableException e) {
			String message = "Problem setting lobby version variable: " + e.getMessage();
			Logger.ErrorLog("GameBackend.init", message);
		}
		
		//add Event handlers
		addEventHandler(SFSEventType.USER_LOGIN, LoginHandler.class);
		addEventHandler(SFSEventType.USER_JOIN_ZONE, JoinZoneEventHandler.class);
		addEventHandler(SFSEventType.USER_LOGOUT, LogoutHandler.class);
		addEventHandler(SFSEventType.USER_DISCONNECT, LogoutHandler.class);
		
		//add Request handlers
		addRequestHandler("bank", BankMultiHandler.class);
		addRequestHandler("player", PlayerMultiHandler.class);
		addRequestHandler("game", GameMultiHandler.class);
		addRequestHandler("comms", CommsMultiHandler.class);
		addRequestHandler("room", RoomMultiHandler.class);
		addRequestHandler("village", VillageMultiHandler.class);
		addRequestHandler("home", HomeMultiHandler.class);
		addRequestHandler("seasons", SeasonsMultiHandler.class);
		addRequestHandler("farm", FarmMultiHandler.class);
		addRequestHandler("market", MarketMultiHandler.class);
		
		
		//add timed events
		SmartFoxServer sfs = SmartFoxServer.getInstance();
		sfs.getTaskScheduler().scheduleAtFixedRate(new ClearTickerRunner(this), 0, 1, TimeUnit.MINUTES);
	}
}
