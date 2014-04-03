package uk.ac.sussex.modeltest.tasktest;

import static org.junit.Assert.*;

import java.util.List;
import java.util.Set;

import org.junit.Test;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;
import uk.ac.sussex.model.tasks.Task;
import uk.ac.sussex.model.tasks.TaskList;
import uk.ac.sussex.model.tasks.TaskOption;
import uk.ac.sussex.model.tasks.TaskSowEarlyCrop;
import uk.ac.sussex.model.tasks.TaskSowLateCrop;

public class TaskSowCropTest {

	@Test
	public void testExecuteEarlyAndLatePlanting() {
		Hearth earlyHousehold = fetchHousehold(105);
		Hearth lateHousehold = fetchHousehold(100);
		AssetFactory af = new AssetFactory();
		Asset sorghum = null;
		AssetOwnerFactory aof = new AssetOwnerFactory();
		AssetOwner earlySorghum;
		AssetOwner lateSorghum;
		FieldFactory ff = new FieldFactory();
		Field earlyfield = null;
		Field lateField = null;
		GameFactory gf = new GameFactory();
		Game game = null;
		TaskList tl = null;
		Integer earlyFieldId = 109;
		try {
			game = gf.fetchGame(1);
			tl = game.fetchTaskList();
			sorghum = af.fetchAsset("Beans");
			earlySorghum = aof.fetchSpecificAsset(earlyHousehold, sorghum);
			lateSorghum = aof.fetchSpecificAsset(lateHousehold, sorghum);
			Double currentAmount = earlySorghum.getAmount();
			earlySorghum.setAmount(currentAmount + 1);
			earlySorghum.save();
			currentAmount = lateSorghum.getAmount();
			lateSorghum.setAmount(currentAmount +1);
			lateSorghum.save();
			
			earlyfield = ff.getFieldById(earlyFieldId);
			earlyfield.setCrop(null);
			earlyfield.setCropAge(null);
			earlyfield.setCropHealth(null);
			earlyfield.setCropPlanting(null);
			earlyfield.save();
			lateField = ff.getFieldById(120);
			lateField.setCrop(null);
			lateField.setCropAge(null);
			lateField.setCropHealth(null);
			lateField.setCropPlanting(null);
			lateField.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem in the top section.");
		}
		TaskSowEarlyCrop earlytsc = null;
		try {
			earlytsc = (TaskSowEarlyCrop) tl.newTaskInstance(TaskSowEarlyCrop.TASKTYPE);
			earlytsc.setActor(fetchHouseholdPC(earlyHousehold));
			earlytsc.setLocation(earlyfield);
			earlytsc.setAsset(sorghum);
			earlytsc.setAssetAmount(1);
			earlytsc.setHousehold(earlyHousehold);
			earlytsc.setSeason(game.getCurrentSeasonDetail());
			earlytsc.setTaskNumber(1300);
			earlytsc.save();
		} catch (Exception e1) {
			e1.printStackTrace();
			fail ("Problem getting the new task");
		}
		try {
			earlytsc.execute();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem with the execute for early crop.");
		}
		
			//assertEquals(currentAmount, maizeOwner.getAmount());
		Field postTestField = null;
		try {
			postTestField = ff.getFieldById(earlyFieldId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem retrieving the post-test field");
		}
			
		assertNotNull(postTestField.getCrop());
		assertEquals(sorghum.getId(), postTestField.getCrop().getId());
		assertNotNull(postTestField.getCropAge());
		assertEquals((Integer) 0, postTestField.getCropAge());
		assertNotNull(postTestField.getCropHealth());
		assertEquals((Integer) 100, postTestField.getCropHealth());
		assertEquals(Field.EARLY_PLANTING, postTestField.getCropPlanting());
		System.out.println(earlytsc.getNotes());
		assertEquals(Task.COMPLETED, earlytsc.getStatus());
		
		try {
			earlytsc.delete();
		} catch (Exception e2) {
			e2.printStackTrace();
		}
		TaskSowLateCrop latetsc = null;
		try {
			List <Task> lateTasks = tl.getHouseholdTasks(lateHousehold);
			latetsc = (TaskSowLateCrop) lateTasks.iterator().next();
		} catch (Exception e1) {
			e1.printStackTrace();
			fail ("Problem getting the new task");
		}
		try {
			latetsc.execute();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem with the execute for late crop.");
		}
			//assertEquals(currentAmount, maizeOwner.getAmount());
		try {
			postTestField = ff.getFieldById(11);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem retrieving the post-test field");
		}
			
		assertNotNull(postTestField.getCrop());
		assertEquals(sorghum.getId(), postTestField.getCrop().getId());
		assertNotNull(postTestField.getCropAge());
		assertEquals((Integer) 0, postTestField.getCropAge());
		assertNotNull(postTestField.getCropHealth());
		assertEquals((Integer) 100, postTestField.getCropHealth());
		assertEquals(Field.LATE_PLANTING, postTestField.getCropPlanting());
		assertEquals(Task.COMPLETED, earlytsc.getStatus());
	}
	@Test
	public void testExecuteFrontEndTask() {
		GameFactory gameFactory = new GameFactory();
		Game game = new Game();
		try {
			game = gameFactory.fetchGame(1);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the game.");
		}
		
		HearthFactory hf = new HearthFactory();
		Hearth household = new Hearth();
		try {
			household = hf.fetchHearth(35);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the hearth");
		}
		
		TaskList tl = game.fetchTaskList();
		try {
			List<Task> hearthTasks = tl.getCurrentHouseholdTasks(household);
			for (Task task: hearthTasks){
				task.execute();
				if(task.getStatus() == Task.ERROR){
					fail("There was a problem executing the task. ");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the household tasks.");
		}
		
	}
	
	@Test
	public void testFetchPossibleLocations() {
		Hearth household = fetchHousehold(1);
		TaskSowEarlyCrop tsec = new TaskSowEarlyCrop();
		Set<TaskOption> earlyLocations = tsec.fetchPossibleLocations(household); 
		assertNotNull(earlyLocations);
		assertFalse(earlyLocations.size()==0);
		
		TaskSowLateCrop tslc = new TaskSowLateCrop();
		Set<TaskOption> lateLocations = tslc.fetchPossibleLocations(household); 
		assertNotNull(lateLocations);
		assertFalse(lateLocations.size()==0);
	}

	@Test
	public void testFetchPossibleActors() {
		Hearth household = fetchHousehold(1);
		TaskSowEarlyCrop tsc = new TaskSowEarlyCrop();
		Set<TaskOption> actors = tsc.fetchPossibleActors(household); 
		assertNotNull(actors);
		assertEquals(3, actors.size());
	}

	@Test
	public void testFetchPossibleAssets() {
		Hearth household = fetchHousehold(19);
		TaskSowEarlyCrop tesc = new TaskSowEarlyCrop();
		Set<TaskOption> earlyAssets = tesc.fetchPossibleAssets(household); 
		assertNotNull(earlyAssets);
		assertTrue(earlyAssets.size()==6);
		
		TaskSowLateCrop tslc = new TaskSowLateCrop();
		Set<TaskOption> lateAssets = tslc.fetchPossibleAssets(household); 
		assertNotNull(lateAssets);
		assertTrue(lateAssets.size()==6);
	}
	@Test 
	public void testCreateNew() {
		TaskList tl = null;
		try {
			GameFactory gf = new GameFactory();
			Game game = gf.fetchGame(1);
			tl = game.fetchTaskList();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the tasklist");
		}
		try {
			TaskSowEarlyCrop testTask = (TaskSowEarlyCrop) tl.newTaskInstance(TaskSowEarlyCrop.TASKTYPE);
			assertNotNull(testTask);
			assertTrue(testTask.getDisplayName().equals(TaskSowEarlyCrop.DISPLAYNAME));
			assertTrue(testTask.getTaskType().equals(TaskSowEarlyCrop.TASKTYPE));
		} catch (Exception e) {
			e.printStackTrace();
			fail("We didn't manage to create the early task.");
		}
		
		try {
			TaskSowLateCrop testTask2 = (TaskSowLateCrop) tl.newTaskInstance(TaskSowLateCrop.TASKTYPE);
			assertNotNull(testTask2);
			assertTrue(testTask2.getDisplayName().equals(TaskSowLateCrop.DISPLAYNAME));
			assertTrue(testTask2.getTaskType().equals(TaskSowLateCrop.TASKTYPE));
		} catch (Exception e) {
			e.printStackTrace();
			fail("We didn't manage to create the late task.");
		}
	}
	private Hearth fetchHousehold(Integer houseId){
		HearthFactory hf = new HearthFactory();
		try {
			Hearth household = new Hearth();
			household = hf.fetchHearth(houseId);
			return household;
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unexpected error getting the hearth " + houseId);
		}
		return null;
	}
	private PlayerChar fetchHouseholdPC(Hearth hearth) {
		PlayerCharFactory pcf = new PlayerCharFactory();
		PlayerChar pc = null;
		try {
			Set<PlayerChar> pcs = pcf.fetchHearthPCs(hearth);
			pc = pcs.iterator().next();
		} catch (Exception e) {
			e.printStackTrace();
			fail("couldn't get a person for hearth " + hearth.getId());
		}
		return pc;
	}
}
