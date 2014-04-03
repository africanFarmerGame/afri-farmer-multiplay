/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
