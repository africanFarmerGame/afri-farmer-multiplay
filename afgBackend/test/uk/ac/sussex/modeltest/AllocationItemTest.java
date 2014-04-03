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
