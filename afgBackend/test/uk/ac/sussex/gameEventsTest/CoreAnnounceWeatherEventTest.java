package uk.ac.sussex.gameEventsTest;

import static org.junit.Assert.*;

import org.junit.Test;

import uk.ac.sussex.gameEvents.CoreAnnounceWeatherEvent;
import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;

public class CoreAnnounceWeatherEventTest {

	@Test
	public void testFireEvent() {
		GameFactory gameFactory = new GameFactory();
		Game testGame = null;
		try {
			testGame = gameFactory.fetchGame(1);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting game 'sample'");
		}
		CoreAnnounceWeatherEvent cawe = new CoreAnnounceWeatherEvent(testGame);
		try {
			cawe.fireEvent();
		} catch (Exception e) {
			e.printStackTrace();
			fail("We have a problem firing the event.");
		}
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		try {
			SeasonDetail seasonDetail = sdf.fetchCurrentSeasonDetail(testGame);
			assertNotNull(seasonDetail);
			String weather = seasonDetail.getWeather();
			assertNotNull(weather);
			assertTrue((weather.equals("RAINS"))||(weather.equals("POOR_RAINS"))||(weather.equals("NO_RAINS")));
		} catch (Exception e) {
			e.printStackTrace();
			fail ("Problem running the tests");
		}
	}

}
