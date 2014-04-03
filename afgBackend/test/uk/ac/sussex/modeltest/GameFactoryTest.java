/**
 * 
 */
package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import java.util.List;
import java.util.Set;

import org.junit.Test;

import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.game.AfriGame;
//import uk.ac.sussex.model.game.CoreGame;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;

/**
 * @author em97
 *
 */
public class GameFactoryTest {



	/**
	 * Test method for {@link uk.ac.sussex.model.game.GameFactory#createGame(java.lang.String, java.lang.String, java.lang.Integer)}.
	 */
	@Test
	public void testCreateGame() {
		//fail("Not yet implemented");
		//Create game needs to save a game object, 
		GameFactory gf = new GameFactory();
		Game newGame;
		try {
			newGame = gf.createGame(AfriGame.TYPE, "dummyGame2", null, 13, "village name", 2);
			//create the right number of families,
			Set<Hearth> families = newGame.fetchHearths();
			assertEquals(7, families.size());
			//and characters.
			/*Integer totalCharacters = 0;
			for (Hearth family:families){
				totalCharacters += family.getCharacters().size();
			}
			assertEquals((int) 13, (int) totalCharacters);*/
			PlayerChar banker = newGame.fetchBanker();
			assertFalse(banker == null);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unexpected error creating game: "+e.getMessage());
		}
		
		
	}
	/**
	 * Test method for {@link uk.ac.sussex.model.game.GameFactory#fetchGame(java.lang.String)}.
	 */
	@Test
	public void testFetchGame() {
		GameFactory pf = new GameFactory();
		Game game;
		try {
			game = pf.fetchGame(1);
			assertNotNull(game);
			assertEquals(game.getGameName(), "dummyGame");
			assertEquals(game.getActive(), (Integer) 1);
			assertNotNull(game.fetchSeasonList());
		} catch (Exception e) {
			e.printStackTrace();
			fail("There was an unexpected error: "+ e.getMessage());
		}
		try {
			game = pf.fetchGame(32);
			fail("There should have been an error here.");
		} catch (Exception e) {
			assertTrue(true);
		}
	}
	/**
	 *  Test method for {@link uk.ac.sussex.model.game.GameFactory#fetchOpenGames()}
	 */
	@Test
	public void testFetchOpenGames() {
		//Try the function and check for errors.
		GameFactory gf = new GameFactory();
		try {
			List<Game> games = gf.fetchOpenGames();
			//There should be some open games.
			assertTrue(games.size() > 0);
			for( Game game: games  ) {
				//Check max players hasn't been exceeded. 
				assertTrue(game.getMaxPlayers() > game.getPlayerCount());
				//Check for active games. 
				assertEquals(game.getActive(), (Integer) 1);
			}
		} catch (Exception e) {
			fail("There was an unexpected error: " + e.getMessage());
		}
	}
	
	/**
	 * This tests the {@link uk.ac.sussex.model.game.GameFactory#fetchAllGameTypes()}
	 * Will need updating when a new game type is added.
	 */
	@Test
	public void testFetchAllGameTypes() {
		GameFactory gf = new GameFactory();
		List<Game> gameList = gf.fetchAllGameTypes();
		assertNotNull(gameList);
		assertEquals(2, gameList.size());
	}
}
