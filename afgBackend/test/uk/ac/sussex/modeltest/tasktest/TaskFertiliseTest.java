package uk.ac.sussex.modeltest.tasktest;

import static org.junit.Assert.*;

import java.util.Set;

import org.junit.Test;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;
import uk.ac.sussex.model.tasks.*;

public class TaskFertiliseTest {

	@Test
	public void testGetDisplayName() {
		TaskList tl = fetchTaskList(1);
		TaskFertilise tf = fetchNewTaskFertilise(tl);
		assertNotNull(tf);
		assertTrue(tf.getDisplayName().equals(TaskFertilise.DISPLAYNAME));
	}

	@Test
	public void testExecute() {
		TaskList tl = fetchTaskList(1);
		Hearth hearth = fetchHousehold(7);
		Asset crop = fetchAsset(2);
		Asset fertiliser = fetchAsset(1);
		
		FieldFactory ff = new FieldFactory();
		Field field = null;
		try {
			field = ff.createField(hearth, "TestFertiliseExecute");
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't create a field");
		}
		field.setCrop(crop);
		field.setCropAge(1);
		field.setCropHealth(60);
		field.setCropPlanting(Field.LATE_PLANTING);
		try {
			field.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't save a field.");
		}
		Integer fieldId = field.getId();
		
		TaskFertilise taskFertilise= fetchNewTaskFertilise(tl);
		taskFertilise.setHousehold(hearth);
		taskFertilise.setLocation(field);
		taskFertilise.setAsset(fertiliser);
		taskFertilise.setAssetAmount(1);
		taskFertilise.setTaskNumber(103);
		AllChars actor = new AllChars();
		actor.setId(1);
		taskFertilise.setActor(actor);
		SeasonDetail sd = new SeasonDetail();
		sd.setId(2);
		taskFertilise.setSeason(sd);
		
		taskFertilise.execute();
		
		Field newField = null;
		try {
			newField = ff.getFieldById(fieldId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get updated field");
		}
		assertNotNull(newField);
		assertNotNull(newField.getFertiliser());
		assertEquals(fertiliser.getId(), newField.getFertiliser().getId());
		
	}

	@Test
	public void testFetchPossibleLocations() {
		fail("Not yet implemented");
	}

	@Test
	public void testFetchPossibleActors() {
		TaskList tl = fetchTaskList(1);
		Hearth household = fetchHousehold(1);
		TaskFertilise taskFertilise = fetchNewTaskFertilise(tl);
		
		Set<TaskOption> fertilisers = taskFertilise.fetchPossibleActors(household);
		assertNotNull(fertilisers);
		assertEquals((int) 3, fertilisers.size());
		for(TaskOption weeder: fertilisers){
			assertNotNull(weeder.getName());
			System.out.println(weeder.getName());
		}
	}

	@Test
	public void testFetchPossibleAssets() {
		fail("Not yet implemented");
	}

	private TaskList fetchTaskList(Integer gameid){
		TaskList tl = null;
		try {
			GameFactory gf = new GameFactory();
			Game game = gf.fetchGame(gameid);
			tl = game.fetchTaskList();
			return tl;
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the tasklist");
			return null;
		}
	}
	private TaskFertilise fetchNewTaskFertilise(TaskList tl){
		TaskFertilise testTask = null;
		try {
			testTask = (TaskFertilise) tl.newTaskInstance(TaskFertilise.TASKTYPE);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to generate a new task.");
		}
		return testTask;
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
	private Asset fetchAsset(Integer assetId){
		AssetFactory af = new AssetFactory();
		Asset asset = null;
		try {
			asset = af.fetchAsset(assetId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the asset " + assetId.toString());
		}
		return asset;
	}
}
