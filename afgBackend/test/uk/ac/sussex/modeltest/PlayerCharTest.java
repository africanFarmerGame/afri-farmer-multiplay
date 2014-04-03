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
