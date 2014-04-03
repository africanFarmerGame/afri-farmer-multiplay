/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

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
import uk.ac.sussex.model.tasks.Task;
import uk.ac.sussex.model.tasks.TaskList;
import uk.ac.sussex.model.tasks.TaskOption;
import uk.ac.sussex.model.tasks.TaskWeedCrop;

public class TaskWeedCropTest {

	@Test
	public void testExecute() {
		TaskList tl = fetchTaskList(1);
		TaskWeedCrop weedTask1 = null;
		try {
			weedTask1 = (TaskWeedCrop) tl.getHouseholdTask(7);
		} catch (Exception e1) {
			e1.printStackTrace();
			fail ("Couldn't get task 7");
		}
		FieldFactory ff = new FieldFactory();
		/*Field preField = null;
		try {
			preField = ff.getFieldById(12);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get field 12 before execute");
		}*/
		//Integer preCropHealth = preField.getCropHealth();
		weedTask1.execute();
		Field postField = null;
		try {
			postField = ff.getFieldById(12);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get field 12 after execute");
		}
		//Integer postCropHealth = postField.getCropHealth();
		//Integer healthDiff = postCropHealth - preCropHealth;
		//assertEquals((Integer) 40, healthDiff);
		assertTrue(postField.getCropWeeded()==1);
		assertNull(weedTask1.getNotes());
		assertEquals(Task.COMPLETED, weedTask1.getStatus());
		
		TaskWeedCrop weedTask2 = null;
		try {
			weedTask2 = (TaskWeedCrop) tl.getHouseholdTask(8);
		} catch (Exception e1) {
			e1.printStackTrace();
			fail("Couldn't get task 8");
		}
		Field preField2 = null;
		try {
			preField2 = ff.getFieldById(13);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get field 12 before execute");
		}
		Integer preCropHealth2 = preField2.getCropHealth();
		weedTask2.execute();
		Field postField2 = null;
		try {
			postField2 = ff.getFieldById(13);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get field 12 after execute");
		}
		Integer postCropHealth2 = postField2.getCropHealth();
		Integer healthDiff2 = postCropHealth2 - preCropHealth2;
		assertEquals((Integer) 0, healthDiff2);
		assertNotNull(weedTask2.getNotes());
		assertEquals(Task.ERROR, weedTask2.getStatus());
	}

	@Test
	public void testFetchPossibleLocations() {
		TaskList tl = fetchTaskList(1);
		Hearth household = fetchHousehold(7);
		TaskWeedCrop weedTask = fetchNewTaskWeedCrop(tl);
		Set<TaskOption> weedFields = weedTask.fetchPossibleLocations(household);
		assertNotNull(weedFields);
		assertTrue(weedFields.size()>0);
		assertEquals((int)1, weedFields.size());
	}

	@Test
	public void testFetchPossibleActors() {
		TaskList tl = fetchTaskList(1);
		Hearth household = fetchHousehold(1);
		TaskWeedCrop weedTask = null;
		try {
			weedTask = (TaskWeedCrop) tl.newTaskInstance(TaskWeedCrop.TASKTYPE);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get the weeding task");
		}
		
		Set<TaskOption> weeders = weedTask.fetchPossibleActors(household);
		assertNotNull(weeders);
		assertEquals((int) 3, weeders.size());
		for(TaskOption weeder: weeders){
			assertNotNull(weeder.getName());
			System.out.println(weeder.getName());
		}
	}

	@Test
	public void testFetchPossibleAssets() {
		TaskList tl = fetchTaskList(1);
		Hearth household = fetchHousehold(1);
		TaskWeedCrop testTask = null;
		try {
			testTask = (TaskWeedCrop) tl.newTaskInstance(TaskWeedCrop.TASKTYPE);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to generate a new task.");
		}
		Set<TaskOption> assets = testTask.fetchPossibleAssets(household);
		assertNull(assets);
	}
	@Test 
	public void testCreateNew() {
		TaskList tl = fetchTaskList(1);
		try {
			TaskWeedCrop testTask = (TaskWeedCrop) tl.newTaskInstance(TaskWeedCrop.TASKTYPE);
			assertTrue(testTask.getDisplayName().equals(TaskWeedCrop.DISPLAYNAME));
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
	private TaskWeedCrop fetchNewTaskWeedCrop(TaskList tl){
		TaskWeedCrop testTask = null;
		try {
			testTask = (TaskWeedCrop) tl.newTaskInstance(TaskWeedCrop.TASKTYPE);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to generate a new task.");
		}
		return testTask;
	}
}
