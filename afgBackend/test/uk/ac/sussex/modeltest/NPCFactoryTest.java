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

import uk.ac.sussex.model.*;

public class NPCFactoryTest {

	@Test
	public void testFetchHearthWomen() {
		Hearth hearth = fetchHearth(1);
		NPCFactory npcf = new NPCFactory();
		Set<NPC> women = null;
		try {
			women = npcf.fetchHearthWomen(hearth);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Big problem.");
		}
		assertNotNull(women);
		assertEquals(1, women.size());
	}
	private Hearth fetchHearth(Integer hearthid){
		HearthFactory hf = new HearthFactory();
		Hearth hearth = null;
		try {
			hearth = hf.fetchHearth(hearthid);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to retrieve hearth " + hearthid);
		}
		return hearth;
	}
}
