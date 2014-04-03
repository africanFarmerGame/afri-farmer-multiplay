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

import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;

/**
 * @author em97
 *
 */
public class PlayerCharFactoryTest {

	/**
	 * Test method for {@link uk.ac.sussex.model.PlayerCharFactory#createBanker(uk.ac.sussex.model.game.Game)}.
	 */
	@Test
	public void testCreateBanker() {
		PlayerCharFactory pcf = new PlayerCharFactory();
		Game game = fetchGame(1);
		
		try{
			PlayerChar newBanker = pcf.createBanker(game);
			assertNotNull(newBanker);
			assertTrue(newBanker.getRole().getName().equals("Banker") );
		} catch (Exception e) {
			fail("Problem creating the banker: " + e.getMessage());
		}
		
	}

	/**
	 * Test method for {@link uk.ac.sussex.model.PlayerCharFactory#createWomen(java.lang.Integer, uk.ac.sussex.model.Hearth)}.
	 */
	@Test
	public void testCreateWomen() {
		PlayerCharFactory pcf = new PlayerCharFactory();
		Game game = fetchGame(1);
		try {
			pcf.createWomen(3, game);
		} catch (Exception e){
			fail ("Problem creating 3 women: " + e.getMessage());
		}
	}

	/**
	 * Test method for {@link uk.ac.sussex.model.PlayerCharFactory#createMen(java.lang.Integer, uk.ac.sussex.model.Hearth)}.
	 */
	@Test
	public void testCreateMen() {
		PlayerCharFactory pcf = new PlayerCharFactory();
		Game game = fetchGame(1);
		try {
			pcf.createMen(3, game);
		} catch (Exception e){
			fail ("Problem creating 3 men: " + e.getMessage());
		}
	}
	
	@Test
	public void testFetchMen() {
		PlayerCharFactory pcf = new PlayerCharFactory();
		Game game = fetchGame(1);
		Set<PlayerChar> men;
		try {
			men = pcf.fetchMen(game);
			assertEquals(6, men.size());
		} catch (Exception e) {
			fail ("Problem with playerCharFactory: " + e.getMessage());
		}
	}
	@Test 
	public void testFetchAll() {
		PlayerCharFactory pcf = new PlayerCharFactory();
		Game game = fetchGame(1);
		Set<PlayerChar> all = null;
		try{
			all = pcf.fetchAll(game);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem with the playerchar factory " + e.getMessage());
		}
		assertNotNull(all);
		assertEquals(22, all.size());
		Integer claimed = 0;
		Integer unclaimed = 0;
		for (PlayerChar pc : all) {
			if(pc.getPlayer() == null){
				unclaimed ++;
			} else {
				claimed ++;
			}
		}
		assertEquals((Integer) 1, claimed);
		assertEquals((Integer) 13, unclaimed);
	}
	private Game fetchGame(Integer gameId) {
		GameFactory gf = new GameFactory();
		Game game = null;
		
		try{
			game = gf.fetchGame(gameId);
		} catch(Exception e) {
			e.printStackTrace();
			fail("Problem with the gamefactory " + e.getMessage());
		}
		return game;
	}
	@Test
	public void testFetchHearthless() {
		Game game = fetchGame(11);
		PlayerCharFactory pcf = new PlayerCharFactory();
		Set<PlayerChar> hearthless = null;
		try {
			hearthless = pcf.fetchHearthlessPCs(game);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unexpected problem fetching pcs. ");
		}
		assertNotNull(hearthless);
		assertTrue(hearthless.size()>0);
	}
}
