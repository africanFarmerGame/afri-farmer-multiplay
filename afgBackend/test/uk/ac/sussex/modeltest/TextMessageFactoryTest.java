package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import java.util.Set;

import org.junit.Test;

import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.model.TextMessage;
import uk.ac.sussex.model.TextMessageFactory;

public class TextMessageFactoryTest {

	@Test
	public void testFetchActiveTextMessages() {
		
		PlayerCharFactory pcf = new PlayerCharFactory();
		PlayerChar samplegm = null;
		try {
			samplegm = pcf.fetchPlayerChar(525);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the samplegm: " + e.getMessage());
		}
		
		TextMessageFactory tmf = new TextMessageFactory();
		
		Set<TextMessage> textmessages = null;
		try {
			textmessages = tmf.fetchActivePlayerTexts(samplegm);
		} catch (Exception e){
			e.printStackTrace();
			fail("Problem getting the active text messages: " + e.getMessage());
		}
		assertNotNull(textmessages);
		assertEquals(1, textmessages.size());
	}
	
	@Test
	public void testCreateMessage() {
		PlayerCharFactory pcf = new PlayerCharFactory();
		PlayerChar samplegm = null;
		PlayerChar recipient = null;
		try {
			samplegm = pcf.fetchPlayerChar(1);
			recipient = pcf.fetchPlayerChar(2);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the playerChars: " + e.getMessage());
		}
		TextMessageFactory tmf = new TextMessageFactory();
		TextMessage sms = null;
		try{
			sms  = tmf.createTextMessage(samplegm, recipient, "A test text message");
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem creating the text message: " + e.getMessage());
		}
		assertNotNull(sms);
	}

}
