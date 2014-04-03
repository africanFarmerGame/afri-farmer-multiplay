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
