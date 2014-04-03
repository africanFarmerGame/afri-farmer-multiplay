package uk.ac.sussex.modeltest.tasktest;

import static org.junit.Assert.*;

import java.util.Set;

import org.junit.Test;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;
import uk.ac.sussex.model.tasks.TaskList;
import uk.ac.sussex.model.tasks.TaskOption;
import uk.ac.sussex.model.tasks.TaskSprayInsecticide;

public class TaskSprayInsecticideTest {

	@Test
	public void testGetDisplayName() {
		TaskList tl = fetchTaskList(1);
		TaskSprayInsecticide tsi = fetchNewTaskSprayInsecticide(tl);
		assertTrue(tsi.getDisplayName().equals(TaskSprayInsecticide.DISPLAYNAME));
	}

	@Test
	public void testExecute() {
		fail("Not yet implemented");
	}

	@Test
	public void testFetchPossibleLocations() {
		TaskList tl = fetchTaskList(1);
		Hearth household = fetchHearth(7);
		TaskSprayInsecticide task = fetchNewTaskSprayInsecticide(tl);
		
		Set<TaskOption> locations  = task.fetchPossibleLocations(household);
		assertNotNull(locations);
		for(TaskOption location: locations){
			assertTrue(location.getType().equals("FIELD"));
		}
	}

	@Test
	public void testFetchPossibleActors() {
		TaskList tl = fetchTaskList(1);
		Hearth household = fetchHearth(7);
		TaskSprayInsecticide task = fetchNewTaskSprayInsecticide(tl);
		
		Set<TaskOption> actors = task.fetchPossibleActors(household);
		assertNull(actors);
	}

	@Test
	public void testFetchPossibleAssets() {
		TaskList tl = fetchTaskList(1);
		Hearth household = fetchHearth(7);
		TaskSprayInsecticide task = fetchNewTaskSprayInsecticide(tl);
		Set<TaskOption> assets = task.fetchPossibleAssets(household);
		assertNotNull(assets);
		assertEquals((int) 1, assets.size());
	}
	private TaskList fetchTaskList(Integer gameId) {
		GameFactory gf = new GameFactory();
		Game game = null;
		try {
			game = gf.fetchGame(gameId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to get the game");
		}
		return game.fetchTaskList();
	}
	private TaskSprayInsecticide fetchNewTaskSprayInsecticide(TaskList tl){
		TaskSprayInsecticide tsi = null;
		try {
			tsi = (TaskSprayInsecticide) tl.newTaskInstance(TaskSprayInsecticide.TASKTYPE);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to get new task");
		}
		return tsi;
	}
	private Hearth fetchHearth(Integer hearthId){
		HearthFactory hf = new HearthFactory();
		Hearth hearth = null;
		try {
			hearth = hf.fetchHearth(hearthId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Just can't get the hearth " + hearthId);
		}
		return hearth;
	}
}
