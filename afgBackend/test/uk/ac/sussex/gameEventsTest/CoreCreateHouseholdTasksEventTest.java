package uk.ac.sussex.gameEventsTest;

import static org.junit.Assert.*;

import org.junit.Test;

import uk.ac.sussex.gameEvents.CoreCreateHouseholdTasksEvent;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;

public class CoreCreateHouseholdTasksEventTest {

	@Test
	public void testFireEvent() {
		GameFactory gf = new GameFactory();
		Game game = null;
		try {
			game = gf.fetchGame(5);
		} catch (Exception e) {
			e.printStackTrace();
			fail("can't get the game.");
		}
		CoreCreateHouseholdTasksEvent cbe = new CoreCreateHouseholdTasksEvent(game);
		try {
			cbe.fireEvent();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to complete");
		}
	}

}
