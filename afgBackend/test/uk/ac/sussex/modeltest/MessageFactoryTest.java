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

import uk.ac.sussex.model.Message;
import uk.ac.sussex.model.MessageFactory;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;

public class MessageFactoryTest {

	@Test
	public void testFetchPCMessages() {
		MessageFactory mf = new MessageFactory();
		PlayerChar pc = fetchPC(3);
		List<Message> messages = null;
		try {
			messages = mf.fetchPCMessages(pc);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Bit of a problem");
		}
		
		assertNotNull(messages);
		assertTrue(messages.size()>0);
	}
	private PlayerChar fetchPC(Integer pcId) {
		PlayerCharFactory pcf = new PlayerCharFactory();
		PlayerChar pc = null;
		try {
			pc = pcf.fetchPlayerChar(pcId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting pc " + pcId);
		}
		return pc;
	}
}
