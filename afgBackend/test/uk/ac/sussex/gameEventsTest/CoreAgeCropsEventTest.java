package uk.ac.sussex.gameEventsTest;

import static org.junit.Assert.*;

import java.util.HashSet;
import java.util.Set;

import org.junit.Test;

import uk.ac.sussex.gameEvents.CoreAgeCropsEvent;
import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;

public class CoreAgeCropsEventTest {

	@Test
	public void testFireEvent() {
		//I'm going to need some fields in a dummy game, one with crop and one without. 
		//Attached to hearths in a dummy game. 
		GameFactory gf = new GameFactory();
		Game testGame = new Game();
		try {
			testGame = gf.fetchGame(1);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unexpected error fetching game: " + e.getMessage());
		}
		CoreAgeCropsEvent event = new CoreAgeCropsEvent(testGame);
		try {
			event.fireEvent();
		} catch (Exception e) {
			e.printStackTrace();
			fail("There was a problem firing the event: " + e.getMessage());
		}
		try{
			HearthFactory hf = new HearthFactory();
			Set<Hearth> hearths = hf.fetchGameHearths(testGame);
			FieldFactory ff = new FieldFactory();
			Set<Field> fields = new HashSet<Field>();
			for (Hearth hearth : hearths){
				fields.addAll(ff.getHearthFields(hearth));
			}
			for (Field field : fields){
				Integer fieldId = field.getId();
				switch (fieldId) {
					case 3:
						assertNull(field.getCrop());
						assertNull(field.getCropAge());
						break;
					case 4:
						assertNotNull(field.getCrop());
						assertEquals((Integer) 1, field.getCropAge());
						break;
					case 5:
						assertNull(field.getCrop());
						assertNull(field.getCropAge());
						break;
					case 12:
						//This field also has a field hazard to apply.
						assertNotNull(field.getCrop());
						assertEquals((Integer) 25, field.getCropHealth());
						break;
					case 13:
						//This field doesn't.
						assertNotNull(field.getCrop());
						assertEquals((Integer) 60, field.getCropHealth());
						break;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			fail("There was a problem testing.");
		}
	}

}
