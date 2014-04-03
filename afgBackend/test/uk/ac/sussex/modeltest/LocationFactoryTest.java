package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import org.junit.Test;

import uk.ac.sussex.model.Location;
import uk.ac.sussex.model.LocationFactory;

public class LocationFactoryTest {

	@Test
	public void testFetchLocation() {
		LocationFactory lf = new LocationFactory();
		try {
			Location loc = lf.fetchLocation(1);
			assertNotNull(loc);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unexpected error fetching the location " + e.getMessage());
		}
	}

}
