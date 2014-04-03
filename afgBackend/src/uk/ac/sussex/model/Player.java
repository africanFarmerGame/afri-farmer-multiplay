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

import java.util.Set;

import uk.ac.sussex.model.base.BaseObject;

/**
 * @author em97
 *
 */
public class Player extends BaseObject {
	private String loginName = null;
	private String loginPassword = null;
	//private Game currentGame = null;
	private Set<PlayerChar> allCharacters = null;
	
	public Player() {
		super();
		//this.addOptionalParam("CurrentGame");
		this.addOptionalParam("AllCharacters");
		this.addStringParam("LoginName", "\\w{0,50}");
	}
	
	/**
	 * @param loginName the loginName to set
	 */
	
	public void setLoginName(String loginName) {
		if(loginName!=null){
			this.loginName = loginName.toLowerCase();
		}
	}
	/**
	 * @return the loginName
	 */
	public String getLoginName() {
		return loginName;
	}
	/**
	 * @param loginPassword the loginPassword to set
	 */
	public void setLoginPassword(String loginPassword) {
		this.loginPassword = loginPassword;
	}
	/**
	 * @return the loginPassword
	 */
	public String getLoginPassword() {
		return loginPassword;
	}
	public String toString() {
		return "Player"+this.loginName;
	}
/*
	public void setCurrentGame(Game currentGame) {
		this.currentGame = currentGame;
	}

	public Game getCurrentGame() {
		return currentGame;
	}
*/
	/**
	 * @param allCharacters the allCharacters to set
	 */
	public void setAllCharacters(Set<PlayerChar> allCharacters) {
		this.allCharacters = allCharacters;
		if(allCharacters != null){
			this.allCharacters.size();
		}
	}

	/**
	 * @return the allCharacters
	 */
	public Set<PlayerChar> getAllCharacters() {
		return allCharacters;
	} 
	
	
}
