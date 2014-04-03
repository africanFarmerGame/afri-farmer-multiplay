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
