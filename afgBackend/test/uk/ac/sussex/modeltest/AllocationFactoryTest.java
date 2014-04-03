package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import java.util.Set;

import org.junit.Test;

import uk.ac.sussex.model.Allocation;
import uk.ac.sussex.model.AllocationFactory;
import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.HearthFactory;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;

public class AllocationFactoryTest {

	@Test
	public void testFetchAllocations() {
		AllocationFactory af = new AllocationFactory();
		Game game = fetchGame(1);
		
		Hearth h = null;
		try {
			h = createHearth(game, "allocationHearth");
		} catch (Exception e) {
			e.printStackTrace();
			fail ("Problem with the hearth. " + e.getMessage());
		}
		createAllocation(h, game.getGameYear(), "correctyear");
		createAllocation(h, game.getGameYear()+ 1, "incorrectyear");
		try {
			Set<Allocation> allocations = af.fetchHearthAllocations(h, game.getGameYear());
			assertNotNull(allocations);
			assertEquals(allocations.size(), 1);
		} catch (Exception e){
			fail ("Problem with the fetching of allocations. " + e.getMessage());
			e.printStackTrace();
		}
	}

	@Test 
	public void testCreateOrUpdateAllocation() {
		AllocationFactory af = new AllocationFactory();
		Integer testId = -1;
		String testAllocationName = "SampleAllocation";
		Integer selected = 0;
		Hearth hearth = null;
		try {
			hearth = fetchHearth(10);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the hearth");
		}
	
		Game game = fetchGame(hearth.getGame().getId());
		
		Allocation allocation = null;
		try {
			allocation = af.createOrUpdateAllocation(testId, testAllocationName, selected, hearth, game, 0);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to generate allocation");
		}
		assertNotNull(allocation);
		assertTrue(allocation.getId()!=-1);
	}
	@Test
	public void testTemp () {
		GameFactory gf = new GameFactory();
		Game game = null;
		try {
			game = gf.fetchGame(2);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Game issue");
		}
		
		HearthFactory hf = new HearthFactory();
		Hearth hearth = null;
		try {
			hearth = hf.fetchHearth(47);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Hearth issue");
		}
		AllocationFactory af = new AllocationFactory();
		Set<Allocation> allocations = null;
		try {
			allocations = af.fetchHearthAllocations(hearth, game.getGameYear());
		} catch (Exception e) {
			e.printStackTrace();
			fail("fetch alloc issues.");
		}
		
		assertTrue(allocations.size()>0);
	}
	
	private Hearth fetchHearth(Integer hearthId) throws Exception{
		HearthFactory hf = new HearthFactory();
		Hearth hearth = hf.fetchHearth(hearthId);
		return hearth;
	}
	private Game fetchGame(Integer gameId) {
		GameFactory gf = new GameFactory();
		Game game = null; 
		try {
			game = gf.fetchGame(gameId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unexpected problem fetching game " + gameId);
		}
		return game;
	}
	private Hearth createHearth(Game game, String hearthName) throws Exception {
		Hearth hearth = new Hearth();
		hearth.setGame(game);
		hearth.setHousenumber(14);
		hearth.setName(hearthName);
		hearth.save();
		
		return hearth;
	}
	private Allocation createAllocation(Hearth hearth, Integer year, String name){
		Allocation allocation = new Allocation();
		allocation.setDeleted(0);
		allocation.setGameYear(year);
		allocation.setHousehold(hearth);
		allocation.setName(name);
		allocation.setSelected(0);
		try {
			allocation.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to create allocation " + name);
		}
		return allocation;
	}
}
