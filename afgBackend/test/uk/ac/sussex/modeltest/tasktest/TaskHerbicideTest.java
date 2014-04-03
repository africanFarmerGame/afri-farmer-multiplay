/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.modeltest.tasktest;

import static org.junit.Assert.*;

import java.util.List;
import java.util.Set;

import org.junit.Test;

import uk.ac.sussex.model.Asset;
import uk.ac.sussex.model.AssetFactory;
import uk.ac.sussex.model.AssetOwner;
import uk.ac.sussex.model.AssetOwnerFactory;
import uk.ac.sussex.model.Field;
import uk.ac.sussex.model.FieldFactory;
import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.HearthFactory;
import uk.ac.sussex.model.SeasonDetail;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;
import uk.ac.sussex.model.tasks.Task;
import uk.ac.sussex.model.tasks.TaskHerbicide;
import uk.ac.sussex.model.tasks.TaskList;
import uk.ac.sussex.model.tasks.TaskOption;

public class TaskHerbicideTest {

	@Test
	public void testGetDisplayName() {
		TaskList tl = fetchTaskList(1);
		TaskHerbicide th = null;
		try {
			th = (TaskHerbicide) tl.newTaskInstance(TaskHerbicide.TASKTYPE);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get the task instance.");
		}
		assertNotNull(th);
		assertTrue(th.getDisplayName().equals(TaskHerbicide.DISPLAYNAME));
	}

	@Test
	public void testExecute() {
		TaskList tl = fetchTaskList(1);
		Hearth household = fetchHousehold(7);
		TaskHerbicide task = fetchNewTaskHerbicide(tl);
		Asset herbicide = fetchAsset(5);
		Asset sprayKit = fetchAsset(12);
		Field field = fetchField(4);
		SeasonDetail sd = new SeasonDetail();
		sd.setId(4);
		task.setAsset(herbicide);
		task.setAssetAmount(1);
		task.setHousehold(household);
		task.setLocation(field);
		task.setTaskNumber(2135);
		task.setSeason(sd);
		try {
			task.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't save task");
		}
		AssetOwnerFactory aof = new AssetOwnerFactory();
		try{
			AssetOwner herbicideOwner = aof.fetchSpecificAsset(household, herbicide);
			AssetOwner spraykitowner = aof.fetchSpecificAsset(household, sprayKit);
			if(herbicideOwner==null){
				herbicideOwner = new AssetOwner();
				herbicideOwner.setAsset(herbicide);
				herbicideOwner.setHearth(household);
				herbicideOwner.setAmount((double) 1);
				herbicideOwner.save();
			} else {
				herbicideOwner.setAmount(herbicideOwner.getAmount() + 1);
				herbicideOwner.save();
			}
			if(spraykitowner== null){
				spraykitowner = new AssetOwner();
				spraykitowner.setAsset(sprayKit);
				spraykitowner.setHearth(household);
				spraykitowner.setAmount((double) 1);
				spraykitowner.save();
			} else {
				if(spraykitowner.getAmount() < 1){
					spraykitowner.setAmount((double)1);
					spraykitowner.save();
				}
			}
		} catch (Exception e){
			e.printStackTrace();
			fail("problem with herbicide owner.");
		}
		task.execute();
		assertTrue(task.getStatus().equals(Task.COMPLETED));
		
	}

	@Test
	public void testFetchPossibleLocations() {
		TaskList tl = fetchTaskList(1);
		Hearth household = fetchHousehold(7);
		TaskHerbicide task = fetchNewTaskHerbicide(tl);
		
		FieldFactory ff = new FieldFactory();
		List<Field> fields = null;
		try {
			fields = ff.getHearthFields(household);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get the fields");
		}
		
		Set<TaskOption> locations = task.fetchPossibleLocations(household);
		assertNotNull(locations);
		assertEquals(locations.size(), fields.size());
	}

	@Test
	public void testFetchPossibleActors() {
		TaskList tl = fetchTaskList(1);
		Hearth household = fetchHousehold(7);
		TaskHerbicide task = fetchNewTaskHerbicide(tl);
		
		Set<TaskOption> actors = task.fetchPossibleActors(household);
		assertNull(actors);
	}

	@Test
	public void testFetchPossibleAssets() {
		TaskList tl = fetchTaskList(1);
		Hearth household = fetchHousehold(7);
		TaskHerbicide task = fetchNewTaskHerbicide(tl);
		
		Set<TaskOption> assets = task.fetchPossibleAssets(household);
		assertNotNull(assets);
		AssetFactory af = new AssetFactory();
		Set<Asset> herbicides = null;
		try {
			herbicides = af.fetchHerbicide();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't fetch herbicides.");
		}
		assertEquals(assets.size(), herbicides.size() );
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
	private TaskHerbicide fetchNewTaskHerbicide(TaskList tl){
		TaskHerbicide testTask = null;
		try {
			testTask = (TaskHerbicide) tl.newTaskInstance(TaskHerbicide.TASKTYPE);
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
	private Field fetchField(Integer locId){
		FieldFactory ff = new FieldFactory();
		Field field = null;
		try {
			field = ff.getFieldById(locId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the field " + locId);
		}
		return field;
	}
}
