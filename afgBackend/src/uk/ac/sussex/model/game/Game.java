/**
 * 
 */
package uk.ac.sussex.model.game;

import java.util.HashSet;
import java.util.Set;

import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.HearthFactory;
import uk.ac.sussex.model.Message;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.model.Role;
import uk.ac.sussex.model.RoleFactory;
import uk.ac.sussex.model.SeasonDetail;
import uk.ac.sussex.model.SeasonDetailFactory;
import uk.ac.sussex.model.SeasonNotification;
import uk.ac.sussex.model.SeasonNotificationFactory;
import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.model.grading.ICriterion;
import uk.ac.sussex.model.seasons.SeasonList;
import uk.ac.sussex.model.seasons.WeatherList;
import uk.ac.sussex.model.tasks.TaskList;
import uk.ac.sussex.model.village.Village;
import uk.ac.sussex.utilities.Logger;

/**
 * @author eam31
 *
 */
public class Game extends BaseObject{
	private Integer id;
	private String gameName = null;
	private String gamePassword = null;
	private Integer maxPlayers = 20;
	private Integer active = 1;
	private String villageName;
	private Integer playerCount = (Integer) 0;
	private SeasonDetail currentSeasonDetail;
	private Set<Hearth> hearths = new HashSet<Hearth>();
	private Set<PlayerChar> allCharacters;
	private SeasonList seasonList;
	private TaskList taskList;
	private WeatherList weatherList;
	private Integer gameYear = 0; 
	private Integer householdSize = 2;
	private String gameType;
	private String gameTypeDisplay;
	private Village villageType;
	private ICriterion gameCriteria;
	
	public Game() {
		super();
		this.addValidationParams();
	}
	private void addValidationParams(){
		this.addOptionalParam("Id"); //Should be set on save.
		this.addOptionalParam("GamePassword");
		this.addOptionalParam("CurrentSeasonDetail");
		this.addOptionalParam("AllCharacters");
		this.addStringParam("GameName", "\\w{1,50}");
	}
	/**
	 * @return the id
	 */
	public Integer getId() {
		return id;
	}
	/**
	 * @param id the id to set
	 */
	public void setId(Integer id) {
		this.id = id;
	}
	public void setGameName(String gameName) {
		this.gameName = gameName;
	}
	public String getGameName() {
		return gameName;
	}
	public void setGamePassword(String gamePassword) {
		this.gamePassword = gamePassword;
	}
	public String getGamePassword() {
		return gamePassword;
	}
	public void setMaxPlayers(Integer numPlayers) {
		this.maxPlayers = numPlayers;
	}
	public Integer getMaxPlayers() {
		return maxPlayers;
	}

	/**
	 * @param active the active to set
	 */
	public void setActive(Integer active) {
		this.active = active;
	}
	/**
	 * @return the active
	 */
	public Integer getActive() {
		return active;
	}
	/**
	 * @param villageName the villageName to set
	 */
	public void setVillageName(String villageName) {
		this.villageName = villageName;
	}
	/**
	 * @return the villageName
	 */
	public String getVillageName() {
		return villageName;
	}
	/**
	 * @param playerCount the playerCount to set
	 */
	public void setPlayerCount(Integer playerCount) {
		this.playerCount = playerCount;
	}

	/**
	 * @return the playerCount
	 */
	public Integer getPlayerCount() {
		return playerCount;
	}
	protected void setGameType(String gameType) {
		this.gameType = gameType;
	}
	public String getGameType() {
		return gameType;
	}
	
	protected void setGameTypeDisplay(String gameTypeDisplay) {
		this.gameTypeDisplay = gameTypeDisplay;
	}
	public String getGameTypeDisplay() {
		return gameTypeDisplay;
	}
	protected void setVillageType(Village villageType) {
		this.villageType = villageType;
	}
	public Village fetchVillageType() {
		return villageType;
	}
	protected void setGameCriteria(ICriterion criteria) {
		this.gameCriteria = criteria;
	}
	public ICriterion fetchGameCriteria(){
		return gameCriteria;
	}
	/**
	 * SeasonList is not a property, so we're going with fetch. Also, if seasonList is null then it gets it.
	 * @return
	 */
	public SeasonList fetchSeasonList() {
		if(this.seasonList == null){
			this.setSeasonList();
		}
		return this.seasonList;
	}
	protected void setSeasonList (){
		
	}
	protected void setSeasonList(SeasonList seasonList) {
		this.seasonList = seasonList;
	}
	/**
	 * TaskList is also not a property so again with the fetch. 
	 */
	public TaskList fetchTaskList() {
		if(this.taskList == null){
			this.setTaskList();
		}
		return this.taskList;
	}
	protected void setTaskList() {
	}
	protected void setTaskList(TaskList taskList) {
		this.taskList = taskList;
	}
	public WeatherList fetchWeatherList() {
		if(this.weatherList == null){
			this.setWeatherList();
		}
		return this.weatherList;
	}
	protected void setWeatherList(){
	}
	protected void setWeatherList(WeatherList weatherList){
		this.weatherList = weatherList;
	}
	/**
	 * @param currentSeasonDetail the currentSeasonDetail to set
	 */
	public void setCurrentSeasonDetail(SeasonDetail currentSeasonDetail) {
		this.currentSeasonDetail = currentSeasonDetail;
	}

	/**
	 * @return the currentSeasonDetail
	 */
	public SeasonDetail getCurrentSeasonDetail() {
		return currentSeasonDetail;
	}

	/**
	 * @return the gameYear
	 */
	public Integer getGameYear() {
		return gameYear;
	}
	/**
	 * @param gameYear the gameYear to set
	 */
	public void setGameYear(Integer gameYear) {
		this.gameYear = gameYear;
	}
	/**
	 * @return the householdSize
	 */
	public Integer getHouseholdSize() {
		return householdSize;
	}
	/**
	 * @param householdSize the householdSize to set
	 */
	public void setHouseholdSize(Integer householdSize) {
		this.householdSize = householdSize;
	}
	/**
	 * @param hearths the hearths to set
	 */
	public void setHearths(Set<Hearth> hearths) {
		this.hearths = hearths;
	}

	/**
	 * @return the households
	 */
	public Set<Hearth> fetchHearths() {
		if(hearths==null||hearths.size()==0){
			HearthFactory hf = new HearthFactory();
			try {
				hearths = hf.fetchGameHearths(this);
			} catch (Exception e) {
				String message = "Error fetching hearths: " + e.getMessage();
				Logger.ErrorLog("Game.fetchHearths", message);
			}
		}
		return this.hearths;
	}

	public void changeGameStage() throws Exception{
		SeasonNotificationFactory snf = new SeasonNotificationFactory();
		snf.createSeasonNotifications(this, "Stage round-up");
		SeasonList sl = this.fetchSeasonList();
		sl.changeGameStage();
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		SeasonDetail sd = sdf.generateNewSeasonDetail(this);
		this.currentSeasonDetail = sd;
		this.save();
		sl.firePreStageEvents();
		snf.updateNextSeasonNotification(this);
		
		//Add the seasonNotification as a message for each character.
		Set<PlayerChar> pcs = this.fetchAllCharacters();
		for (PlayerChar pc: pcs){
			//Get the SeasonNotification thingy.
			SeasonNotification sn = snf.fetchLatestPlayerCharNotification(pc);
			//Turn it into a new message.
			Message playerMessage = new Message();
			playerMessage.setRecipient(pc);
			playerMessage.setSubject("Stage Feedback: " + sn.getPreviousStage() + " - " + sn.getNextStage());
			playerMessage.setBody(sn.getNotification());
			playerMessage.save();
		}
	}
	public void endGame() throws Exception {
		SeasonNotificationFactory snf = new SeasonNotificationFactory();
		snf.createSeasonNotifications(this, "Stage round-up");
		SeasonList sl = this.fetchSeasonList();
		sl.endGame();
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		SeasonDetail sd = sdf.generateNewSeasonDetail(this);
		this.currentSeasonDetail = sd;
		this.setActive(0);
		this.save();
		sl.firePreStageEvents();
		snf.updateNextSeasonNotification(this);
		
		//Add the seasonNotification as a message for each character.
		Set<PlayerChar> pcs = this.fetchAllCharacters();
		for (PlayerChar pc: pcs){
			//Get the SeasonNotification thingy.
			SeasonNotification sn = snf.fetchLatestPlayerCharNotification(pc);
			//Turn it into a new message.
			Message playerMessage = new Message();
			playerMessage.setRecipient(pc);
			playerMessage.setSubject("Stage Feedback: " + sn.getPreviousStage() + " - " + sn.getNextStage());
			playerMessage.setBody(sn.getNotification());
			playerMessage.save();
		} 
	}
	/**
	 * @return the allCharacters
	 */
	public Set<PlayerChar> fetchAllCharacters() {
		if(allCharacters == null||allCharacters.size()==0){
			PlayerCharFactory pcf = new PlayerCharFactory();
			try {
				allCharacters = pcf.fetchGamePCs(this);
			} catch (Exception e) {
				String message = "Error fetching characters: " + e.getMessage();
				Logger.ErrorLog("Game.getAllCharacters", message);
			}
		}
		return allCharacters;
	}
	
	public PlayerChar fetchNewCharacter() throws Exception {
		RoleFactory rf = new RoleFactory();
		Role bankerRole = rf.fetchRole("BANKER");
		Set<PlayerChar> characters = this.fetchAllCharacters();
		for (PlayerChar character: characters){
			if((character.getRole() != bankerRole)&&character.getPlayer()==null){
				return character;
			}
		}
		return null;
	}
	
	public PlayerChar fetchBanker() throws Exception {
		RoleFactory rf = new RoleFactory();
		Role bankerRole = rf.fetchRole("BANKER");
		
		String bankerRoleId = bankerRole.getId();
		Set<PlayerChar> characters = this.fetchAllCharacters();
		for (PlayerChar character: characters){
			if(character.getRole().getId().equals(bankerRoleId)){
				return character;
			}
		}
		return null;
	}
	public Integer fetchChildCount() {
		Integer totalChildren = 0;
		for (Hearth hearth:hearths){
			totalChildren += hearth.fetchNumberOfChildren();
		}
		return totalChildren;
	}
}
