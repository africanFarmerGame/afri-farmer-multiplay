package uk.ac.sussex.utilitiestest;

import static org.junit.Assert.*;

import org.junit.Test;

import uk.ac.sussex.utilities.Logger;

public class LoggerTest {

	@Test
	public void testErrorLog() {
		Logger.ErrorLog("testErrorLog", "Testing the testy thing.");
		fail("Test not really written yet.");
	}

}
