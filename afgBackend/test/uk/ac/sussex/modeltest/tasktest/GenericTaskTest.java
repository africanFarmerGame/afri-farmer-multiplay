/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.modeltest.tasktest;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.Test;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;
import uk.ac.sussex.model.tasks.*;
/**
 * This is designed to test things that need multiple types of task. 
 * 
 * @author em97
 */
public class GenericTaskTest {

	@Test
	public void testConfirmActorAvailability() {
		Game game = fetchGame(1);
		TaskList tl = new GenericTaskList(game);
		Hearth hearth1 = createHearth(game, "ConfirmActorHearth1");
		Hearth hearth2 = createHearth(game, "ConfirmActorHearth2");
		SeasonDetail sd = fetchSeasonDetail(game);
		
		//1 adult actor, 2 tasks. Should be executed correctly. 
		PlayerChar pc1TaskAdult = createPlayerChar(game, hearth1, "ConfirmActorAdult1");
		Task pc1Task1 = createTask(game, hearth1, sd, null, pc1TaskAdult, GenericTask.TASKTYPE);
		Task pc1Task2 = createTask(game, hearth1, sd, null, pc1TaskAdult, GenericTask.TASKTYPE);
		
		//1 child actor, 1 task. Should be executed correctly.
		NPC npc1TaskChild = createNPC(hearth1, "ConfirmActorChild1", 10);
		Task npc1Task1 = createTask(game, hearth1, sd, null, npc1TaskChild, GenericTask.TASKTYPE);
		
		//1 adult actor, 3 tasks. 1st two should be executed correctly, last one not.
		PlayerChar pc3TaskAdult = createPlayerChar(game, hearth1, "ConfirmActorAdult2");
		Task pc3Task1 = createTask(game, hearth1, sd, null, pc3TaskAdult, GenericTask.TASKTYPE);
		Task pc3Task2 = createTask(game, hearth1, sd, null, pc3TaskAdult, GenericTask.TASKTYPE);
		Task pc3Task3 = createTask(game, hearth1, sd, null, pc3TaskAdult, GenericTask.TASKTYPE);
		
		//1 child actor, 2 tasks. 1 should be executed correcly, the other fail. 
		NPC npc2TaskChild = createNPC(hearth1, "ConfirmActorChild2", 10);
		Task npc2Task1 = createTask(game, hearth1, sd, null, npc2TaskChild, GenericTask.TASKTYPE);
		Task npc2Task2 = createTask(game, hearth1, sd, null, npc2TaskChild, GenericTask.TASKTYPE);
		
		//1 adult actor, 1 external home task, 1 task at hearth2.
		NPC npc1ExTaskAdult = createNPC(hearth1, "ConfirmActorAdult3", 24);
		Task npc1ExTask1 = createTask(game, hearth1, sd, hearth2, npc1ExTaskAdult, TaskFarmElsewhere.TASKTYPE);
		Task npc1ExTask2 = createTask(game, hearth2, sd, null, npc1ExTaskAdult, GenericTask.TASKTYPE);
		
		//1 adult actor, 1 external home task, 2 tasks at hearth2. (Second hearth2 task should fail)
		NPC npc2ExTaskAdult = createNPC(hearth1, "ConfirmActorAdult4", 20);
		Task npc2ExTask1 = createTask(game, hearth1, sd, hearth2, npc2ExTaskAdult, TaskFarmElsewhere.TASKTYPE);
		Task npc2ExTask2 = createTask(game, hearth2, sd, null, npc2ExTaskAdult, GenericTask.TASKTYPE);
		Task npc2ExTask3 = createTask(game, hearth2, sd, null, npc2ExTaskAdult, GenericTask.TASKTYPE);
		
		//1 adult actor, 2 normal tasks, 2 external, 2 at hearth2 (2 external + 2 at hearth2 should fail)
		PlayerChar pc4TaskAdult = createPlayerChar(game, hearth1, "ConfirmActorAdult5");
		Task pc4Task1 = createTask(game, hearth1, sd, null, pc4TaskAdult, GenericTask.TASKTYPE);
		Task pc4Task2 = createTask(game, hearth1, sd, null, pc4TaskAdult, GenericTask.TASKTYPE);
		Task pc4Task3 = createTask(game, hearth1, sd, hearth2, pc4TaskAdult, TaskFarmElsewhere.TASKTYPE);
		Task pc4Task4 = createTask(game, hearth1, sd, hearth2, pc4TaskAdult, TaskFarmElsewhere.TASKTYPE);
		Task pc4Task5 = createTask(game, hearth2, sd, null, pc4TaskAdult, GenericTask.TASKTYPE);
		Task pc4Task6 = createTask(game, hearth2, sd, null, pc4TaskAdult, GenericTask.TASKTYPE);
		
		//1 adult actor, 1 normal task, 2 external, 2 at hearth2 (1 external + 1 at hearth2 should fail)
		PlayerChar pc3ExTaskAdult = createPlayerChar(game, hearth1, "ConfirmActorAdult6");
		Task pc3ExTask1 = createTask(game, hearth1, sd, null, pc3ExTaskAdult, GenericTask.TASKTYPE);
		Task pc3ExTask2 = createTask(game, hearth1, sd, hearth2, pc3ExTaskAdult, TaskFarmElsewhere.TASKTYPE);
		Task pc3ExTask3 = createTask(game, hearth1, sd, hearth2, pc3ExTaskAdult, TaskFarmElsewhere.TASKTYPE);
		Task pc3ExTask4 = createTask(game, hearth2, sd, null, pc3ExTaskAdult, GenericTask.TASKTYPE);
		Task pc3ExTask5 = createTask(game, hearth2, sd, null, pc3ExTaskAdult, GenericTask.TASKTYPE);
		
		//1 adult actor, 0 normal/external tasks, 1 at hearth2 (should fail)
		NPC npc0ExTaskAdult = createNPC(hearth1, "ConfirmActorAdult7", 24);
		Task npc0ExTask1 = createTask(game, hearth2, sd, null, npc0ExTaskAdult, GenericTask.TASKTYPE);
		
		
		//Execute the tasks;
		List<Task> householdTasks = null;
		try {
			householdTasks = tl.getHouseholdTasks(hearth1);
			householdTasks.addAll(tl.getHouseholdTasks(hearth2));
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to get the household tasks for the hearths");
		}
		for(Task householdTask: householdTasks){
			householdTask.execute();
		}
		
		List<Task> updatedHouseholdTasks = null;
		try {
			updatedHouseholdTasks = tl.getHouseholdTasks(hearth1);
			updatedHouseholdTasks.addAll(tl.getHouseholdTasks(hearth2));
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to get the updated household tasks for the hearths");
		}
		for(Task updatedTask : updatedHouseholdTasks){
			Integer taskId = updatedTask.getId();
			if((taskId == pc1Task1.getId()) ||
				(taskId == pc1Task2.getId()) ||
				(taskId == npc1Task1.getId()) ||
				(taskId == pc3Task1.getId()) ||
				(taskId == pc3Task2.getId()) ||
				(taskId == npc2Task1.getId()) ||
				(taskId == npc1ExTask1.getId()) ||
				(taskId == npc1ExTask2.getId()) ||
				(taskId == npc2ExTask1.getId()) ||
				(taskId == npc2ExTask2.getId()) ||
				(taskId == pc4Task1.getId()) ||
				(taskId == pc4Task2.getId()) ||
				(taskId == pc3ExTask1.getId()) ||
				(taskId == pc3ExTask2.getId()) ||
				(taskId == pc3ExTask4.getId())
					){
				assertEquals(Task.COMPLETED, updatedTask.getStatus());
			}  else
			if((taskId == pc3Task3.getId()) ||
					(taskId == npc2Task2.getId()) ||
					(taskId == npc2ExTask3.getId()) ||
					(taskId == pc4Task3.getId()) ||
					(taskId == pc4Task4.getId()) ||
					(taskId == pc4Task5.getId()) ||
					(taskId == pc4Task6.getId()) ||
					(taskId == pc3ExTask5.getId()) ||
					(taskId == npc0ExTask1.getId())
					) {
				assertEquals(Task.ERROR, updatedTask.getStatus());
				assertTrue(updatedTask.getNotes().contains("actor was unavailable"));
			} else 
			if(taskId == pc3ExTask3.getId()){
				assertEquals(Task.ERROR, updatedTask.getStatus());
				assertTrue(updatedTask.getNotes().contains("person allocated to this task"));
			}
		}
	}
	
	private Hearth createHearth(Game game, String hearthName) {
		Hearth hearth = new Hearth();
		hearth.setGame(game);
		hearth.setName(hearthName);
		hearth.setHousenumber(1);
		try {
			hearth.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem creating hearth " + hearthName);
		}
		return hearth;
	}
	private PlayerChar createPlayerChar(Game game, Hearth hearth, String firstname) {
		Role role = fetchRandomRole();
		PlayerChar pc = new PlayerChar();
		pc.setGame(game);
		pc.setHearth(hearth);
		pc.setFamilyName("GenericTest");
		pc.setName(firstname);
		pc.setAvatarBody(1);
		pc.setRole(role);
		pc.setSocialStatus(5);
		try {
			pc.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem saving pc " + firstname);
		}
		return pc;
	}
	private NPC createNPC(Hearth hearth, String firstname, Integer age){
		Role role = fetchRandomRole();
		NPC npc = new NPC();
		npc.setAge(age);
		npc.setFamilyName("GenericTest");
		npc.setName(firstname);
		npc.setHearth(hearth);
		npc.setRole(role);
		try {
			npc.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't save the NPC " + firstname);
		}
		return npc;
	}
	private Task createTask(Game game, Hearth hearth, SeasonDetail sd, Location loc, AllChars actor, String taskType){
		TaskList tl = new GenericTaskList(game);
		Task task = null;
		try {
			task = tl.newTaskInstance(taskType);
		} catch (Exception e) {
			e.printStackTrace();
			fail ("Couldn't get a new task of type " + taskType);
		}
		
		List<Task> tasks = null;
		try {
			tasks = tl.getHouseholdTasks(hearth);
		} catch (Exception e) {
			e.printStackTrace();
			fail ("Couldn't get a list of tasks for household " + hearth.getName());
		}
		Integer taskNumber = tasks.size();
		
		task.setSeason(sd);
		task.setHousehold(hearth);
		task.setLocation(loc);
		task.setActor(actor);
		task.setStatus(Task.PENDING);
		task.setTaskNumber(taskNumber + 1);
		try {
			task.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't save my task of type " + taskType);
		}
		
		return task;
	}
	private Game fetchGame(Integer gameId){
		GameFactory gf = new GameFactory();
		Game game = null;
		try {
			game = gf.fetchGame(gameId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem fetching game " + gameId);
		}
		return game;
	}
	private SeasonDetail fetchSeasonDetail(Game game){
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		SeasonDetail sd = null;
		try {
			sd = sdf.fetchCurrentSeasonDetail(game);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't fetch the current seasonDetail for game " + game.getGameName());
		}
		if(sd==null){
			fail("Game " + game.getGameName() + " doesn't seem to have a current season detail");
		}
		return sd;
	}
	private Role fetchRandomRole(){
		RoleFactory rf = new RoleFactory();
		Role role = null;
		try {
			role = rf.fetchRandomRole();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting a random role");
		}
		return role;
	}
}
