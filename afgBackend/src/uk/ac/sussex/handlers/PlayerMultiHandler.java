/**
 * 
 */
package uk.ac.sussex.handlers;

import uk.ac.sussex.model.Player;
import uk.ac.sussex.model.PlayerFactory;
import uk.ac.sussex.utilities.Logger;

import com.smartfoxserver.v2.annotations.MultiHandler;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.extensions.SFSExtension;

/**
 * @author em97
 *
 */
@MultiHandler
public class PlayerMultiHandler extends BaseClientRequestHandler {

	/* (non-Javadoc)
	 * @see com.smartfoxserver.v2.extensions.IClientRequestHandler#handleClientRequest(com.smartfoxserver.v2.entities.User, com.smartfoxserver.v2.entities.data.ISFSObject)
	 */
	@Override
	public void handleClientRequest(User sender, ISFSObject params) {
		// Obtain the request id
        String requestId = params.getUtfString(SFSExtension.MULTIHANDLER_REQUEST_ID);
        Object[] message = {requestId};
        trace(message);
        switch(PlayerMultiEnum.toOption(requestId)) {
        case CREATE: 
        	try {
        		ISFSObject myObj = SFSObject.newInstance();
        		this.createPlayer(params);
        		send("Createuser_success", myObj, sender);
        	} catch (Exception e){
        		ISFSObject errorObj = SFSObject.newInstance(); 
        		String error = "Error creating player: " + e.getMessage();
    	        errorObj.putUtfString("message", error);
    	        Logger.ErrorLog("PlayerMultiHandler.handleClientRequest (" + requestId + ")", error);
    			send("Createuser_error", errorObj, sender);
        	}
        	break;
        /**case CHAR_DETAIL:
        	try{
        		ISFSObject myObj = this.getPlayerCharDetail(params, sender);
        		send(requestId+"_success", myObj, sender);
        	} catch (Exception e) {
        		ISFSObject errorObj = SFSObject.newInstance();
        		errorObj.putUtfString("message", e.getMessage());
        		send(requestId+"_error", errorObj, sender);
        	}
        	break;*/
        default:
        	ISFSObject errObj = new SFSObject();
        	errObj.putUtfString("message", "Unable to action request " + requestId);
        	Logger.ErrorLog("PlayerMultiHandler.handleClientRequest", sender.getName() + " tried to action " + requestId);
        	send("player_error", errObj, sender);
        }
	}
	private void createPlayer(ISFSObject params) throws Exception{
		
		PlayerFactory pf = new PlayerFactory();
		
		String newUsername = params.getUtfString("username");
		String newPwd = params.getUtfString("newpwd");
		Player player = null;
		try {
			player = pf.createPlayer(newUsername, newPwd);
		} catch(Exception e) {
			String message = "Problem creating requested player " + newUsername + ": " + e.getMessage() ;
			Logger.ErrorLog("PlayerMultiHandler.createPlayer", message);
			throw new Exception(message);
		}
		if(player==null){
			Logger.ErrorLog("PlayerMultiHandler.createPlayer", "Not sure why, but no player was created for username " + newUsername + ", password " + newPwd);
		}
	}
	/**
	 * For now this deals with the sender's player char, but should really do something with 
	 * all player chars, depending on some identifier thing!
	 * @param params
	 * @param sender
	 * @return
	 * @throws Exception
	 */
	/**private ISFSObject getPlayerCharDetail(ISFSObject params, User sender) throws Exception{
		ISFSObject returnDetails = SFSObject.newInstance();
		PlayerChar currentChar = (PlayerChar) sender.getProperty("pc");
		if(currentChar == null){
			throw (new Exception("Player character data was null"));
		}
		returnDetails.putUtfString("charName", currentChar.getName());
		returnDetails.putUtfString("gameName", currentChar.getGame().getGameName());
		returnDetails.putUtfString("roleID", currentChar.getRole().getId());
		return returnDetails;
	}*/

}
