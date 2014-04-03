package uk.ac.sussex.modeltest.tasktest;

import static org.junit.Assert.*;

import java.util.Set;

import org.junit.Test;

import uk.ac.sussex.model.Asset;
import uk.ac.sussex.model.AssetFactory;
import uk.ac.sussex.model.AssetOwner;
import uk.ac.sussex.model.AssetOwnerFactory;
import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.HearthFactory;
import uk.ac.sussex.model.NPC;
import uk.ac.sussex.model.NPCFactory;
import uk.ac.sussex.model.SeasonDetail;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;
import uk.ac.sussex.model.tasks.Task;
import uk.ac.sussex.model.tasks.TaskList;
import uk.ac.sussex.model.tasks.TaskOption;
import uk.ac.sussex.model.tasks.TaskSchool;

public class TaskSchoolTest {

	@Test
	public void testGetDisplayName() {
		TaskList tl = fetchTaskList (1);
		TaskSchool ts = this.fetchNewTaskSchool(tl);
		String displayName = ts.getDisplayName();
		assertTrue (TaskSchool.DISPLAYNAME.equals(displayName));
	}

	@Test
	public void testExecute() {
		TaskList tl = fetchTaskList(4);
		TaskSchool taskTooOld = fetchNewTaskSchool(tl);
		TaskSchool taskJustRight = fetchNewTaskSchool(tl);
		TaskSchool taskJustRightTermTwo = fetchNewTaskSchool(tl);
		Hearth household = fetchHousehold(4);
		SeasonDetail sd = new SeasonDetail();
		sd.setId(5);
		NPC tooOld = null;
		NPC justRight = null;
		try{
			NPCFactory npcf = new NPCFactory();
			tooOld = npcf.fetchNPC(17);
			justRight = npcf.fetchNPC(20);
		} catch (Exception e){
			e.printStackTrace();
			fail("Problem getting the NPC");
		}
		
		AssetFactory af = new AssetFactory();
		AssetOwnerFactory aof = new AssetOwnerFactory();
		Asset schoolVoucher = null;
		Double vouchers = (double) 0;
		try{
			schoolVoucher = af.fetchAsset(13);
			AssetOwner schoolVoucherOwner = aof.fetchSpecificAsset(household, schoolVoucher);
			if(schoolVoucherOwner == null){
				schoolVoucherOwner = new AssetOwner();
				schoolVoucherOwner.setAmount((double) 1);
				schoolVoucherOwner.setAsset(schoolVoucher);
				schoolVoucherOwner.setHearth(household);
			} else {
				vouchers = schoolVoucherOwner.getAmount();
				schoolVoucherOwner.setAmount(vouchers + 1);
			}
			schoolVoucherOwner.save();
		} catch(Exception e){
			e.printStackTrace();
			fail("Problem with the vouchers");
		}
		
		taskTooOld.setActor(tooOld);
		taskTooOld.setHousehold(household);
		taskTooOld.setSeason(sd);
		taskTooOld.setStatus(Task.PENDING);
		taskTooOld.setTaskNumber(2781);
		taskTooOld.setAsset(schoolVoucher);
		taskTooOld.setLocation(household);
		try {
			taskTooOld.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't save taskTooOld");
		}
		taskTooOld.execute();
		assertTrue(taskTooOld.getStatus()==Task.ERROR);
		taskJustRight.setActor(justRight);
		taskJustRight.setAsset(schoolVoucher);
		taskJustRight.setHousehold(household);
		taskJustRight.setSeason(sd);
		taskJustRight.setLocation(household);
		taskJustRight.setTaskNumber(502);
		try {
			taskJustRight.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't save taskJustRight");
		}
		taskJustRight.execute();
		assertTrue(taskJustRight.getStatus()==Task.COMPLETED);
		taskJustRightTermTwo.setActor(justRight);
		taskJustRightTermTwo.setAsset(schoolVoucher);
		taskJustRightTermTwo.setHousehold(household);
		taskJustRightTermTwo.setSeason(sd);
		taskJustRightTermTwo.setLocation(household);
		taskJustRightTermTwo.setTaskNumber(502);
		try {
			taskJustRightTermTwo.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't save taskJustRight");
		}
		taskJustRightTermTwo.execute();
	}
	
	@Test
	public void testFetchPossibleActors(){
		TaskList tl = fetchTaskList(1);
		TaskSchool task = fetchNewTaskSchool(tl);
		Hearth household = fetchHousehold(1);
		Set<TaskOption> kids = task.fetchPossibleActors(household);
		assertNotNull(kids);
		assertEquals(1, kids.size());
	}
	
	@Test
	public void testFetchPossibleAssets(){
		TaskList tl = fetchTaskList(1);
		TaskSchool task = fetchNewTaskSchool(tl);
		Hearth household = fetchHousehold(1);
		Set<TaskOption> vouchers = task.fetchPossibleAssets(household);
		assertNotNull(vouchers);
		assertEquals(1, vouchers.size());
	}
	
	@Test
	public void testFetchPossibleLocations(){
		TaskList tl = fetchTaskList(1);
		TaskSchool task = fetchNewTaskSchool(tl);
		Hearth household = fetchHousehold(7);
		Set<TaskOption> locations = task.fetchPossibleLocations(household);
		assertNotNull(locations);
		assertEquals(1, locations.size());
		TaskOption loc = locations.iterator().next();
		assertEquals(loc.getStatus(), (Integer) TaskOption.INVALID);
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
	private TaskSchool fetchNewTaskSchool(TaskList tl){
		TaskSchool ts = null;
		try {
			ts = (TaskSchool) tl.newTaskInstance(TaskSchool.TASKTYPE);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't generate task school");
		}
		return ts;
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
}
