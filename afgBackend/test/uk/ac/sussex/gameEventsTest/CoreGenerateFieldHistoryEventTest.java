package uk.ac.sussex.gameEventsTest;

import static org.junit.Assert.*;

import org.junit.Test;

import uk.ac.sussex.gameEvents.CoreGenerateFieldHistoryEvent;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;

public class CoreGenerateFieldHistoryEventTest {

	@Test
	public void testFireEvent() {
		Game game = fetchGame(4);
		CoreGenerateFieldHistoryEvent cgfhe = new CoreGenerateFieldHistoryEvent(game);
		try {
			cgfhe.fireEvent();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem firing.");
		}
		
	}
	private Game fetchGame(Integer gameId){
		Game game = null;
		GameFactory gf = new GameFactory();
		try {
			game = gf.fetchGame(gameId);
		} catch (Exception e) {
			e.printStackTrace(); 
			fail("Couldn't fetch game " + gameId);
		}
		return game;
	}
}
