/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.gameEvents;

import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.tasks.Task;
import uk.ac.sussex.model.tasks.TaskBabysit;
import uk.ac.sussex.model.tasks.TaskHousehold;
import uk.ac.sussex.model.tasks.TaskList;
import uk.ac.sussex.model.tasks.TaskSchool;

public class CoreCreateHouseholdTasksEvent extends GameEvent {

	public CoreCreateHouseholdTasksEvent(Game game) {
		super(game);
	}

	@Override
	public void fireEvent() throws Exception {
		HearthFactory hf = new HearthFactory();
		Set<Hearth> households = hf.fetchGameHearths(game);
		TaskList tl = game.fetchTaskList();
		for(Hearth household: households){
			//Just the two tasks need setting up: household chores and babysitting.
			PlayerCharFactory pcf = new PlayerCharFactory();
			Set<PlayerChar> pcs = pcf.fetchHearthPCs(household);
			List<Task> currentTasks = tl.getHouseholdTasks(household);
			Integer taskNumber = currentTasks.size() + 1;
			
			if(pcs.iterator().hasNext()){
				PlayerChar cooptedPc = pcs.iterator().next();
				setUpTaskHousehold(household, cooptedPc, taskNumber);
				taskNumber ++;
				if(household.needsBabysitter()){
					setUpTaskBabysit(household, cooptedPc, taskNumber);
				}
			}
			//Now we just need to check for any children who should be in school. 
			NPCFactory npcf = new NPCFactory();
			Set<NPC> npcs = npcf.fetchHearthChildren(household);
			AssetFactory af = new AssetFactory();
			Asset voucher = af.fetchAsset(Asset.SCHOOL_VOUCHER);
			for(NPC npc: npcs){
				Integer schoolTime = npc.getSchool();
				if(schoolTime == null){
					schoolTime = 0;
				}
				Integer wholeYears = schoolTime%4;
				if(wholeYears!=0){
					taskNumber++;
					setUpSchoolTask(household, npc, taskNumber, voucher);
				}
			}
		}
	}
	private void setUpTaskBabysit(Hearth household, PlayerChar actor, int taskNumber) throws Exception {
		TaskBabysit tb = (TaskBabysit) game.fetchTaskList().newTaskInstance(TaskBabysit.TASKTYPE);
		tb.setHousehold(household);
		tb.setLocation(household);
		tb.setSeason(game.getCurrentSeasonDetail());
		tb.setActor(actor);
		tb.setStatus(Task.PENDING);
		tb.setTaskNumber(taskNumber);
		tb.save();
	}

	private void setUpTaskHousehold(Hearth household, PlayerChar actor, Integer taskNumber) throws Exception {
		TaskHousehold th = (TaskHousehold) game.fetchTaskList().newTaskInstance(TaskHousehold.TASKTYPE);
		th.setHousehold(household);
		th.setLocation(household);
		th.setSeason(game.getCurrentSeasonDetail());
		th.setActor(actor);
		th.setStatus(Task.PENDING);
		th.setTaskNumber(taskNumber);
		th.save();
	}
	
	private void setUpSchoolTask(Hearth household, AllChars actor, int taskNumber, Asset voucher) throws Exception {
		TaskSchool ts = (TaskSchool) game.fetchTaskList().newTaskInstance(TaskSchool.TASKTYPE);
		ts.setHousehold(household);
		ts.setLocation(household);
		ts.setSeason(game.getCurrentSeasonDetail());
		ts.setActor(actor);
		ts.setStatus(Task.PENDING);
		ts.setTaskNumber(taskNumber);
		ts.setAsset(voucher);
		ts.save();
	}
	
	@Override
	public void generateNotifications() throws Exception {
		Set<Hearth> hearths = game.fetchHearths();
		PlayerCharFactory pcf = new PlayerCharFactory();
		SeasonNotificationFactory snf = new SeasonNotificationFactory();
		
		for(Hearth hearth: hearths){
			Set<PlayerChar> pcs = pcf.fetchHearthPCs(hearth);
			String notification = "The mandatory household tasks for this season have been created and labour allocated. Failure to complete these tasks will result in a financial penalty.";
			snf.updateSeasonNotifications(notification, pcs);
		}
		
		String gmNotification = "Household tasks:\nMandatory household tasks have been created for all households.";
		snf.updateBankerNotifications(gmNotification, game);
	}
}
