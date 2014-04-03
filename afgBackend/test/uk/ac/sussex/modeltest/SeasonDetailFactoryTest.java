/**
 * 
 */
package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.Test;

import uk.ac.sussex.model.SeasonDetail;
import uk.ac.sussex.model.SeasonDetailFactory;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;

/**
 * @author em97
 *
 */
public class SeasonDetailFactoryTest {

	/**
	 * Test method for {@link uk.ac.sussex.model.SeasonDetailFactory#getFirstSeason(uk.ac.sussex.model.game.Game)}.
	 */
	@Test
	public void testGetPreGameSeason() {
		fail("Not yet implemented");
	}

	/**
	 * Test method for {@link uk.ac.sussex.model.SeasonDetailFactory#generateNewSeasonDetail(uk.ac.sussex.model.game.Game)}.
	 */
	@Test
	public void testGenerateNewSeasonDetail() {
		Game seasonalGame = fetchGame(1);
		Game unseasonalGame = fetchGame(2);
		
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		SeasonDetail sd = null;
		try {
			seasonalGame.changeGameStage();
			sd = sdf.fetchCurrentSeasonDetail(seasonalGame);
		} catch (Exception e) {
			e.printStackTrace();
			fail ("Problem generating new season detail");
		}
		assertNotNull(sd);
		assertEquals((Integer)1, sd.getId());
		
		try {
			seasonalGame.changeGameStage();
			sd = sdf.fetchCurrentSeasonDetail(seasonalGame);
		} catch (Exception e) {
			e.printStackTrace();
			fail ("Problem generating the second new season detail");
		}
		assertNotNull(sd);
		assertNotNull(sd.getId());
		
		try {
			unseasonalGame.changeGameStage();
			sd = sdf.fetchCurrentSeasonDetail(unseasonalGame);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem generating the season for the game with no season.");
		}
	}
	
	@Test
	public void testFetchCurrentSeasonDetail() {
		Game seasonalGame = fetchGame(1);
		
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		SeasonDetail sd = null;
		try {
			sd = sdf.fetchCurrentSeasonDetail(seasonalGame);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem fetching the season detail: " + e.getMessage());
		}
		assertNotNull(sd);
		String season = sd.getSeason();
		assertEquals("Early Rains", season);
		assertEquals("Market Trading", sd.getGameStage());
		
		//What happens (or should happen) if asked for a null season detail? Should it return a null? 
		Game unSeasonalGame = fetchGame(2);
		SeasonDetail sd2 = null;
		try {
			sd2 = sdf.fetchCurrentSeasonDetail(unSeasonalGame);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem fetching the season detail: " + e.getMessage());
		}
		assertNull(sd2);
	}
	
	@Test 
	public void testFetchSeasonDetail() {
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		SeasonDetail sd1 = null;
		try {
			sd1 = sdf.fetchSeasonDetail(1);
		} catch (Exception e) {
			e.printStackTrace();
			fail ("There's been an error in seasondetailfactory");
		}
		assertNotNull(sd1);
		assertEquals(sd1.getGame().getId(), (Integer) 1);
	}
	@Test
	public void testFetchPreviousSeasonDetail() {
		Game sample = fetchGame(1);
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		SeasonDetail previousSD = null;
		try {
			previousSD = sdf.fetchPreviousSeasonDetail(sample);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Can't fetch the previous season detail");
		}
		assertNotNull(previousSD);
		assertEquals((Integer)3, previousSD.getId());
		assertNotNull(previousSD.getWeather());
	}
	
	@Test
	public void testFetchYearSeasonDetails() {
		Game game = fetchGame(2);
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		List<SeasonDetail> seasons = null;
		try {
			seasons = sdf.fetchYearSeasonDetails(game);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Can't fetch seasons");
		}
		assertNotNull(seasons);
		assertTrue(seasons.size()>0);
	}
	
	private Game fetchGame(Integer gameId){
		GameFactory gf = new GameFactory();
		Game game = null;
		try {
			game = gf.fetchGame(gameId);
		}catch (Exception e){
			e.printStackTrace();
			fail("Couldn't fetch game " + gameId);
		}
		return game;
	}
}
