/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
