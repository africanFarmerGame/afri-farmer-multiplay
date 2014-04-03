/**
 * 
 */
package uk.ac.sussex.modeltest;

import org.junit.Test;

import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.Role;
import uk.ac.sussex.model.RoleFactory;
import uk.ac.sussex.model.SeasonDetail;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;
import uk.ac.sussex.model.seasons.CoreEarlyRainsSeason;
import uk.ac.sussex.model.seasons.CorePregameSeason;
import uk.ac.sussex.model.seasons.Season;
import uk.ac.sussex.model.seasons.SeasonList;
import uk.ac.sussex.validator.AttributeValidatorException;
import uk.ac.sussex.validator.GenericAttributeValidator;
import static org.junit.Assert.*;

/**
 * @author em97
 *
 */
public class GameTest {
	@Test
	public void testGameValidation(){
		Game game = new Game();
		game.setGameName("valid1");
		try {
			game.validateWith(new GenericAttributeValidator());
			assertTrue(true);
		} catch (AttributeValidatorException e) {
			e.printStackTrace();
			fail("problem with validating the game: " + e.getMessage());
		}
		
		game.setGameName("myridiculouslylonggamenamethatshouldtriggeranerrorinthevalidationthingummyhopefully");
		try {
			game.validateWith(new GenericAttributeValidator());
			fail("Unexpectedly no problem with really long game name.");
		} catch (AttributeValidatorException e) {
			assertTrue(e.getMessage().contains("GameName|RegexFail"));
		}
	}
	@Test
	public void testGameActive(){
		Game game = new Game();
		game.setGameName("valid1");
		game.setActive(1);
		try {
			game.validateWith(new GenericAttributeValidator());
			assertEquals((Integer) 1, game.getActive());
		} catch (AttributeValidatorException e) {
			e.printStackTrace();
			fail("Problem validating active game set to 1: " + e.getMessage());
		}
		
		game.setActive(0);
		try {
			game.validateWith(new GenericAttributeValidator());
			assertEquals((Integer) 0, game.getActive());
		} catch (AttributeValidatorException e) {
			e.printStackTrace();
			fail ("Problem validating active game set to 0: "+ e.getMessage());
		}
	}
	@Test
	public void testFetchNewCharacter() {
		//fail("not yet implemented");
		//use the dummyGame. 
		GameFactory gf = new GameFactory();
		try {
			Game game = gf.fetchGame(1);
			PlayerChar player = game.fetchNewCharacter();
			assertNotNull(player);
			assertNull(player.getName());
			
			RoleFactory rf = new RoleFactory();
			Role bankerRole = rf.fetchRole("BANKER");
			
			assertFalse(bankerRole == player.getRole());
			
		} catch (Exception e) {
			fail ("Problem with the game factory: " + e.getMessage());
		}
	}
	@Test
	public void testFetchBanker() {
		//use the dummyGame.
		GameFactory gf = new GameFactory();
		try {
			Game game = gf.fetchGame(1);
			PlayerChar banker = game.fetchBanker();
			assertNotNull(banker);
		} catch (Exception e) {
			fail("Problem with the game factory: " + e.getMessage());
		}
	}
	@Test 
	public void testPlayerCount() {
		//use the dummyGaem
		GameFactory gf = new GameFactory();
		try {
			Game game = gf.fetchGame(1);
			assertEquals( (Integer)14, game.getPlayerCount());
		} catch (Exception e) {
			fail("Problem fetching the game and getting the player count: " + e.getMessage());
		}
	}
	@Test 
	public void testGetChildCount(){
		GameFactory gf = new GameFactory();
		try {
			Game game = gf.fetchGame(1);
			Integer childCount = game.fetchChildCount(); 
			assertTrue(childCount <= 12 );
			System.out.print("Child count: " + childCount);
		} catch (Exception e) {
			fail ("Problem counting the children: " + e.getMessage());
		}
	}
	
	@Test
	public void testChangeGameStage(){
		GameFactory gf = new GameFactory();
		Game game = null;
		try{
			game = gf.fetchGame(1);
		} catch (Exception e) {
			String message = e.getMessage();
			if(message.contains("No game found with that name")){
				game = new Game();
				game.setGameName("testGame");
				game.setMaxPlayers(20);
				game.setVillageName("Much Wenlock");
				try {
					game.save();
				} catch (Exception e1) {
					fail("Problem saving a game out");
				}
			} else {
				fail("Unexpected problem fetching the game. " + message);
			}
		}
		try {
			game.changeGameStage();
			game.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem changing stage: " + e.getMessage());
		}
		SeasonDetail sd = game.getCurrentSeasonDetail();
		assertNotNull(sd);
		Season preseason = new CorePregameSeason(game, 0);
		assertEquals(preseason.getName(), sd.getSeason());
		
	}
	@Test
	public void testChangingSavedGameStage(){
		GameFactory gf = new GameFactory();
		Game game = null;
		try{
			game = gf.fetchGame(1);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the game.");
		}
		//Now we just need to try changing that one more time to see if it gets the next season.
		try {
			game.changeGameStage();
			game.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem changing game stage from Introductions: " + e.getMessage());
		}
		SeasonDetail sd = game.getCurrentSeasonDetail();
		sd = game.getCurrentSeasonDetail();
		SeasonList sl = game.fetchSeasonList();
		Season earlyRains = new CoreEarlyRainsSeason(game, 1);
		assertEquals(earlyRains.getName(), sd.getSeason());
		assertEquals(earlyRains.getName(), sl.getCurrentSeason().getName());
	}
	@Test
	public void testGetCurrentSeasonDetail(){
		GameFactory gf = new GameFactory();
		try {
			Game game = gf.fetchGame(2);
			SeasonDetail sd = game.getCurrentSeasonDetail();
			assertFalse(sd==null);
			
		} catch (Exception e) {
			fail ("Problem getting the current season detail: " + e.getMessage());
		}
	}
	@Test
	public void testSave() {
		Game game = new Game();
		try {
			game.save();
			fail("Unexpected success");
		} catch (Exception e) {
			e.printStackTrace();
			String error = e.getMessage();
			assertTrue(error.contains("Game|GameName|Null||"));
			assertFalse(error.contains("Game|Id|Null||"));
			assertTrue(error.contains("Game|VillageName|Null||"));
		}
		game.setGameName("RandomTest");
		game.setVillageName("Tester Green");
		try {
			game.save();
			assertNotNull(game.getId());
		} catch(Exception e) {
			e.printStackTrace();
			fail("Unexpected problem");
		}
	}
	
	@Test
	public void testEndGame() {
		Game game = this.fetchGame(1);
		try{
			game.endGame();
		} catch(Exception e) {
			e.printStackTrace();
			fail("Couldn't end the game.");
		}
	}
	private Game fetchGame(Integer gameId) {
		GameFactory gf = new GameFactory();
		Game game = null;
		try{
			game = gf.fetchGame(gameId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the game.");
		}
		return game;
	}
}
