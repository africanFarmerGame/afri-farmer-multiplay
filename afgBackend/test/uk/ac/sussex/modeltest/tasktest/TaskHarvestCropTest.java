package uk.ac.sussex.modeltest.tasktest;

import static org.junit.Assert.*;

import java.util.List;
import java.util.Set;

import org.junit.Test;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;
import uk.ac.sussex.model.tasks.*;

public class TaskHarvestCropTest {

	@Test
	public void testExecute() {
		Game sampleGame = fetchGame(1);
		Hearth hearth = fetchHearth(7);
		TaskList tl = sampleGame.fetchTaskList();
		TaskHarvestCrop task = new TaskHarvestCrop();
		try {
			List<Task> tasks = tl.getHouseholdTasks(hearth);
			assertTrue(tasks.size() > 0);
			task = (TaskHarvestCrop) tasks.get(0);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem fetching task.");
		}
		task.execute();
		assertEquals(Task.COMPLETED, task.getStatus());
		Asset asset = fetchAsset(2);
		AssetOwnerFactory aof = new AssetOwnerFactory();
		
		AssetOwner assetOwner = null;
		try {
			assetOwner = aof.fetchSpecificAsset(hearth, asset);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem fetching the assetowner record");
		}
		assertNotNull(assetOwner);
		assertEquals((Double)5.0, assetOwner.getAmount());
		//Should really be testing some error cases too...
		
	}

	@Test
	public void testFetchPossibleLocations() {
		HearthFactory hf = new HearthFactory();
		Hearth household = new Hearth();
		try {
			household = hf.fetchHearth(7);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the household");
		}
		
		TaskHarvestCrop harvestTask = new TaskHarvestCrop();
		Set<TaskOption> harvestFields = harvestTask.fetchPossibleLocations(household);
		assertNotNull(harvestFields);
		assertTrue(harvestFields.size()>0);
		assertEquals((int)1, harvestFields.size());
	}

	@Test
	public void testFetchPossibleActors() {
		HearthFactory hf = new HearthFactory();
		Hearth household = new Hearth();
		try {
			household = hf.fetchHearth(1);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the household");
		}
		
		TaskHarvestCrop harvestTask = new TaskHarvestCrop();
		Set<TaskOption> harvesters = harvestTask.fetchPossibleActors(household);
		assertNotNull(harvesters);
		assertEquals((int) 3, harvesters.size());
	}

	@Test
	public void testFetchPossibleAssets() {
		fail("Not yet implemented");
	}
	@Test 
	public void testSave() {
		Game game = fetchGame(2);
		TaskList tl = null;
		try {
			tl = game.fetchTaskList();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the tasklist");
		}
		TaskHarvestCrop thc = fetchNewTaskHarvestCrop(tl);
		SeasonDetail sd = new SeasonDetail();
		sd.setId(1);
		thc.setSeason(sd);
		Hearth hearth = new Hearth();
		hearth.setId(1);
		thc.setHousehold(hearth);
		thc.setTaskNumber(1);
		try {
			thc.save();
			fail("The task has null location, actor, and asset, but saved.");
		} catch (Exception e) {
			e.printStackTrace();
			assertTrue(e.getMessage().contains("Location|"));
			assertTrue(e.getMessage().contains("Actor|"));
		}
	}
	@Test
	public void testFertilisedField(){
		Game game = fetchGame(3);
		Hearth hearth = fetchHearth(7);
		Asset crop = fetchAsset(2);
		Asset fertiliser = fetchAsset(9);
		AssetOwnerFactory aof = new AssetOwnerFactory();
		AssetOwner cropOwner = null;
		try {
			cropOwner = aof.fetchSpecificAsset(hearth, crop);
		} catch (Exception e1) {
			e1.printStackTrace();
			fail("Can't work out how much maize they start with.");
		}
		Double initialCropAmount = cropOwner.getAmount();
		FieldFactory ff = new FieldFactory();
		Field field = null;
		try {
			field = ff.createField(hearth, "TestFertiliser");
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to create field");
		}
		field.setCrop(crop);
		field.setCropAge(2);
		field.setCropHealth(100);
		field.setCropPlanting(Field.EARLY_PLANTING);
		field.setFertiliser(fertiliser);
		try {
			field.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Didn't manage to save the field.");
		}
		TaskList tl = game.fetchTaskList();
		TaskHarvestCrop thc = fetchNewTaskHarvestCrop(tl);
		thc.setHousehold(hearth);
		thc.setLocation(field);
		AllChars actor = new AllChars();
		actor.setId(1);
		thc.setActor(actor);
		thc.setTaskNumber(19);
		SeasonDetail sd = new SeasonDetail();
		sd.setId(2);
		thc.setSeason(sd);
		thc.execute();
		AssetOwner newCropOwner = null;
		try {
			newCropOwner = aof.fetchSpecificAsset(hearth, crop);
		} catch (Exception e1) {
			e1.printStackTrace();
			fail("Can't work out how much maize they end with.");
		}
		assertEquals((Double)(initialCropAmount + 19.0), newCropOwner.getAmount());
	}
	@Test
	public void testHYCrop(){
		//Set up the game situation
		Game game = fetchGame(2);
		AssetCrop hyMaize = (AssetCrop)fetchAsset(3);
		Asset maize = fetchAsset(2);
		Hearth hearth = fetchHearth(284);
		AssetOwner hyMaizeAmount = fetchAssetOwner(hearth, hyMaize);
		AssetOwner localMaizeAmount = fetchAssetOwner(hearth, maize);
		Double initialHYMaize = hyMaizeAmount.getAmount();
		Double initialLocalMaize = localMaizeAmount.getAmount();
		FieldFactory ff = new FieldFactory();
		Field field = null;
		try {
			field = ff.createField(hearth, "TestFertiliser");
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to create field");
		}
		field.setCrop(hyMaize);
		field.setCropAge(2);
		field.setCropHealth(100);
		field.setCropPlanting(Field.EARLY_PLANTING);
		try {
			field.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Didn't manage to save the field.");
		}
		//Create the task
		TaskList tl = game.fetchTaskList();
		TaskHarvestCrop thc = fetchNewTaskHarvestCrop(tl);
		thc.setHousehold(hearth);
		thc.setLocation(field);
		AllChars actor = new AllChars();
		actor.setId(418);
		thc.setActor(actor);
		thc.setTaskNumber(19);
		SeasonDetail sd = new SeasonDetail();
		sd.setId(2);
		thc.setSeason(sd);
		thc.execute();
		AssetOwner newMaizeAmount = fetchAssetOwner(hearth, maize);
		AssetOwner newHYMaizeAmount = fetchAssetOwner(hearth, hyMaize);
		assertEquals((Double)(initialLocalMaize + hyMaize.getEPYield()), newMaizeAmount.getAmount());
		assertEquals(initialHYMaize, newHYMaizeAmount.getAmount()); //This should be unchanged. 
	}
	private Game fetchGame(Integer gameId){
		GameFactory gameFactory = new GameFactory();
		Game sampleGame = new Game();
		try {
			sampleGame = gameFactory.fetchGame(gameId);
		} catch (Exception e) {
			e.printStackTrace();
			fail ("Problem fetching the sample game.");
		}
		return sampleGame;
	}
	private Hearth fetchHearth(Integer hearthId){
		HearthFactory hearthFactory = new HearthFactory();
		Hearth hearth = new Hearth();
		try {
			hearth = hearthFactory.fetchHearth(hearthId);
		} catch (Exception e){
			e.printStackTrace();
			fail ("Problem fetching the hearth");
		}
		return hearth;
	}
	/**private Hearth fetchGameHearth(Game game) {
		HearthFactory hf = new HearthFactory();
		Set<Hearth> hearths = null;
		try {
			hearths = hf.fetchGameHearths(game);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to fetch game hearths");
		}
		
	}*/
	private Asset fetchAsset(Integer assetId){
		AssetFactory af = new AssetFactory();
		Asset asset = null;
		try{
			asset = af.fetchAsset(assetId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem fetching the asset.");
		}
		return asset;
	}
	private TaskHarvestCrop fetchNewTaskHarvestCrop(TaskList tl){
		TaskHarvestCrop thc = null;
		try {
			thc = (TaskHarvestCrop) tl.newTaskInstance(TaskHarvestCrop.TASKTYPE);
		} catch (Exception e) {
			e.printStackTrace();
			fail ("unable to generate the task.");
		}
		return thc;
	}
	private AssetOwner fetchAssetOwner(Hearth hearth, Asset asset) {
		AssetOwnerFactory aof = new AssetOwnerFactory();
		AssetOwner assetOwner = null;
		try {
			assetOwner = aof.fetchSpecificAsset(hearth, asset);
		} catch (Exception e1) {
			e1.printStackTrace();
			fail("Can't fetch assetowner for hearth " + hearth.getId() + " and asset " + asset.getId());
		}
		return assetOwner;
	}
}
