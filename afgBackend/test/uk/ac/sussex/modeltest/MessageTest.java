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
