/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import java.util.List;
import java.util.Set;

import org.junit.Test;

import uk.ac.sussex.model.Asset;
import uk.ac.sussex.model.Field;
import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.HearthFactory;
import uk.ac.sussex.model.PlayerChar;

public class HearthTest {

	/**
	 * Test method for {@link uk.ac.sussex.model.Hearth#getCharacters}.
	 */
	@Test
	public void testGetCharacters() {
		HearthFactory hf = new HearthFactory();
		try {
			Hearth hearth = hf.fetchHearth(2);
			Set<PlayerChar> chars = hearth.getCharacters();
			assertNotNull(chars);
			assertTrue(chars.size()>0);
		}
		catch (Exception e) {
			e.printStackTrace();
			fail("Unexpected error " + e.getMessage());
		}
	}
	
	@Test
	public void testFetchFields() {
		HearthFactory hf = new HearthFactory();
		Hearth hearth = null;
		try {
			hearth = hf.fetchHearth(15);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem fetching hearth");
		}
		try {
			List<Field> fields = hearth.fetchFields();
			assertNotNull(fields);
			//assertEquals( 5, fields.size());
			for (Field field : fields){
				System.out.println("Id: " + field.getId());
				System.out.println(field.getName());
				System.out.println("Quality: " + field.getQuality());
			
				Asset crop = field.getCrop();
				if(crop==null){
					System.out.println("No crop");
				} else {
					System.out.println(crop.getId());
					System.out.println(field.getCropAge());
					System.out.println(field.getCropHealth());
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			fail ("Problem fetching fields");
		}
	}
	
}
