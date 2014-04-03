/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

/**
 * 
 */
package uk.ac.sussex.handlers;

import uk.ac.sussex.model.Player;
import uk.ac.sussex.model.PlayerFactory;
import uk.ac.sussex.utilities.Logger;

import com.smartfoxserver.bitswarm.sessions.ISession;
import com.smartfoxserver.v2.core.ISFSEvent;
import com.smartfoxserver.v2.core.SFSEventParam;
import com.smartfoxserver.v2.exceptions.SFSErrorCode;
import com.smartfoxserver.v2.exceptions.SFSErrorData;
import com.smartfoxserver.v2.exceptions.SFSException;
import com.smartfoxserver.v2.exceptions.SFSLoginException;
import com.smartfoxserver.v2.extensions.BaseServerEventHandler;

/**
 * @author em97
 *
 */
public class LoginHandler extends BaseServerEventHandler {

	/* (non-Javadoc)
	 * @see com.smartfoxserver.v2.extensions.IServerEventHandler#handleServerEvent(com.smartfoxserver.v2.core.ISFSEvent)
	 */
	@Override
	public void handleServerEvent(ISFSEvent event) throws SFSException {
		Object[] message = {"Attempting a login"};
		trace(message);
		
		//IDBManager dbManager = this.getParentExtension().getParentZone().getDBManager();
		String username = (String) event.getParameter(SFSEventParam.LOGIN_NAME);
		if(!username.matches("^create\\|\\w+")){
			
			this.normalLogin(event);
			
		} 
		
	}
	private void normalLogin(ISFSEvent event) throws SFSException {
		PlayerFactory playerFactory = new PlayerFactory();
		String username = (String) event.getParameter(SFSEventParam.LOGIN_NAME);
		String password = (String) event.getParameter(SFSEventParam.LOGIN_PASSWORD);
		try {
			Player player = playerFactory.fetchPlayer(username);
			
			String storedPass = player.getLoginPassword();
			ISession session = (ISession) event.getParameter(SFSEventParam.SESSION);
			if(!getApi().checkSecurePassword(session, storedPass, password)) {
				// Fire an exception to deal with below.
		        throw new Exception("Invalid password");
		    }
			
			Logger.Log(username, "Logged in");
			session.setProperty("player", player);
			
		} catch (Exception e) {
			SFSErrorData errData;
			String errMessage;
			if(e.getMessage().contains("password")){
				errData = new SFSErrorData(SFSErrorCode.LOGIN_BAD_PASSWORD);
				errMessage = "Bad password";
			} else if (e.getMessage().contains("username")) {
				//Ok, so it's a username problem. Throw the bad username error message. 
		        errData = new SFSErrorData(SFSErrorCode.LOGIN_BAD_USERNAME);
		        errMessage = "Unknown username";
			} else {
				errData = new SFSErrorData(SFSErrorCode.GENERIC_ERROR);
				errMessage = e.getMessage();
			}
			errData.addParameter(username);
	        throw new SFSLoginException(errMessage, errData);
		}
	}

}
