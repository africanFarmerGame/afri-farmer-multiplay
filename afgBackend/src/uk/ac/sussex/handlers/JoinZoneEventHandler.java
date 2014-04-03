/**
 * 
 */
package uk.ac.sussex.handlers;

import java.util.List;
import java.util.Set;

//import uk.ac.sussex.model.Game;
import uk.ac.sussex.model.Player;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.utilities.UserHelper;

import com.smartfoxserver.bitswarm.sessions.ISession;
import com.smartfoxserver.v2.core.ISFSEvent;
import com.smartfoxserver.v2.core.SFSEventParam;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
import com.smartfoxserver.v2.entities.variables.UserVariable;
import com.smartfoxserver.v2.exceptions.SFSException;
import com.smartfoxserver.v2.extensions.BaseServerEventHandler;

/**
 * @author eam31
 *
 */
public class JoinZoneEventHandler extends BaseServerEventHandler {

	/* (non-Javadoc)
	 * @see com.smartfoxserver.v2.extensions.IServerEventHandler#handleServerEvent(com.smartfoxserver.v2.core.ISFSEvent)
	 */
	@Override
	public void handleServerEvent(ISFSEvent event) throws SFSException {
		Object[] message = new Object[1];
		User currentUser = (User) event.getParameter(SFSEventParam.USER);
		ISession session = currentUser.getSession(); 
		String username = currentUser.getName();
		if(username.matches("^create\\|\\w+")){
			
			
		} else {
			//Add the player to the user.
			Player player = (Player) session.getProperty("player");
			if(player != null){
				//Using setProperty on the user rather than the api.setUserProperties because
				//setUserProperties only supports a limited number of classes. 
				currentUser.setProperty("player", player);
				
				message[0] = "Set the property 'player' to "+ player.toString();
				trace(message);
			}
			
			Zone currentZone = this.getParentExtension().getParentZone();
			Set<PlayerChar> playersChars = player.getAllCharacters();
			//For now we just get the only one that should be in there. 
			if(playersChars == null||playersChars.size() == 0 ){
				message[0] = "pre-existing but no game. Sending to Lobby";
				// add user to lobby. 
				Room lobby = currentZone.getRoomByName("Lobby");
				getApi().joinRoom(currentUser, lobby);
			} else {
				//Player has at least one character. For now take the first and go with that.
				PlayerChar currentPC = playersChars.iterator().next();
				if(currentPC == null){
					//Better let the front end know there's been a problem.
					SFSObject errObj = new SFSObject();
					errObj.putUtfString("message", "There has been a problem retrieving your character.");
					send("foundpc_error", errObj, currentUser );
					throw new SFSException("The player character is null! Error");
				}
				//Set the pc
				SFSUserVariable pcUserVar = UserHelper.fetchUserVarPC(currentPC);
				
				//currentUser.setProperty("pc", currentPC);
				List<UserVariable> currentUserVars = currentUser.getVariables();
				currentUserVars.add(pcUserVar);
				getApi().setUserVariables(currentUser, currentUserVars, true, false);
				
				SFSObject successObj = new SFSObject();
				successObj.putUtfString("message", "Successfully retrieved character.");
				send("foundpc_success", successObj, currentUser);
			}
		}
		trace(message);
	}

}
