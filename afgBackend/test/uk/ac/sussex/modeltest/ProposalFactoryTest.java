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

import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.HearthFactory;
import uk.ac.sussex.model.Proposal;
import uk.ac.sussex.model.ProposalFactory;

public class ProposalFactoryTest {

	@Test
	public void testFetchOutgoingHearthProposals() {
		fail("Not yet implemented");
	}

	@Test
	public void testFetchIncomingHearthProposals() {
		Hearth testHearth = fetchHearth(29);
		ProposalFactory propFactory = new ProposalFactory();
		List<Proposal> proposals = null;
		try {
			proposals = propFactory.fetchIncomingHearthProposals(testHearth);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to fetch proposals");
		}
		assertNotNull(proposals);
		assertEquals(4, proposals.size());
	}

	@Test
	public void testFetchOutgoingPersonProposals() {
		fail("Not yet implemented");
	}

	@Test
	public void testFetchIncomingPersonProposals() {
		fail("Not yet implemented");
	}
	
	private Hearth fetchHearth(Integer hearthId) {
		HearthFactory hf = new HearthFactory();
		Hearth hearth = null;
		try {
			hearth = hf.fetchHearth(hearthId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem fetching hearth " + hearthId);
		}
		return hearth;
	}
}
