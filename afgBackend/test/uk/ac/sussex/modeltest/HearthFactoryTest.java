/**
 * 
 */
package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import java.util.Set;

import org.junit.Test;

import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.HearthFactory;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;

/**
 * @author em97
 *
 */
public class HearthFactoryTest {

	/**
	 * Test method for {@link uk.ac.sussex.model.HearthFactory#createHearths(java.lang.Double, uk.ac.sussex.model.game.Game)}.
	 */
	@Test
	public void testCreateHearths() {
		fail("Not yet implemented");
	}

	/**
	 * Test method for {@link uk.ac.sussex.model.HearthFactory#fetchHearth(java.lang.Integer)}.
	 */
	@Test
	public void testFetchHearth() {
		HearthFactory hf = new HearthFactory();
		try {
			Hearth hearth = hf.fetchHearth(1); 
			assertNotNull(hearth);
			assertTrue(hearth.getClass().getName().equals("uk.ac.sussex.model.Hearth"));
		} catch (Exception e) {
			e.printStackTrace();
			fail ("Problem fetching the hearth with id 1");
		}
	}

	/**
	 * Test method for {@link uk.ac.sussex.model.HearthFactory#fetchGameHearths(java.lang.String)}.
	 */
	@Test
	public void testFetchGameHearths() {
		HearthFactory hf = new HearthFactory();
		GameFactory gf = new GameFactory();
		try {
			Game game = gf.fetchGame(1);
			Set<Hearth> hearths = hf.fetchGameHearths(game);
			assertEquals(6, hearths.size());
		} catch (Exception e) {
			fail(e.getMessage());
		}
	}

}
