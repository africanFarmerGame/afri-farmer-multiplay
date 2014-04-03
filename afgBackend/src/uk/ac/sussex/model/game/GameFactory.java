/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

/**
 * Keeps track of game objects
 */
package uk.ac.sussex.model.game;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import uk.ac.sussex.model.base.BaseFactory;
import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.model.base.RestrictionList;

/**
 * @author eam31
 *
 */
public class GameFactory extends BaseFactory {
	public GameFactory() {
		super(new Game());
		//super(new Game());
	}
	public Game fetchGame(Integer gameId) throws Exception{
		
		try {
			Game game = (Game) this.fetchSingleObject(gameId);
			
			return game;
		} catch (Exception e) {
			e.printStackTrace();
			String eMessage = e.getMessage();
			if(eMessage.contains("identifier")){
				throw new Exception ("No game found with that name.");
			} else {
				throw new Exception (eMessage);
			}
		}
		
	}
	/**
	 * Creates a new game object and logs it. 
	 * 
	 * @param gameName (String) required and must be unique.
	 * @param password (String) may be null.
	 * @param numPlayers (Integer) Maximum players allowed in the game.
	 * @param villageName (String) Name used for the village in the game.
	 * @param teamSelfSelect (Integer) Indicates whether the teams select themselves or are randomly assigned.  
	 * @param householdSize (Integer) The number of playerchars per household by default. 
	 * @return the new game object.
	 * @throws Exception
	 */
	public Game createGame(String gameType, String gameName, String password, Integer numPlayers, String villageName, Integer householdSize ) throws Exception {
		Game game = GameFactory.newGame(gameType);
		game.setGameName(gameName);
		if(password != null){
			game.setGamePassword(password);
		}
		game.setVillageName(villageName);
		game.setMaxPlayers(numPlayers);
		game.setVillageName(villageName);
		game.setHouseholdSize(householdSize);
		game.save(); //This needs to happen before the players etc can be created - which happens when the game changes season.
		game.changeGameStage();
		game.save();
		
		return game;
	}
	/**
	 * Fetches any games that are currently active and have fewer players than the maximum they are set up for. 
	 * @return
	 */
	public List<Game> fetchOpenGames() {
		RestrictionList rl = new RestrictionList();
		rl.addEqual("active", (Integer) 1);
		rl.addGTProperty("maxPlayers", "playerCount");
		try {
			List<BaseObject> li = this.fetchManyObjects(rl);
			List<Game> lg = new LinkedList<Game>();
			for (BaseObject item: li){
				lg.add((Game) item);
			}
			return lg;
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return null;
		
	}
	/**
	 * Returns a list of all of the available game types. 
	 * Needs adding to when a new game type is implemented. 
	 */
	public List<Game> fetchAllGameTypes(){
		List<Game> gameList = new ArrayList<Game>();
		gameList.add(new CoreGame());
		gameList.add(new AfriGame());
		return gameList;
	}
	public static Game newGame(String gameType) throws Exception{
		if(gameType.equals(CoreGame.TYPE)){
			return new CoreGame();
		} else if (gameType.equals(AfriGame.TYPE)){
			return new AfriGame();
		} else {
			throw new Exception("Unhandled game type '" + gameType + "'.");
		}
	}
}
