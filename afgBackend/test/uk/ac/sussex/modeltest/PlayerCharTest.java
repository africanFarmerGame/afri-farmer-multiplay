/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

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

import uk.ac.sussex.model.NPC;
import uk.ac.sussex.model.NPCFactory;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
//import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.model.Role;
import uk.ac.sussex.model.RoleFactory;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;

/**
 * @author em97
 *
 */
public class PlayerCharTest {
	
	
	/**
	 * Test method for {@link uk.ac.sussex.model.base.BaseObject#save()}.
	 */
	@Test
	public void testSave() {
		PlayerChar myChar = new PlayerChar();
		try {
			myChar.save();
			fail("Saving character worked when it shouldn't have.");
		} catch (Exception e) {
			String message = e.getMessage();
			System.out.print(message);
			assertTrue(message.contains("Role|Null||")&&!message.contains("Id|Null||"));
		}
		RoleFactory rf = new RoleFactory();
		GameFactory gf = new GameFactory();
		try {
			Role role = rf.fetchRole("BANKER");
			myChar.setRole(role);
			Game game = gf.fetchGame(1);
			myChar.setGame(game);
		} catch (Exception e) {
			fail("Unexpected problem with the extra factories: "+ e.getMessage());
		}
		try {
			myChar.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail ("Problem saving the character: "+ e.getMessage());
		}
	}

	/**
	 * Test method for {@link uk.ac.sussex.model.base.BaseObject#validateWith(uk.ac.sussex.validator.IClassAttributeValidator)}.
	 */
	@Test
	public void testValidateWith() {
		fail("Not yet implemented");
	}
	@Test
	public void testBabyCount() {
		PlayerCharFactory pcf = new PlayerCharFactory();
		PlayerChar woman = null;
		try {
			woman = pcf.fetchPlayerChar(32);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't fetch the woman");
		}
		NPCFactory npcf = new NPCFactory();
		Set<NPC> babies = null;
		try {
			babies = npcf.fetchPCBabies(woman);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get the babies.");
		}
		
		assertNotNull(woman);
		//assertEquals((Integer) 1, woman.getBabyCount());
		assertEquals(woman.getBabyCount(), (Integer) babies.size());
	}
}
