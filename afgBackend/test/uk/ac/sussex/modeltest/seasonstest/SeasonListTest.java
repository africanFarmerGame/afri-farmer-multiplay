/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.modeltest.seasonstest;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.Test;

import uk.ac.sussex.model.SeasonDetail;
import uk.ac.sussex.model.SeasonDetailFactory;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;
import uk.ac.sussex.model.gameStage.CoreIntroductionStage;
import uk.ac.sussex.model.gameStage.CoreMarketTradingStage;
import uk.ac.sussex.model.gameStage.GameStage;
import uk.ac.sussex.model.seasons.CoreEarlyRainsSeason;
import uk.ac.sussex.model.seasons.CorePregameSeason;
import uk.ac.sussex.model.seasons.CoreSeasonList;
import uk.ac.sussex.model.seasons.Season;
import uk.ac.sussex.model.seasons.SeasonList;
import uk.ac.sussex.model.seasons.SeasonWeather;
import uk.ac.sussex.model.seasons.WeatherList;

/**
 * @author em97
 *
 */
public class SeasonListTest {
	@Test
	public void testChangeSeason() {
		
		//Going to have to test a concrete class, not the abstract SeasonList one.
		//Need a game. 
		Game game = fetchGame(1);
		SeasonList sl = new CoreSeasonList(game); 
		
		assertNull(sl.getCurrentSeason());
		assertNull(sl.getCurrentStage());
		
		try {
			sl.changeGameStage();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Error in changing state: " + e.getMessage());
		}
		
		Season firstSeason = new CorePregameSeason(game, 0);
		GameStage firstStage = new CoreIntroductionStage();
		assertEquals(firstSeason.getName(), sl.getCurrentSeason().getName());
		assertEquals(firstStage.getName(), sl.getCurrentStage().getName());
		
		//fail("Function not complete yet");
	}
	
	@Test
	public void testFetchFirstSeason() {
		//Going to have to test a concrete class, not the abstract SeasonList one.
		//Need a game. 
		Game game = fetchGame(1);
		SeasonList sl = new CoreSeasonList(game); 
		Season actualSeason = sl.fetchFirstSeason();
		assertNotNull(actualSeason);
		
		Season expectedSeason = new CorePregameSeason(game, 0);
		assertEquals(expectedSeason.getName(), actualSeason.getName());
	}
	
	@Test
	public void testFetchSeasonList() {
		//What should happen?
		//Start with getting a game that has no seasondetail. 
		Game game = fetchGame(2);
		SeasonList sl = game.fetchSeasonList();
		assertNull(sl.getCurrentSeason());
		assertNull(sl.getCurrentStage());
		
		//Now try getting a game that does have a seasondetail set. 
		Game setSeason = fetchGame(1);
		SeasonList sl2 = setSeason.fetchSeasonList();
		Season ExpectedSeason = new CoreEarlyRainsSeason(setSeason, 0);
		GameStage ExpectedStage = new CoreMarketTradingStage();
		
		assertNotNull(sl2);
		assertNotNull(sl2.getCurrentSeason());
		assertEquals(ExpectedSeason.getName(), sl2.getCurrentSeason().getName());
		assertNotNull(sl2.getCurrentStage());
		assertEquals(ExpectedStage.getName(), sl2.getCurrentStage().getName());
		
	}
	
	@Test
	public void testFetchCurrentSeason() {
		Game game = fetchGame(1);
		SeasonList sl = game.fetchSeasonList();
		Season currentSeason = sl.getCurrentSeason();
		Season ExpectedSeason = new CoreEarlyRainsSeason(game, 1);
		
		assertNotNull(currentSeason);
 		assertEquals(ExpectedSeason.getName(), currentSeason.getName());
 		assertEquals(ExpectedSeason.getDisplayOrder(), currentSeason.getDisplayOrder());
	}
	
	@Test 
	public void testFetchingSeasonalWeather(){
		Game game = fetchGame(1);
		SeasonList sl = game.fetchSeasonList();
		@SuppressWarnings("unused") // this is fetched just to make sure that the weather is initialised. 
		WeatherList wl = game.fetchWeatherList();
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		SeasonDetail sd = null;
		try {
			sd = sdf.fetchSeasonDetail(1);
		} catch (Exception e){
			e.printStackTrace();
			fail("Problem getting hold of a seasondetail");
		}
		List<SeasonWeather> seasonWeather = sl.fetchSeasonalWeather(sd.getSeason());
		assertNotNull(seasonWeather);
		assertEquals(3, seasonWeather.size());
	}
	@Test
	public void testFetchNext(){
		//This game is wrong - not currently on intro. 
		Game intro = fetchGame(3);
		SeasonList sl = intro.fetchSeasonList();
		Season nextSeason = sl.fetchNextSeason();
		GameStage nextStage = sl.fetchNextStage();
		assertNotNull(nextStage);
		assertTrue(nextStage.getName().equals("Market Trading"));
		assertTrue(nextSeason.getName().equals(CoreEarlyRainsSeason.NAME));
		
		Game end = fetchGame(4);
		SeasonList sl2 = end.fetchSeasonList();
		GameStage noNextStage = sl2.fetchNextStage();
		Season noNextSeason = sl2.fetchNextSeason();
		assertNull(noNextSeason);
		assertNull(noNextStage);
	}
	private Game fetchGame(Integer gameId){
		GameFactory gf = new GameFactory();
		Game game = null;
		try {
			game = gf.fetchGame(gameId);
		} catch (Exception e) {
			e.printStackTrace();
			fail ("Problem fetching game setSeason: " + e.getMessage());
		}
		return game;
	}
}
