package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.Test;

import uk.ac.sussex.model.*;

public class CallHistoryFactoryTest {

	@Test
	public void testFetchPlayerCallMadeHistory() {
		PlayerChar caller = fetchPlayerChar(1);
		CallHistoryFactory chf = new CallHistoryFactory();
		List<CallHistory> callHistory = null;
		try {
			callHistory = chf.fetchPlayerCallMadeHistory(caller);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't execute fetch");
		}
		assertNotNull(callHistory);
		assertTrue(callHistory.size()>0);
	}
	
	@Test 
	public void testFetchPlayerCallReceivedHistory() {
		PlayerChar receiver = fetchPlayerChar(2);
		CallHistoryFactory chf = new CallHistoryFactory();
		List<CallHistory> callHistory = null;
		try {
			callHistory = chf.fetchPlayerCallReceivedHistory(receiver);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't execute fetch");
		}
		assertNotNull(callHistory);
		assertTrue(callHistory.size()>0);
	}
	@Test
	public void testFetchUnfinishedCalls() {
		PlayerChar player = fetchPlayerChar(12);
		CallHistoryFactory chf = new CallHistoryFactory();
		List<CallHistory> unfinishedCalls = null;
		try {
			unfinishedCalls= chf.fetchUnfinishedCalls(player);
		} catch(Exception e) {
			e.printStackTrace();
			fail("Couldn't execute the fetch");
		}
		assertNotNull(unfinishedCalls);
		assertTrue(unfinishedCalls.size()==13);
	}
	
	private PlayerChar fetchPlayerChar(Integer id) {
		PlayerChar pc = null;
		PlayerCharFactory pcf = new PlayerCharFactory();
		try {
			pc = pcf.fetchPlayerChar(id);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't fetch playerChar " + id);
		}
		return pc;
	}
}
