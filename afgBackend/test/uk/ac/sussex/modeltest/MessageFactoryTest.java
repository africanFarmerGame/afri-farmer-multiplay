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
