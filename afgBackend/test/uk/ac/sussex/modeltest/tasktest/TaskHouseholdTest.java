/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

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
import uk.ac.sussex.model.tasks.TaskHousehold;
import uk.ac.sussex.model.tasks.TaskList;
import uk.ac.sussex.model.tasks.TaskOption;

public class TaskHouseholdTest {

	@Test
	public void testGetDisplayName() {
		TaskList tl = fetchTaskList(1);
		TaskHousehold th = fetchNewTaskHousehold(tl);
		assertNotNull(th);
		assertNotNull(th.getDisplayName());
		assertTrue(th.getDisplayName().equals(TaskHousehold.DISPLAYNAME));
	}

	@Test
	public void testExecute() {
		fail("Not yet implemented");
	}

	@Test
	public void testFetchPossibleLocations() {
		TaskList tl = fetchTaskList(1);
		TaskHousehold th = fetchNewTaskHousehold(tl);
		Hearth household = getHousehold(1);
		Set<TaskOption> locations = th.fetchPossibleLocations(household);
		assertNotNull(locations);
		assertEquals(locations.size(), 1);
	}

	@Test
	public void testFetchPossibleActors() {
		fail("Not yet implemented");
	}

	@Test
	public void testFetchPossibleAssets() {
		TaskList tl = fetchTaskList(1);
		TaskHousehold th = fetchNewTaskHousehold(tl);
		Hearth household = getHousehold(1);
		Set<TaskOption> assets = th.fetchPossibleAssets(household);
		assertNull(assets);
	}
	private TaskList fetchTaskList(Integer gameId){
		TaskList tl = null;
		try {
			GameFactory gf = new GameFactory();
			Game game = gf.fetchGame(gameId);
			tl = game.fetchTaskList();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the tasklist");
		}
		return tl;
	}
	private TaskHousehold fetchNewTaskHousehold(TaskList tl){
		TaskHousehold th = null;
		try {
			th = (TaskHousehold) tl.newTaskInstance(TaskHousehold.TASKTYPE);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get the task.");
		}
		return th;
	}
	private Hearth getHousehold(Integer hearthId) {
		HearthFactory hf = new HearthFactory();
		try {
			Hearth household = hf.fetchHearth(hearthId);
			return household;
		} catch (Exception e) {
			e.printStackTrace();
			fail("We didn't manage to get the household we needed.");
		}
		return null;
	}
}
