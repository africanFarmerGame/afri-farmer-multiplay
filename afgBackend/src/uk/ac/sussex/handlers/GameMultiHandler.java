/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

/**
 * 
 */
package uk.ac.sussex.handlers;

import java.util.Iterator;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.Player;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.model.RoomGenerator;
import uk.ac.sussex.model.SeasonNotification;
import uk.ac.sussex.model.SeasonNotificationFactory;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;
import uk.ac.sussex.model.gameStage.GameStage;
import uk.ac.sussex.model.seasons.Season;
import uk.ac.sussex.model.seasons.SeasonList;
import uk.ac.sussex.utilities.GameHelper;
import uk.ac.sussex.utilities.Logger;
import uk.ac.sussex.utilities.UserHelper;
//import uk.ac.sussex.model.Role;

import com.smartfoxserver.v2.annotations.MultiHandler;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
import com.smartfoxserver.v2.entities.variables.UserVariable;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.extensions.SFSExtension;

/**
 * @author eam31
 *
 */
@MultiHandler
public class GameMultiHandler extends BaseClientRequestHandler {

	/* (non-Javadoc)
	 * @see com.smartfoxserver.v2.extensions.IClientRequestHandler#handleClientRequest(com.smartfoxserver.v2.entities.User, com.smartfoxserver.v2.entities.data.ISFSObject)
	 */
	@Override
	public void handleClientRequest(User user, ISFSObject params) {
		// TODO Auto-generated method stub
		// Obtain the request id
        String requestId = params.getUtfString(SFSExtension.MULTIHANDLER_REQUEST_ID);
        try {
	        switch (GameMultiOption.toOption(requestId)){
		        case CREATEGAME:
		        	this.createGame(user, params);
		        		
		        	SFSObject myObj = new SFSObject();
		        	myObj.putUtfString("message", "A new game has been created with you as banker.");
		        	send("Creategame_success", myObj, user);
		        	break;
		        case FETCHACTIVEGAMES:
		        	this.fetchActiveGames(user);
		        	break;
		        case JOINGAME:
		        	try {
		        		this.joinGame(user, params);
		        		//this.enterGame(user);
		        		ISFSObject returnObj = SFSObject.newInstance();
		        		returnObj.putUtfString("message", "We successfully joined a game.");
		        		send(requestId+"_success", returnObj, user);
		        	} catch (Exception e) {
		        		ISFSObject errorObj = SFSObject.newInstance();
		        		errorObj.putUtfString("message", e.getMessage());
		        		send(requestId+"_error", errorObj, user);
		        	}
		        	break;
		        case ENTERGAME:
	        		this.enterGame(user);
	        		ISFSObject returnObj = SFSObject.newInstance();
	        		returnObj.putUtfString("message", "Successfully entered a game.");
	        		
	        		send(requestId+"_success", returnObj, user);
		        	break;
		        case FETCHGAMETYPES:
		        	Logger.Log(user.getName(), "Is fetching a list of game types.");
		        	this.fetchGameTypes(user);
		        	break;
		        case END_GAME:
		        	Logger.Log(user.getName(), "Trying to end the game.");
		        	this.endGame(user);
		        	break;
		        default:
		        	ISFSObject errObj = new SFSObject();
		        	errObj.putUtfString("message", "Unable to action request "+requestId);
		        	send("gameError", errObj, user);
		        	Logger.ErrorLog("GameMultiHandler.handleClientRequest", "The request Id " + requestId + " was not one I am equipped to deal with.");
	        }
        } catch (Exception e) {
    		ISFSObject errObj = SFSObject.newInstance();
	    	String errorMessage = "There has been a problem with request " + requestId + ": " +e.getMessage() ;
 			errObj.putUtfString("message", errorMessage);
 			Logger.ErrorLog("GameMultiHandler.handleClientRequest(" + requestId + ")", errorMessage);
 			send(requestId + "_error", errObj, user);
        }
	}
	/**
	 * Creates a game unless there's a problem. 
	 * @param user
	 * @param params
	 * @throws Exception
	 */
	private void createGame(User user, ISFSObject params) throws Exception{
		GameFactory gf = new GameFactory();
		String gameType = params.getUtfString("GameType");
		String gameName = params.getUtfString("GameName");
		String password = params.getUtfString("Pwd");
		Integer numPlayers = params.getInt("NumPlayers"); 
		numPlayers ++; //Managers tend to forget themselves in this number. Even me.  
		String villageName = params.getUtfString("VillageName");
		Integer householdSize = params.getInt("HouseholdSize");
		Game newGame = gf.createGame(gameType, gameName, password, numPlayers, villageName, householdSize);
		
		Player player = (Player) user.getProperty("player");
		PlayerChar banker = newGame.fetchBanker();
		if(banker != null){
			banker.setPlayer(player);
		} else {
			throw new Exception ("The banker was null! Game " + newGame.getGameName());
		}
		banker.save();
		
		SFSUserVariable pcUserVar = UserHelper.fetchUserVarPC(banker);
		
		List<UserVariable> currentUserVars = user.getVariables();
		currentUserVars.add(pcUserVar);
		getApi().setUserVariables(user, currentUserVars, true, false);
		
		Logger.Log(user.getName(), "Game " + gameName + " created");
		
	}
	private void fetchActiveGames(User user) throws Exception {
		GameFactory gf = new GameFactory();
		List<Game> gameList = gf.fetchOpenGames();
		ISFSObject myObj = new SFSObject();
		if(!gameList.isEmpty()){
    		SFSArray gameNames = new SFSArray();
    		for (Game g: gameList){
    			SFSObject gameObj = SFSObject.newInstance();
    			gameObj.putInt("Id", g.getId());
    			gameObj.putUtfString("Name", g.getGameName());
    			gameNames.addSFSObject(gameObj);
    		}
    		myObj.putSFSArray("gameslist", gameNames);
		} else {
			myObj.putNull("gameslist");
		}
		send("ReceivedGameLists", myObj, user);
	}
	private void joinGame(User user, ISFSObject params) throws Exception {
		
		//String gameName = params.getUtfString("gameName");
		Integer gameId = params.getInt("gameId");
		GameFactory gf = new GameFactory();
		Game requestedGame = gf.fetchGame(gameId);
		PlayerChar pc = requestedGame.fetchNewCharacter();
		//Ok, got that. Now assign this user to it. 
		Player player = (Player) user.getProperty("player");
		
		pc.setPlayer(player);
		//This is a default - might be changed by the player in settings.
		pc.setName(player.getLoginName());
		pc.save();
		//Set the pc
		SFSUserVariable pcUserVar = UserHelper.fetchUserVarPC(pc);
		
		List<UserVariable> currentUserVars = user.getVariables();
		currentUserVars.add(pcUserVar);
		getApi().setUserVariables(user, currentUserVars, true, false);
		
		Logger.Log(user.getName(), "User joined game "+gameId);
	}
	
	private void enterGame(User user) throws Exception{
		PlayerChar pc = UserHelper.fetchUserPC(user);
		Game game = UserHelper.fetchUserGame(user);
		String roomGroup = GameHelper.fetchGameRoomgroup(game);
		
		getApi().subscribeRoomGroup(user, roomGroup);
		
		//Now I need to translate all the info to the room name I want.
		String roomName = pc.fetchHomeRoom();
		
		Zone currentZone = this.getParentExtension().getParentZone();
		
		Room joinRoom = RoomGenerator.fetchRoom(roomName, currentZone, user, roomGroup, game.getGameType());
		
		getApi().joinRoom(user, joinRoom);
		Logger.Log(user.getName(), "User signed into game "+roomGroup);
		
	}
	private void fetchGameTypes(User user) {
		GameFactory gf = new GameFactory();
		List<Game> games = gf.fetchAllGameTypes();
		SFSArray gameArray = SFSArray.newInstance();
		Iterator<Game> gameIterator = games.iterator();
		while (gameIterator.hasNext()){
			Game game = gameIterator.next();
			SFSObject gameObject = SFSObject.newInstance();
			gameObject.putUtfString("GameType", game.getGameType());
			gameObject.putUtfString("GameTypeDisplay", game.getGameTypeDisplay());
			gameArray.addSFSObject(gameObject);
		}
		SFSObject sendObject = SFSObject.newInstance();
		sendObject.putSFSArray("GameTypes", gameArray);
		send("ReturnGameTypes", sendObject, user);
	}
	private void endGame(User user) throws Exception {
		Game game = UserHelper.fetchUserGame(user);
		Logger.Log(user.getName(), "Is attempting to end game " + game.getGameName());
		game.endGame();
		
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
	}
}
