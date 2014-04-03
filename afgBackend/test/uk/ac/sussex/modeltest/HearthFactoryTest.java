/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
