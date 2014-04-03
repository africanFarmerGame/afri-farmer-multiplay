/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
