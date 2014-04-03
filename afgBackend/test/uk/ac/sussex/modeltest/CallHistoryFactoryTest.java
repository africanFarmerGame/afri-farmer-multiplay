/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
