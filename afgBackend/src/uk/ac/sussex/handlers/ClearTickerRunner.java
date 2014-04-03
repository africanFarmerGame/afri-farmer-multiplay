/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.handlers;

import java.util.List;
import java.util.Set;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.ISFSExtension;

import uk.ac.sussex.model.Ticker;
import uk.ac.sussex.model.TickerFactory;
import uk.ac.sussex.utilities.GameHelper;
import uk.ac.sussex.utilities.Logger;

public class ClearTickerRunner implements Runnable {
	private ISFSExtension extension;

	public ClearTickerRunner(ISFSExtension gameBackend) {
		extension = gameBackend;
	}

	@Override
	public void run() {
		TickerFactory tf = new TickerFactory();
		Zone currentZone = extension.getParentZone();
		SFSObject outputObj = SFSObject.newInstance();
		try {
			Set<Ticker> activeTickers = tf.fetchActiveTickers();
			for(Ticker ticker:activeTickers){
				Double duration = ticker.getDuration();
				if(duration > 0){
					Long currentTimestamp = System.currentTimeMillis() / 1000;
					Long timerExpiry = (long) (ticker.getTimestamp() + duration);
					if(currentTimestamp > timerExpiry){
						//Need to kill this, and send a clear ticker message to anyone in the right game.
						List<User> users = GameHelper.fetchGameUsers(currentZone, ticker.getGame());
						if((users!= null)&&(users.size()>0)){
							extension.send("ClearTicker", outputObj, users);
						}
						ticker.setActive(0);
						ticker.save();
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			Logger.ErrorLog("ClearTickerRunner.run", "Problem removing ticker objects: " + e.getLocalizedMessage());
		}
	}

}
