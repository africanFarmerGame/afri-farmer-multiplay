/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.handlers;

import java.util.ArrayList;
import java.util.List;

import uk.ac.sussex.model.CallHistory;
import uk.ac.sussex.model.CallHistoryFactory;
import uk.ac.sussex.model.Player;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.utilities.GameHelper;
import uk.ac.sussex.utilities.Logger;
import uk.ac.sussex.utilities.UserHelper;

import com.smartfoxserver.v2.core.ISFSEvent;
import com.smartfoxserver.v2.core.SFSEventParam;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.exceptions.SFSException;
import com.smartfoxserver.v2.extensions.BaseServerEventHandler;

public class LogoutHandler extends BaseServerEventHandler {

	@Override
	public void handleServerEvent(ISFSEvent params) throws SFSException {
		User user = (User) params.getParameter(SFSEventParam.USER);
		@SuppressWarnings("unchecked")
		List<Room> rooms = (List<Room>) params.getParameter(SFSEventParam.JOINED_ROOMS);
		
		PlayerChar pc = null;
		try {
			pc = UserHelper.fetchUserPC(user);
		} catch (Exception e) {
			Logger.ErrorLog("LogoutHandler.disconnectCall", "Problem fetching playerChar: " + e.getMessage());
		}
		if(pc!=null){
			disconnectCall(pc);
			//Then send a message to the last room they joined.
			leaveRoom(pc, rooms);
			//And make them offline.
			makePlayerOffline(pc);
		}
	}
	private void disconnectCall(PlayerChar pc){
		CallHistoryFactory chf = new CallHistoryFactory();
		List<CallHistory> unfinished = null;
		try {
			unfinished = chf.fetchUnfinishedCalls(pc);
		} catch (Exception e) {
			Logger.ErrorLog("LogoutHandler.disconnectCall", "Problem fetching unfinished calls: " + e.getMessage());
		}
		if(unfinished!=null &&unfinished.size()>0){
			List<User> sendToUsers = new ArrayList<User>();
			PlayerCharFactory pcf = new PlayerCharFactory();
			Integer playerId = pc.getId();
			for (CallHistory ch: unfinished){
				try {
					ch.setFinished(System.currentTimeMillis()/1000);
					ch.save();
					Integer callerId = ch.getCallFrom().getId();
					if(playerId.equals(callerId)){
						callerId = ch.getCallTo().getId();
					}
					PlayerChar caller = pcf.fetchPlayerChar(callerId);
					Player callerPlayer = caller.getPlayer();
					User callerUser = this.getApi().getUserByName(callerPlayer.getLoginName());
					if(callerUser!=null){
						sendToUsers.add(callerUser);
					}
				} catch (Exception e) {
					Logger.ErrorLog("LogoutHandler.disconnectCall", "Problem with call history " + ch.getId() + e.getMessage());
				}
			}
			SFSObject sendObj = SFSObject.newInstance();
			sendObj.putUtfString("message", "Call ended. " + pc.getDisplayName() + " has gone offline.");
			send("EndCall", sendObj, sendToUsers);
		}
		
	}
	private void leaveRoom(PlayerChar pc, List<Room> roomsJoined){
		List<User> roomUsers = null;
		for(Room room : roomsJoined){
			if(roomUsers == null){
				roomUsers = room.getUserList();
			} else {
				roomUsers.addAll(room.getUserList());
			}
		}
		SFSObject sendObj = SFSObject.newInstance();

		sendObj.putUtfString("playermessage", "Has gone offline.");
		sendObj.putUtfString("author", pc.getDisplayName());
		sendObj.putInt("authorid", pc.getId());
		
		send("talk_received", sendObj, roomUsers);
	}
	private void makePlayerOffline(PlayerChar pc){
		List<User> allGameUsers = GameHelper.fetchGameUsers(this.getParentExtension().getParentZone(), pc.getGame());
		SFSObject sendObject = SFSObject.newInstance();
		sendObject.putInt("pcId", pc.getId());
		sendObject.putInt("online", 0);
		send("OnlineStatusChange", sendObject, allGameUsers);
	}
}
