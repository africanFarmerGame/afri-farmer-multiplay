/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import java.util.Set;

import org.junit.Test;

import uk.ac.sussex.model.*;

public class AllCharsFactoryTest {

	@Test
	public void testFetchHearthMembers() {
		Hearth hearth = fetchHousehold(1);
		
		AllCharsFactory acf = new AllCharsFactory();
		Set<AllChars> chars = null;
		try {
			chars = acf.fetchHearthMembers(hearth);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the hearth members");
		}
		assertNotNull(chars);
		assertEquals(3, chars.size());
		for(AllChars ac: chars){
			System.out.println(ac.getClass().getCanonicalName());
		}
	}

	@Test
	public void testFetchAllChar() {
		fail("Not yet implemented");
	}
	
	@Test 
	public void testCountLivingMembers() {
		Hearth hearth = fetchHousehold(79);
		AllCharsFactory acf = new AllCharsFactory();
		Integer living = 0;
		try {
			living = acf.countLivingHearthMembers(hearth);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldnt' count");
		}
		assertTrue(living>0);
	}

	private Hearth fetchHousehold(Integer householdId){
		HearthFactory hf = new HearthFactory();
		try {
			Hearth household = hf.fetchHearth(householdId);
			return household;
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the household");
			return null;
		}
	}
	
}
