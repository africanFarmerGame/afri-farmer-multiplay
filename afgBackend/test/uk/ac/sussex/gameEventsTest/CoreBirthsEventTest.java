package uk.ac.sussex.gameEventsTest;

import static org.junit.Assert.*;

import java.util.Date;

import org.junit.Test;

import uk.ac.sussex.gameEvents.CoreBirthsEvent;
import uk.ac.sussex.model.game.CoreGame;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;

public class CoreBirthsEventTest {

	@Test
	public void testFireEvent() {
		//Not quite sure how to test this one. It's random.
		Date date = new Date();
		
		Game game = createGame("BirthTest" + date.getTime());
		CoreBirthsEvent cbe = new CoreBirthsEvent(game);
		try {
			cbe.fireEvent();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to complete");
		}
	}

	private Game createGame(String gamename){
		GameFactory gf = new GameFactory();
		Game game = null;
		try {
			game = gf.createGame(CoreGame.TYPE, gamename, "", 13, gamename, 2);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to create game " + gamename);
		}
		return game;
	}
}
