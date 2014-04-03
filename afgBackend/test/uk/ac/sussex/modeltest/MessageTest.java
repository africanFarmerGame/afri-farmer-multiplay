/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import org.junit.Test;

import uk.ac.sussex.model.Message;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;

public class MessageTest {

	@Test
	public void testSave() {
		Message message = new Message();
		try {
			message.save();
			fail("Unexpected success");
		} catch (Exception e) {
			e.printStackTrace();
			String error = e.getMessage();
			assertTrue(error.contains("Message|Subject|Null||"));
			assertTrue(error.contains("Message|Body|Null||"));
			assertTrue(error.contains("Message|Recipient|Null||"));
			//Id is optional, and deleted, unread and timestamp are all set when the object is created.
			assertFalse(error.contains("Message|Id|Null||"));
			assertFalse(error.contains("Message|Deleted|Null||"));
			assertFalse(error.contains("Message|Unread|Null||"));
			assertFalse(error.contains("Message|Timestamp|Null||"));
			
		}
		message.setBody("This message is a test of my messaging functionality.");
		message.setRecipient(fetchPC(3));
		message.setSubject("Test message, checking the deal.");
		try {
			message.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unexpected failure");
		}
		assertNotNull(message.getId());
	}
	private PlayerChar fetchPC(Integer pcId) {
		PlayerCharFactory pcf = new PlayerCharFactory();
		PlayerChar pc = null;
		try {
			pc = pcf.fetchPlayerChar(pcId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to fetch pc " + pcId);
		}
		return pc;
	}
}
