/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import org.junit.Test;

import uk.ac.sussex.model.AllChars;
import uk.ac.sussex.model.Allocation;
import uk.ac.sussex.model.AllocationFactory;
import uk.ac.sussex.model.AllocationItem;
import uk.ac.sussex.model.Asset;

public class AllocationItemTest {

	@Test
	public void testSave() {
		AllocationFactory af = new AllocationFactory();
		Allocation a = null;
		Asset asset = new Asset();
		asset.setId(7);
		AllChars character = new AllChars();
		character.setId(16);
		
		try {
			a = af.fetchAllocation(1);
		} catch (Exception e) {
			fail("Problem getting the allocation: " + e.getMessage());
			e.printStackTrace();
		}
		AllocationItem ai = new AllocationItem();
		try {
			ai.setAllocation(a);
			ai.setAmount(0);
			ai.setAsset(asset);
			ai.setCharacter(character);
			ai.save();
			assertNotSame(ai.getId(), 0);
		} catch (Exception e) {
			fail ("Problem saving: " + e.getMessage());
			e.printStackTrace();
		}
	}

}
