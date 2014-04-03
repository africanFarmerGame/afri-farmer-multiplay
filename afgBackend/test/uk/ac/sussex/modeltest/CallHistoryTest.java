package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import org.junit.Test;

import uk.ac.sussex.model.*;

public class CallHistoryTest {

	@Test
	public void testCreate() {
		CallHistory callHistory = new CallHistory();
		try {
			callHistory.save();
			fail("Call History saved when it shouldn't");
		} catch (Exception e) {
			e.printStackTrace();
			String message = e.getMessage();
			assertTrue(message.contains("CallHistory|CallTo|Null||"));
			assertTrue(message.contains("CallHistory|CallFrom|Null||"));
			assertTrue(message.contains("CallHistory|Started|Null||"));
			assertFalse(message.contains("CallHistory|Answered|Null||"));
			assertFalse(message.contains("CallHistory|Finished|Null||"));
			assertFalse(message.contains("CallHistory|Id|Null||"));
		}
		PlayerChar pc1 = fetchPlayerChar(1);
		PlayerChar pc2 = fetchPlayerChar(2);
		
		callHistory.setCallFrom(pc1);
		callHistory.setCallTo(pc2);
		System.out.println(System.currentTimeMillis() / 1000);
		callHistory.setStarted(System.currentTimeMillis() / 1000);
		try {
			callHistory.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't save when we should");
		}
		assertNotNull(callHistory.getId());
		
	}
	private PlayerChar fetchPlayerChar(Integer charId) {
		PlayerCharFactory pcf = new PlayerCharFactory();
		PlayerChar pc = null;
		try {
			pc = pcf.fetchPlayerChar(charId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get the pc " + charId);
		}
		return pc;
	}
}
