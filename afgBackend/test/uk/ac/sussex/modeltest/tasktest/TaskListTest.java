package uk.ac.sussex.modeltest.tasktest;

import static org.junit.Assert.*;

import java.util.List;
import java.util.Set;

import org.junit.Test;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;
import uk.ac.sussex.model.seasons.Season;
import uk.ac.sussex.model.seasons.SeasonList;
import uk.ac.sussex.model.tasks.*;

public class TaskListTest {

	@Test
	public void testGetHouseholdTasks() {
		Game game = fetchGame(1);
		TaskList tl = game.fetchTaskList();
		Hearth household = fetchHearth(7);
		try{
			List<Task> tasks = tl.getHouseholdTasks(household);
			//TODO add some tasks for household 1 and check we actually get them. 
			assertEquals(1, tasks.size());
			for (Task task: tasks){
				System.out.println(task.getClass());
			}
		} catch (Exception e) {
			e.printStackTrace();
			fail ("Error getting the list of tasks " + e.getMessage());
		}
	}
	
	@Test 
	public void testGetPotentialTasks() {
		Game game = fetchGame(1);
		TaskList tl = game.fetchTaskList();
		SeasonList seasonList = game.fetchSeasonList();
		Season season = seasonList.getCurrentSeason();
		
		try {
			Set<Task> tasks = tl.getPotentialTasks(season.getName());
			assertNotNull(tasks);
		} catch (Exception e) {
			e.printStackTrace();
			fail ("Error getting the list of potential tasks");
		}
	}
	
	@Test
	public void testCountPendingLocationTasks(){
		Game game = fetchGame(1);
		Hearth household = fetchHearth(7);
		FieldFactory ff = new FieldFactory();
		Field field = null;
		Field otherField = null;
		try {
			field = ff.getFieldById(6);
			otherField = ff.getFieldById(5);
		} catch (Exception e1) {
			e1.printStackTrace();
			fail("Problem getting the field.");
		}
		
		TaskList tl = game.fetchTaskList();
		try {
			Integer pending = tl.countPendingLocationTasks(household, field, TaskHarvestCrop.TASKTYPE);
			assertEquals((Integer) 1, pending);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unexpected error counting the tasks.");
		}
		try {
			Integer pendingOtherField = tl.countPendingLocationTasks(household, otherField, TaskHarvestCrop.TASKTYPE);
			assertEquals((Integer) 0, pendingOtherField);
		} catch(Exception e) {
			e.printStackTrace();
			fail("Unexpected error counting other field tasks");
		}
		try {
			Integer pendingAllTasks = tl.countPendingLocationTasks(household, field);
			assertEquals((Integer) 2, pendingAllTasks);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem counting any task");
		}
	}
	@Test
	public void testCountPendingActorTasks(){
		Game game = fetchGame(1);
		Hearth household = fetchHearth(7);
		AllChars actor = new AllChars();
		actor.setId(1);
		TaskList tl = game.fetchTaskList();
		try {
			Integer pending = tl.countPendingActorTasks(household, actor);
			assertEquals((Integer) 2, pending);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unexpected error counting the tasks.");
		}
	}
	@Test
	public void testCountPendingAssetAmount(){
		Game game = fetchGame(1);
		Hearth household = fetchHearth(1);
		AssetFactory af = new AssetFactory();
		Asset maize = null;
		try {
			maize = af.fetchAsset(2);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting hold of maize");
		}
		TaskList tl = game.fetchTaskList();
		try {
			Integer pendingAmount = tl.countPendingAssetAmount(household, maize);
			assertEquals((Integer) 1, pendingAmount);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem counting the pending amount");
		}
		Hearth otherHouse = fetchHearth(7);
		try {
			Integer pendingOther = tl.countPendingAssetAmount(otherHouse, maize);
			assertEquals((Integer) 0, pendingOther);
		} catch (Exception e) {
			e.printStackTrace();
			fail ("Problem counting other amount");
		}
	}
	@Test
	public void testFetchSeasonalTasks(){
		Game game = fetchGame(1);
		Hearth household = fetchHearth(19);
		TaskList tl = game.fetchTaskList();
		SeasonDetail season = new SeasonDetail();
		season.setId(14);
		List<Task> tasks = null;
		try {
			tasks = tl.fetchSeasonalTasks(household, TaskHousehold.TASKTYPE, season);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't produce the right tasks.");
		}
		assertNotNull(tasks);
		assertEquals(1, tasks.size());
	}
	@Test
	public void testFetchTasksToRenumber(){
		Hearth hearth = fetchHearth(16);
		Game game = fetchGame(1);
		TaskList tl = game.fetchTaskList();
		
		List<Task> tasks = null;
		try {
			tasks = tl.fetchTasksToRenumber(hearth, 17);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't find the tasks");
		}
		assertNotNull(tasks);
		assertEquals(tasks.size(), 2);
	}
	@Test
	public void testNonActorTaskInList(){
		Game game = fetchGame(1);
		TaskList tl = game.fetchTaskList();
		HearthFactory hf = new HearthFactory();
		Set<Hearth> hearths = null;
		try{
			hearths = hf.fetchGameHearths(game);
		} catch (Exception e) {
			e.printStackTrace();
			fail("All fall down");
		}
		for (Hearth hearth : hearths){
			List<Task> hearthTasks = null;
			try {
				hearthTasks = tl.getHouseholdTasks(hearth);
			} catch (Exception e) {
				e.printStackTrace();
				fail("Can't fetch tasks");
			}
			for (Task hearthTask : hearthTasks){
				if((hearthTask.getDeleted()==0) && (hearthTask.getStatus() == Task.PENDING)){
					hearthTask.execute();
				}
			}
		}
	}
	@Test
	public void testCountPendingTasks(){
		Game game = fetchGame(1);
		Hearth household = fetchHearth(2);
		TaskList tl = game.fetchTaskList();
		
		try {
			Integer pendingTaskCount = tl.countAllPendingTasks(household);
			assertTrue(pendingTaskCount>0);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem.");
		}
		
	}
	private Game fetchGame(Integer gameid){
		GameFactory gf = new GameFactory();
		Game game = null;
		try {
			game = gf.fetchGame(gameid);
		} catch (Exception e) {
			e.printStackTrace();
			fail ("Unexpected error fetching game");
		}
		return game;
	}
	private Hearth fetchHearth(Integer hearthId){
		HearthFactory hf = new HearthFactory();
		Hearth household = null;
		try {
			household = hf.fetchHearth(hearthId);
		} catch (Exception e) {
			e.printStackTrace();
			fail ("Unexpected error getting hearth id " + hearthId + ": " + e.getMessage());
		}
		return household;
	}
}
