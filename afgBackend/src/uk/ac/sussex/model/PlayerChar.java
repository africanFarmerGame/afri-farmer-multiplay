/**
 * 
 */
package uk.ac.sussex.model;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;

import uk.ac.sussex.model.game.Game;

/**
 * @author em97
 *
 */
public class PlayerChar extends AllChars {
	private HashSet<PlayerChar> characters;
	private Player player;
	private Game game;
	private Integer socialStatus;
	private Integer fieldCount;
	
	public PlayerChar() {
		super();
		this.addOptionalParam("Id"); // This is optional because it is generated on save. 
		this.addOptionalParam("Name"); //This is optional because the characters are created but not named
		//this.addOptionalParam("FamilyName"); //until they get a user assigned to them. 
		this.addOptionalParam("Characters");
		this.addOptionalParam("Player");
		this.addOptionalParam("SocialStatus");
		this.addOptionalParam("FieldCount");
		this.addOptionalParam("BabyCount");
	}



	/**
	 * @param characters the characters to set
	 */
	public void setCharacters(HashSet<PlayerChar> characters) {
		this.characters = characters;
	}

	/**
	 * @return the characters
	 */
	public HashSet<PlayerChar> getCharacters() {
		return characters;
	}

	/**
	 * @param game the game to set
	 */
	public void setGame(Game game) {
		this.game = game;
	}

	/**
	 * @return the game
	 */
	public Game getGame() {
		return game;
	}

	/**
	 * @param player the player to set
	 */
	public void setPlayer(Player player){
		this.player = player;
	}

	/**
	 * @return the player
	 */
	public Player getPlayer() {
		return player;
	}

	/**
	 * @param socialStatus the socialStatus to set
	 */
	public void setSocialStatus(Integer socialStatus) {
		this.socialStatus = socialStatus;
	}

	/**
	 * @return the socialStatus
	 */
	public Integer getSocialStatus() {
		return socialStatus;
	}

	/**
	 * @param fieldCount the fieldCount to set
	 */
	public void setFieldCount(Integer fieldCount) {
		this.fieldCount = fieldCount;
	}

	/**
	 * @return the fieldCount
	 */
	public Integer getFieldCount() {
		return fieldCount;
	}

	public String fetchHomeRoom() {
		if(this.getRole().getId().equals("BANKER")){
			return RoomGenerator.generateRoomName(RoomTypes.HOME, this, "00");
		} else if (this.getHearth()==null){
			return RoomGenerator.generateRoomName(RoomTypes.VILLAGE, this, null);
		} else {
			String roomId = (String) this.getHearth().getId().toString();
			return RoomGenerator.generateRoomName(RoomTypes.HOME, this, roomId);
		}
	}
	
	public List<Field> fetchFields() throws Exception{
		FieldFactory ff = new FieldFactory();
		return ff.getPCFields(this);
	}
	@Override
	public HashMap<DietaryLevels, DietaryRequirement> fetchDietaryRequirements(){
		DietaryRequirementFactory drf = new DietaryRequirementFactory();
		return drf.fetchDietaryRequirements(this); //Needs implementing on the different char types.
	}
}
