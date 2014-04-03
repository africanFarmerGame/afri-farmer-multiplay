/**
 * 
 */
package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import org.junit.Test;

import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.game.GameFactory;

/**
 * @author em97
 *
 */
public class FamilyTest {

	/**
	 * Test method for {@link uk.ac.sussex.model.base.BaseObject#save()}.
	 */
	@Test
	public void testSave() {
		//fail("Not yet implemented");
		Hearth myFamily = new Hearth();
		try {
			myFamily.save();
			fail("This family shouldn't have saved");
		} catch (Exception e) {
			//This should fail to save, due to the null game.
			String message = e.getMessage();
			System.out.print(message);
			assertTrue(message.contains("Game|Null")&&message.contains("Name|Null")&&!message.contains("Id"));
		}
		myFamily.setName("TestFam1");
		GameFactory gf = new GameFactory();
		try{
			myFamily.setGame(gf.fetchGame(1));
		} catch (Exception e) {
			fail("We have a problem setting the game value: " + e.getMessage());
		}
		try {
			myFamily.save();
		} catch (Exception e) {
			fail("This should have saved this time: " + e.getMessage());
		}
		
	}

	/**
	 * Test method for {@link uk.ac.sussex.model.base.BaseObject#validateWith(uk.ac.sussex.validator.IClassAttributeValidator)}.
	 */
	@Test
	public void testValidateWith() {
		fail("Not yet implemented");
	}

}
