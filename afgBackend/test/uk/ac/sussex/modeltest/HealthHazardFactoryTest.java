package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import org.junit.Test;

import uk.ac.sussex.model.DietaryLevels;
import uk.ac.sussex.model.HealthHazard;
import uk.ac.sussex.model.HealthHazardFactory;

public class HealthHazardFactoryTest {

	@Test
	public void testFetchHealthHazardById() {
		HealthHazardFactory hhf = new HealthHazardFactory();
		HealthHazard hazard = null;
		try {
			hazard = hhf.fetchHealthHazardById(1);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting hazard 1");
		}
		assertNotNull(hazard);
		assertTrue(hazard.getId().equals(1));
	}

	@Test
	public void testFetchRandomHealthHazard() {
		HealthHazardFactory hhf = new HealthHazardFactory();
		HealthHazard hazard = null;
		try {
			hazard = hhf.fetchRandomHealthHazard(DietaryLevels.A);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Can't get a random hazard");
		}
		assertNotNull(hazard);
		assertTrue(hazard.getDietLevel().equals(DietaryLevels.A.toString()));
	}
	
}
