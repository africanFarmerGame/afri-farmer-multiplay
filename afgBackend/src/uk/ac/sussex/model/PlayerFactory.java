/**
 * 
 */
package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseFactory;
import uk.ac.sussex.utilities.Logger;

/**
 * @author em97
 *
 */
public class PlayerFactory extends BaseFactory {
	
	public PlayerFactory() {
		super(new Player());
	}
	public Player fetchPlayer(String username) throws Exception{
		if(username==null){
			throw new Exception("Cannot fetch player with null username");
		}
		Player player = null;
		try {
			String actualUsername = username.toLowerCase();
			player = (Player) this.fetchSingleObject(actualUsername);
		} catch (Exception e) {
			String eMessage = e.getMessage();
			if(eMessage.contains("identifier")){
				throw new Exception ("No player found with username " + username);
			} else {
				throw new Exception (eMessage);
			}
		}
		return player;
	}
	public Player createPlayer(String username, String password) throws Exception {
		if(username==null){
			throw new Exception("Cannot create player with null username");
		}
		Player player = null;
		try{
			player = fetchPlayer(username);
			if(player!=null){
				throw new Exception("This player already exists.");
			}
		} catch (Exception e){
			String message = e.getMessage();
			if(message.contains("exists")){
				throw e;
			} else {
				player = new Player();
			}
		}
		player.setLoginName(username);
		player.setLoginPassword(password);
		player.save();
		
		Logger.Log(username, "User created");
		return player;
	}
	
}
