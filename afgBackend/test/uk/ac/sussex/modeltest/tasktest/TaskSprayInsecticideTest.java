/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
