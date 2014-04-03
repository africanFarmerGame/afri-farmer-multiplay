/**
 * 
 */
package uk.ac.sussex.handlers;

import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.Player;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.model.Role;
import uk.ac.sussex.model.SeasonDetail;
import uk.ac.sussex.model.SeasonDetailFactory;
import uk.ac.sussex.model.SeasonNotification;
import uk.ac.sussex.model.SeasonNotificationFactory;

import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.gameStage.GameStage;
import uk.ac.sussex.model.seasons.Season;
import uk.ac.sussex.model.seasons.SeasonList;
//import uk.ac.sussex.utilities.GameHelper;
import uk.ac.sussex.utilities.Logger;
import uk.ac.sussex.utilities.UserHelper;

import com.smartfoxserver.v2.annotations.MultiHandler;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.extensions.SFSExtension;

/**
 * @author em97
 *
 */
@MultiHandler
public class SeasonsMultiHandler extends BaseClientRequestHandler {

	/* (non-Javadoc)
	 * @see com.smartfoxserver.v2.extensions.IClientRequestHandler#handleClientRequest(com.smartfoxserver.v2.entities.User, com.smartfoxserver.v2.entities.data.ISFSObject)
	 */
	@Override
	public void handleClientRequest(User user, ISFSObject params) {
		String requestId = params.getUtfString(SFSExtension.MULTIHANDLER_REQUEST_ID);
		try {
			switch (SeasonsMultiOption.toOption(requestId)){
	        case GET_SEASONS:
	        	Logger.Log(user.getName(), "Requested season details");
        		this.getSeasonDetails(user);
	        	break;
	        case CURRENT_SEASON:
	        	Logger.Log(user.getName(), "Requested current season.");
        		this.getCurrentSeason(user);
	        	break;
	        case CHANGE_STAGE:
	        	Logger.Log(user.getName(), "Asked to change the game stage");
	        	this.changeGameStage(user);
	        	break;
	        case GET_WEATHER:
	        	Logger.Log(user.getName(), "Requested the weather details");
	        	this.getWeather(user);
	        	break;
	        case FETCH_GM_STAGE_INFO:
	        	Logger.Log(user.getName(), "Requested the GM stage details.");
	        	this.getGMStageInfo(user);
	        	break;
	        default:
	        	ISFSObject errObj = new SFSObject();
	        	errObj.putUtfString("message", "Unable to action request "+requestId);
	        	send("seasonsError", errObj, user);
	        }
		} catch (Exception e) {
			ISFSObject errObj = new SFSObject();
			String message = e.getMessage();
			Logger.ErrorLog("SeasonsMultiHandler.handleClientRequest", "Problem with request " + requestId + ": " + message);
 			errObj.putUtfString("message", "There is an error with the season handler: " + message);
 			send(requestId + "_error", errObj, user);
		}
	}
	private void changeGameStage(User user) throws Exception {
		Game game = UserHelper.fetchUserGame(user);
		game.changeGameStage();
		//game.save();
		
		SeasonList sl = game.fetchSeasonList();
		Season currentSeason = sl.getCurrentSeason();
		GameStage currentStage = sl.getCurrentStage();
		SFSObject dataObj = SFSObject.newInstance();
		if(currentSeason!= null){
			dataObj.putInt("CurrentSeasonDisplay", currentSeason.getDisplayOrder());
			dataObj.putUtfString("CurrentSeasonName", currentSeason.getName());
		} else {
			dataObj.putNull("CurrentSeasonDisplay");
			dataObj.putNull("CurrentSeasonName");
		}
		if(currentStage!=null){
			dataObj.putUtfString("CurrentStageName", currentStage.getName());
		} else {
			dataObj.putNull("CurrentStageName");
		}
		dataObj.putInt("CurrentGameYear", game.getGameYear());
		//Send this notification to all currently logged on users. 
		Zone currentZone = this.getParentExtension().getParentZone();
		PlayerCharFactory pcf = new PlayerCharFactory();
		SeasonNotificationFactory snf = new SeasonNotificationFactory();
		
		Set<PlayerChar> playerChars = pcf.fetchGamePCs(game);
		for(PlayerChar pc: playerChars) {
			//Get the SeasonNotification thingy.
			SeasonNotification sn = snf.fetchLatestPlayerCharNotification(pc);

			Player player = pc.getPlayer();
			if(player!=null){	
				User playerUser = currentZone.getUserByName(player.getLoginName());
				if(playerUser!=null){
					//Add it to the dataObj. 
					SFSObject snObj = SFSObject.newInstance();
					snObj.putInt("Id", sn.getId());
					snObj.putUtfString("PreviousStage", sn.getPreviousStage());
					snObj.putUtfString("NextStage", sn.getNextStage());
					snObj.putUtfString("Notification", sn.getNotification());
					dataObj.putSFSObject("SeasonNotification", snObj);
					//Send it to the user. 
					send("GameStageChange", dataObj, playerUser);
				}
			}
		}
//		List<User> users = GameHelper.fetchGameUsers(currentZone, game.getGameName());
		
	}
	private void getSeasonDetails(User user) throws Exception {
		Game game = UserHelper.fetchUserGame(user);
		Set<Season> allDisplaySeasons = game.fetchSeasonList().fetchDisplayList(); 
		SFSObject outputObj = SFSObject.newInstance();
		SFSArray seasonArray = SFSArray.newInstance();
		//Add all but the pre-season to the obj to be sent over. 
		for (Season season : allDisplaySeasons) {
			SFSObject seasonObj = SFSObject.newInstance();
			seasonObj.putUtfString("SeasonName", season.getName());
			seasonObj.putInt("DisplayOrder", season.getDisplayOrder());
			
			SFSArray stagesArray = SFSArray.newInstance();
			List<GameStage> stages = season.getStages();
			Integer displayNum = 0;
			for (GameStage stage: stages){
				SFSObject stageObj = SFSObject.newInstance();
				stageObj.putUtfString("StageName", stage.getName());
				stageObj.putInt("DisplayOrder", displayNum);
				displayNum ++;
				stagesArray.addSFSObject(stageObj);
			}
			seasonObj.putSFSArray("SeasonStages", stagesArray);
			seasonArray.addSFSObject(seasonObj);
		}
		outputObj.putSFSArray("AllSeasons", seasonArray);
		send("SeasonsList", outputObj, user);
	}
	/**
	 * Uses the seasonlist to fetch the current season. 
	 *  
	 * @param user
	 * @throws Exception
	 */
	private void getCurrentSeason(User user) throws Exception {
		Game game = UserHelper.fetchUserGame(user);
		SeasonList sl = game.fetchSeasonList();
		Season currentSeason = sl.getCurrentSeason();
		GameStage currentStage = sl.getCurrentStage();
		SFSObject dataObj = SFSObject.newInstance();
		if(currentSeason != null){
			dataObj.putUtfString("CurrentSeasonName", currentSeason.getName());
			dataObj.putInt("CurrentSeasonDisplay", currentSeason.getDisplayOrder());
			dataObj.putInt("CurrentGameYear", game.getGameYear());
		} else {
			dataObj.putNull("CurrentSeasonName");
			dataObj.putNull("CurrentSeasonDisplay");
			dataObj.putInt("CurrentGameYear", game.getGameYear());
		}
		if(currentStage!=null){
			dataObj.putUtfString("CurrentStageName", currentStage.getName());
		} else {
			dataObj.putNull("CurrentStageName");
		}
		send("CurrentSeason", dataObj, user);
	}
	private void getWeather(User user) throws Exception {
		Game game = UserHelper.fetchUserGame(user);
		SeasonList sl = game.fetchSeasonList();
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		
		List<SeasonDetail> seasons = sdf.fetchYearSeasonDetails(game);
		SFSObject allWeatherObj = SFSObject.newInstance();
		if(seasons!=null && seasons.size()>0){
			SFSArray weatherArray = SFSArray.newInstance();
			for (SeasonDetail sd : seasons){

				String currentWeather = sd.getWeather();
				Integer displayPos = 0;
				SFSObject weatherObj = SFSObject.newInstance();
				
				if(currentWeather!=null){
					displayPos = sl.fetchSeasonDisplayPos(sd.getSeason());
					weatherObj.putUtfString("Weather", currentWeather);
					weatherObj.putInt("WeatherSeason", displayPos);
					weatherArray.addSFSObject(weatherObj);
				}
			}
			allWeatherObj.putSFSArray("WeatherList", weatherArray);
		}
		send("weather", allWeatherObj, user);
	}
	private void getGMStageInfo(User user) throws Exception {
		PlayerChar pc = UserHelper.fetchUserPC(user);
		if(!pc.getRole().getId().equals(Role.BANKER)){
			throw new Exception("Insufficient privileges to access this information.");
		}
		
		SFSObject dataObj = SFSObject.newInstance();
		
		Game game = UserHelper.fetchUserGame(user);
		SeasonList sl = game.fetchSeasonList();
		Season currentSeason = sl.getCurrentSeason();
		GameStage currentStage = sl.getCurrentStage();
		if(currentSeason!=null){
			dataObj.putUtfString("CurrentSeason", currentSeason.getName());
			dataObj.putUtfString("CurrentStage", currentStage.getName());
		} else {
			dataObj.putNull("CurrentSeason");
			dataObj.putNull("CurrentStage");
		}
		//Get the next season/stage
		GameStage nextStage = sl.fetchNextStage();
		Season nextSeason = sl.fetchNextSeason();
		
		if(nextSeason!=null){
			dataObj.putUtfString("NextSeason", nextSeason.getName());
			dataObj.putUtfString("NextStage", nextStage.getName());
		} else {
			dataObj.putNull("NextSeason");
			dataObj.putNull("NextStage");
		}
		
		//Return the data.
		send("gm_stage_info", dataObj, user);
	}
}
