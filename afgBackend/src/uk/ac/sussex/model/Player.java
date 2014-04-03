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
