/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
