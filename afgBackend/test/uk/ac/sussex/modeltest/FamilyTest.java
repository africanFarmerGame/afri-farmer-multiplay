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
