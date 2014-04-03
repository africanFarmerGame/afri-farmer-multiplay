/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

/**
 * 
 */
package uk.ac.sussex.gameEventsTest;

import static org.junit.Assert.*;

import org.junit.Test;

import uk.ac.sussex.gameEvents.CoreAnnounceHealthHazardEvent;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;

/**
 * @author em97
 *
 */
public class CoreAnnounceHealthHazardEventTest {

	/**
	 * Test method for {@link uk.ac.sussex.gameEvents.CoreAnnounceHealthHazardEvent#fireEvent()}.
	 */
	@Test
	public void testFireEvent() {
		Game game = fetchGame(1);
		CoreAnnounceHealthHazardEvent cahhe = new CoreAnnounceHealthHazardEvent(game);
		try {
			cahhe.fireEvent();
		} catch (Exception e) {
			e.printStackTrace();
			fail("There was a problem firing the event.");
		}
		
	}
	private Game fetchGame(Integer gameId) {
		GameFactory gf = new GameFactory();
		Game game = null;
		try {
			game = gf.fetchGame(gameId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't fetch game");
		}
		return game;
	}
}
