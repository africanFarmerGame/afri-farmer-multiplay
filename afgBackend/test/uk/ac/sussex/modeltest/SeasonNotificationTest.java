package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import org.junit.Test;

import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.model.SeasonDetail;
import uk.ac.sussex.model.SeasonDetailFactory;
import uk.ac.sussex.model.SeasonNotification;

public class SeasonNotificationTest {

	@Test
	public void testSave() {
		SeasonNotification sn = new SeasonNotification();
		try {
			sn.save();
			fail("Didn't fail when it should have!");
		} catch (Exception e) {
			e.printStackTrace();
			String message = e.getMessage();
			assertTrue(message.contains("SeasonNotification|Character|Null||"));
			assertTrue(message.contains("SeasonNotification|PreviousSeason|Null||"));
			assertTrue(message.contains("SeasonNotification|PreviousStage|Null||"));
			assertTrue(message.contains("SeasonNotification|Notification|Null||"));
			assertFalse(message.contains("SeasonNotification|Id|Null||"));
			assertFalse(message.contains("SeasonNotification|NextSeason|Null||"));
			assertFalse(message.contains("SeasonNotification|NextStage|Null||"));
		}
		sn.setCharacter(fetchPlayerChar(2));
		sn.setNotification("This is a test notification");
		SeasonDetail previousSeason = fetchSeasonDetail(1);
		sn.setPreviousSeason(previousSeason);
		
		sn.setPreviousStage(previousSeason.getSeason() + " " + previousSeason.getGameStage());
		try {
			sn.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem saving sn");
		}
		assertNotNull(sn.getId());
	}
	private PlayerChar fetchPlayerChar(Integer charId){
		PlayerChar pc = null;
		PlayerCharFactory pcf = new PlayerCharFactory();
		try {
			pc = pcf.fetchPlayerChar(charId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem fetching playerChar id=" + charId);
		}
		return pc;
	}
	private SeasonDetail fetchSeasonDetail(Integer sdId){
		SeasonDetail sd = null;
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		try {
			sd = sdf.fetchSeasonDetail(sdId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem fetching seasondetail id="+ sdId);
		}
		return sd;
	}
}
