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

import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.HearthFactory;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;
import uk.ac.sussex.model.tasks.Task;
import uk.ac.sussex.model.tasks.TaskList;
import uk.ac.sussex.model.tasks.TaskFarmElsewhere;
import uk.ac.sussex.model.tasks.TaskOption;

public class TaskFarmElsewhereTest {

	@Test
	public void testGetDisplayName() {
		TaskList tl = fetchTaskList (1);
		TaskFarmElsewhere tfe = this.fetchNewTaskFarmElsewhere(tl);
		String displayName = tfe.getDisplayName();
		assertTrue (TaskFarmElsewhere.DISPLAYNAME.equals(displayName));
	}

	@Test
	public void testExecute() {
		TaskList tl = fetchTaskList(1);
		Task task9 = null;
		try {
			task9 = tl.getHouseholdTask(9);
		} catch (Exception e) {
			e.printStackTrace();
			fail("couldn't get the household task");
		}
		task9.execute();
		assertTrue(task9.getStatus() == -1);
		Task task10 = null;
		try {
			task10 = tl.getHouseholdTask(10);
		} catch (Exception e) {
			e.printStackTrace();
			fail("couldn't get the household task");
		}
		task10.execute();
		assertTrue(task10.getStatus() == 1);
	}

	@Test
	public void testFetchPossibleLocations() {
		//The possible locations for this task are the other hearths in the game. 
		TaskList tl = fetchTaskList(2);
		TaskFarmElsewhere testTask = this.fetchNewTaskFarmElsewhere(tl);
		Hearth testHearth = this.fetchHousehold(1);
		Set<TaskOption> locations = testTask.fetchPossibleLocations(testHearth);
		assertNotNull(locations);
		assertEquals(1, locations.size()); //There are only 2 hearths set up for this game.
		TaskOption location = locations.iterator().next();
		assertEquals((Integer) 2, location.getValue());
		assertTrue(location.getType().equals("HEARTH"));
	}

	@Test
	public void testFetchPossibleActors() {
		TaskList tl = fetchTaskList(1);
		Hearth household = fetchHousehold(1);
		TaskFarmElsewhere farmTask = fetchNewTaskFarmElsewhere(tl);
		
		Set<TaskOption> farmers = farmTask.fetchPossibleActors(household);
		assertNotNull(farmers);
		assertEquals((int) 2, farmers.size());
	}

	@Test
	public void testFetchPossibleAssets() {
		TaskList tl = fetchTaskList(1);
		Hearth household = fetchHousehold(1);
		TaskFarmElsewhere farmTask = fetchNewTaskFarmElsewhere(tl);
		
		Set<TaskOption> assets = farmTask.fetchPossibleAssets(household);
		assertNull(assets);
	}
	@Test 
	public void testCreateNew() {
		TaskList tl = fetchTaskList(1);
		try {
			TaskFarmElsewhere testTask = (TaskFarmElsewhere) tl.newTaskInstance(TaskFarmElsewhere.TASKTYPE);
			assertTrue(testTask.getDisplayName().equals(TaskFarmElsewhere.DISPLAYNAME));
		} catch (Exception e) {
			e.printStackTrace();
			fail("We didn't manage to create the task.");
		}
	}
	private TaskList fetchTaskList(Integer gameId){
		TaskList tl = null;
		try {
			GameFactory gf = new GameFactory();
			Game game = gf.fetchGame(gameId);
			tl = game.fetchTaskList();
			return tl;
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the tasklist");
			return null;
		}
	}
	private Hearth fetchHousehold(Integer householdId){
		HearthFactory hf = new HearthFactory();
		try {
			Hearth household = hf.fetchHearth(householdId);
			return household;
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the household");
			return null;
		}
	}
	private TaskFarmElsewhere fetchNewTaskFarmElsewhere(TaskList tl){
		TaskFarmElsewhere testTask = null;
		try {
			testTask = (TaskFarmElsewhere) tl.newTaskInstance(TaskFarmElsewhere.TASKTYPE);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to generate a new task.");
		}
		return testTask;
	}
}
