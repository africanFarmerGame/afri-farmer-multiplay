package uk.ac.sussex.gameEventsTest;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.Test;

import uk.ac.sussex.gameEvents.CoreGenerateFinesEvent;
import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;

public class CoreGenerateFinesEventTest {

	@Test
	public void testFireEvent() {
		GameFactory gameFactory = new GameFactory();
		Game game = null;
		try {
			game = gameFactory.fetchGame(1);
		} catch (Exception e) {
			e.printStackTrace();
			fail("can't get game");
		}
		CoreGenerateFinesEvent finesEvent = new CoreGenerateFinesEvent(game);
		try {
			finesEvent.fireEvent();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem running");
		}
		BillFactory ff = new BillFactory();
		//Hearth hearth1 = fetchHearth(1);
		Hearth hearth2 = fetchHearth(19);
		List<Bill> fines1 = null;
		List<Bill> fines2 = null;
		try {
			//fines1 = ff.fetchHearthFines(hearth1);
			fines2 = ff.fetchHearthFines(hearth2);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Probelm getting fines. ");
		}
		assertEquals(0, fines2.size());
		assertNotNull(fines1);
	}
	private Hearth fetchHearth(Integer hearthid){
		HearthFactory hf = new HearthFactory();
		Hearth hearth = null;
		try {
			hearth= hf.fetchHearth(hearthid);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem with the hearths");
		}
		return hearth;
	}
}
