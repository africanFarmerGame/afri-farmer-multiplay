/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

/**
 * 
 */
package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import org.junit.BeforeClass;
import org.junit.Test;

import uk.ac.sussex.model.Field;
import uk.ac.sussex.model.SeasonDetail;
import uk.ac.sussex.model.SeasonDetailFactory;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;
import uk.ac.sussex.model.seasons.SeasonalWeatherCropEffect;
import uk.ac.sussex.validator.GenericAttributeValidator;

/**
 * @author em97
 *
 */
public class SeasonDetailTest {

	private static Game game;
	
	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
		try {
			GameFactory gf = new GameFactory();
			game = gf.fetchGame(1);
			game.setCurrentSeasonDetail(null);
		} catch (Exception e) {
			String message = e.getMessage();
			if(message.contains("No game found with that name")){
				game = new Game();
				game.setGameName("game1");
				game.setMaxPlayers(3);
				game.setVillageName("Special");
				game.save();
			}
			System.out.print(message);
		}
	}
	/**
	 * Test method for {@link uk.ac.sussex.model.base.BaseObject#save()}.
	 */
	@Test
	public void testSave() {
		//fail("Not yet implemented");
		SeasonDetail sd = new SeasonDetail();
		try {
			sd.save();
			fail("Unexpectedly managed to save!");
		} catch (Exception e){
			String errorMessage = e.getMessage();
			System.out.println(errorMessage);
			assertFalse(errorMessage.contains("SeasonDetail|Id|Null"));
			assertTrue(errorMessage.contains("SeasonDetail|Game|Null"));
			assertTrue(errorMessage.contains("SeasonDetail|Season|Null"));
			assertTrue(errorMessage.contains("SeasonDetail|GameStage|Null"));
			assertFalse(errorMessage.contains("SeasonDetail|Weather|Null"));
		}
		sd.setGame(game);
		try {
			sd.save();
			fail("Unexpectedly managed to save with only game set.");
		} catch (Exception e) {
			String errorMessage = e.getMessage();
			assertFalse(errorMessage.contains("SeasonDetail|Id|Null"));
			assertFalse(errorMessage.contains("SeasonDetail|Game|Null"));
			assertTrue(errorMessage.contains("SeasonDetail|Season|Null"));
			assertTrue(errorMessage.contains("SeasonDetail|GameStage|Null"));
			assertFalse(errorMessage.contains("SeasonDetail|Weather|Null"));
		}
		//TODO Complete the test.
		fail("Test is not yet complete");
		/*SeasonFactory sf = new SeasonFactory();
		WeatherFactory wf = new WeatherFactory();
		SeasonDetail sd = new SeasonDetail();
		sd.setGame(game);
		try {
			season = sf.fetchFirstSeason();
			sd.setSeason(season);
		} catch (Exception e) {
			fail("Unexpected problem getting the pregame season: "+ e.getMessage());
		}
		
		//Try saving without the weather, which should be possible.
		try {
			sd.save();
		} catch (Exception e) {
			fail ("Problem with the save: " + e.getMessage());
		}
		//Now try adding the weather and resaving. 
		try {
			sd.setWeather(wf.fetchSeasonWeather(season));
			sd.save();
		} catch (Exception e) {
			fail("Unexpected problem setting the season: "+ e.getMessage());
		}*/
	}

	/**
	 * Test method for {@link uk.ac.sussex.model.base.BaseObject#validateWith(uk.ac.sussex.validator.IClassAttributeValidator)}.
	 */
	@Test
	public void testValidateWith() {
		GenericAttributeValidator validator = new GenericAttributeValidator();
		SeasonDetail sd = new SeasonDetail();
		try {
			sd.validateWith(validator);
		} catch (Exception e) {
			//This should fail for everything other than Id.
			String message = e.getMessage();
			System.out.print(e.getMessage());
			assertFalse(message.contains("SeasonDetail|Id|Null"));
			assertFalse(message.contains("SeasonDetail|Weather|Null"));
			assertTrue(message.contains("SeasonDetail|Season|Null"));
			assertTrue(message.contains("SeasonDetail|GameStage|Null"));
			assertTrue(message.contains("SeasonDetail|Game|Null"));
		}
		//For now, is there anything else I need to test?
	}
	@Test
	public void testFetchCropEffect(){
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		SeasonDetail sdRains = null;
		SeasonDetail sdNoWeather = null;
		try {
			sdRains = sdf.fetchSeasonDetail(2);
			sdNoWeather = sdf.fetchSeasonDetail(1);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the season details");
		}
		SeasonalWeatherCropEffect earlyMaize = null;
		SeasonalWeatherCropEffect lateMaize = null;
		SeasonalWeatherCropEffect noWeather=null;
		try {
			earlyMaize = sdRains.fetchCropEffect(2, Field.EARLY_PLANTING);
			lateMaize = sdRains.fetchCropEffect(2, Field.LATE_PLANTING);
			noWeather = sdNoWeather.fetchCropEffect(2, 0);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the crop effects");
		}
		assertNotNull(earlyMaize);
		assertEquals(Field.EARLY_PLANTING, earlyMaize.getPlantingTime());
		assertNotNull(lateMaize);
		assertEquals(Field.LATE_PLANTING, lateMaize.getPlantingTime());
		assertNull(noWeather);
	}
}
