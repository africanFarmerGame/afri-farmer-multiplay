package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import org.junit.Test;

import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.model.Proposal;

public class ProposalTest {

	@Test
	public void testSave() {
		Proposal prop = new Proposal();
		try {
			prop.save();
			fail("Unexpected success saving");
		} catch (Exception e) {
			e.printStackTrace();
			String message = e.getMessage();
			assertTrue(message.contains("Proposal|Target|Null||"));
			assertTrue(message.contains("Proposal|Proposer|Null||"));
		}
		//Test with a proposer
		PlayerChar proposer = fetchPC(1);
		//That proposer will be a gm with a null hearth.
		prop.setProposer(proposer);
		PlayerChar target = fetchPC(7);
		//This is a woman, with a hearth. The logic of this is wrong. I'll have to supplement with some logic. 
		prop.setTarget(proposer);
		prop.setTargetHearth(target.getHearth());
		try {
			prop.save();
			
		} catch (Exception e) {
			e.printStackTrace();
			fail("Should have saved at this point.");
		}
		assertNotNull(prop.getId());
		assertTrue(prop.getId()>0);
	}
	
	private PlayerChar fetchPC(Integer playerId) {
		PlayerCharFactory pcf = new PlayerCharFactory();
		PlayerChar samplegm = null;
		try {
			samplegm = pcf.fetchPlayerChar(playerId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the samplegm: " + e.getMessage());
		}
		return samplegm;
	}

}
