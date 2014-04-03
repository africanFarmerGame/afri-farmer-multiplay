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
