package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import java.util.Set;

import org.junit.Test;

import uk.ac.sussex.model.AllChars;
import uk.ac.sussex.model.Allocation;
import uk.ac.sussex.model.AllocationFactory;
import uk.ac.sussex.model.AllocationItem;
import uk.ac.sussex.model.AllocationItemFactory;
import uk.ac.sussex.model.AssetFactory;
import uk.ac.sussex.model.AssetFood;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;

public class AllocationItemFactoryTest {

	@Test
	public void testFetchAllocationItems() {
		AllocationFactory af = new AllocationFactory();
		Allocation a = null;
		try {
			a = af.fetchAllocation(1);
		} catch (Exception e) {
			fail ("Problem getting a. " + e.getMessage());
			e.printStackTrace();
		}
		AllocationItemFactory aif = new AllocationItemFactory();
		try {
			Set<AllocationItem> ais = aif.fetchAllocationItems(a);
			assertNotNull(ais);
		} catch (Exception e) {
			fail ("Problem getting ais. " + e.getMessage());
			e.printStackTrace();
		}
	}
	@Test
	public void testFetchCharacterAllocationItems() {
		Allocation allocation = fetchAllocation(1);
		AllChars character = fetchCharacter(9);
		AssetFactory af = new AssetFactory();
		Set<AssetFood> foods = null;
		try {
			foods = af.fetchFoodAssets();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get the food.");
		}
		assertNotNull(foods);
		int foodCount = foods.size();
		AllocationItemFactory aif = new AllocationItemFactory();
		Set<AllocationItem> items = null;
		try {
			items = aif.fetchCharacterAllocationItems(allocation, character);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't fetch the items");
		}
		assertNotNull(items);
		assertEquals(items.size(), foodCount);
	}
	@Test
	public void testAddCharacterAllocationItems() {
		AllChars character = fetchCharacter(45);
		Allocation allocation = fetchAllocation(50);
		AllocationItemFactory aif = new AllocationItemFactory();
		try {
			aif.createAdultAllocationItems(character, allocation);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unexpected fail.");
		}
	}
	@Test
	public void testDeleteCharacterAllocationItems() {
		AllChars character = fetchCharacter(45);
		Allocation allocation = fetchAllocation(50);
		AllocationItemFactory aif = new AllocationItemFactory();
		try {
			aif.removeCharAllocationItems(character, allocation);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unexpected fail.");
		}
	}
	private Allocation fetchAllocation(Integer allocationId) {
		AllocationFactory af = new AllocationFactory();
		Allocation a = null;
		try {
			a = af.fetchAllocation(allocationId);
		} catch (Exception e) {
			fail ("Problem getting a. " + e.getMessage());
			e.printStackTrace();
		}
		return a;
	}
	private AllChars fetchCharacter(Integer charId){
		PlayerCharFactory pcf = new PlayerCharFactory();
		PlayerChar pc = null;
		try {
			pc = pcf.fetchPlayerChar(charId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't find the character");
		}
		return pc;
	}
}
