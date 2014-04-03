/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.tasks;

import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.seasons.*;
import uk.ac.sussex.utilities.Logger;

//This needs to set up a list of possible tasks for the game, and return a list of actual tasks set up for each family. 
public class CoreTaskList extends TaskList {

	public CoreTaskList(Game game) {
		super(game);
	}

	@Override
	protected void setupPotentialTasks() {
		try {
			Task taskSowEarlyCrop = this.newTaskInstance(TaskSowEarlyCrop.TASKTYPE);
			Task taskSowLateCrop = this.newTaskInstance(TaskSowLateCrop.TASKTYPE);
			Task taskHarvestCrop = this.newTaskInstance(TaskHarvestCrop.TASKTYPE);
			Task taskBabysit = this.newTaskInstance(TaskBabysit.TASKTYPE);
			Task taskWeedCrop = this.newTaskInstance(TaskWeedCrop.TASKTYPE);
			Task taskFarmElsewhere = this.newTaskInstance(TaskFarmElsewhere.TASKTYPE);
			Task taskFertilise = this.newTaskInstance(TaskFertilise.TASKTYPE);
			Task taskHerbicide = this.newTaskInstance(TaskHerbicide.TASKTYPE);
			Task taskSchool = this.newTaskInstance(TaskSchool.TASKTYPE);
			Task taskHousework = this.newTaskInstance(TaskHousehold.TASKTYPE);
			Task taskSprayInsecticide = this.newTaskInstance(TaskSprayInsecticide.TASKTYPE);
			
			addPotentialTask(taskSowEarlyCrop, CoreEarlyRainsSeason.ID);
			addPotentialTask(taskSowLateCrop, CoreLateRainsSeason.ID);
			addPotentialTask(taskHarvestCrop, CoreEarlyHarvestSeason.ID);
			addPotentialTask(taskHarvestCrop, CoreLateHarvestSeason.ID);
			addPotentialTask(taskBabysit, CoreEarlyRainsSeason.ID);
			addPotentialTask(taskBabysit, CoreLateRainsSeason.ID);
			addPotentialTask(taskBabysit, CoreEarlyHarvestSeason.ID);
			addPotentialTask(taskBabysit, CoreLateHarvestSeason.ID);
			addPotentialTask(taskWeedCrop, CoreLateRainsSeason.ID);
			addPotentialTask(taskWeedCrop, CoreEarlyHarvestSeason.ID);
			addPotentialTask(taskFertilise, CoreLateRainsSeason.ID);
			addPotentialTask(taskFertilise, CoreEarlyHarvestSeason.ID);
			addPotentialTask(taskFarmElsewhere, CoreEarlyRainsSeason.ID);
			addPotentialTask(taskFarmElsewhere, CoreLateRainsSeason.ID);
			addPotentialTask(taskFarmElsewhere, CoreEarlyHarvestSeason.ID);
			addPotentialTask(taskFarmElsewhere, CoreLateHarvestSeason.ID);
			addPotentialTask(taskHerbicide, CoreLateRainsSeason.ID);
			addPotentialTask(taskHerbicide, CoreEarlyHarvestSeason.ID);
			addPotentialTask(taskSchool, CoreEarlyRainsSeason.ID);
			addPotentialTask(taskSchool, CoreLateRainsSeason.ID);
			addPotentialTask(taskSchool, CoreEarlyHarvestSeason.ID);
			addPotentialTask(taskSchool, CoreLateHarvestSeason.ID);
			addPotentialTask(taskHousework, CoreEarlyRainsSeason.ID);
			addPotentialTask(taskHousework, CoreLateRainsSeason.ID);
			addPotentialTask(taskHousework, CoreEarlyHarvestSeason.ID);
			addPotentialTask(taskHousework, CoreLateHarvestSeason.ID);
			addPotentialTask(taskSprayInsecticide, CoreLateRainsSeason.ID);
			addPotentialTask(taskSprayInsecticide, CoreEarlyHarvestSeason.ID);
			addPotentialTask(taskSprayInsecticide, CoreLateHarvestSeason.ID);
		} catch (Exception e) {
			String message = "Problem generating potential task list: " + e.getMessage();
			Logger.ErrorLog("CoreTaskList.setupPotentialTasks", message);
		}
	}

	@Override
	public Task newTaskInstance(String taskType) throws Exception {
		if (taskType.equals(TaskSowEarlyCrop.TASKTYPE)){
			return new TaskSowEarlyCrop();
		} else if(taskType.equals(TaskSowLateCrop.TASKTYPE)){
			return new TaskSowLateCrop();
		} else if(taskType.equals(TaskHarvestCrop.TASKTYPE)){
			return new TaskHarvestCrop();
		} else if(taskType.equals(TaskBabysit.TASKTYPE)) {
			return new TaskBabysit();
		} else if(taskType.equals(TaskWeedCrop.TASKTYPE)) {
			return new TaskWeedCrop();
		} else if(taskType.equals(TaskFarmElsewhere.TASKTYPE)){
			return new TaskFarmElsewhere();
		} else if(taskType.equals(TaskFertilise.TASKTYPE)){
			return new TaskFertilise();
		} else if(taskType.equals(TaskHerbicide.TASKTYPE)){
			return new TaskHerbicide();
		} else if (taskType.equals(TaskSchool.TASKTYPE)){
			return new TaskSchool();
		} else if (taskType.equals(TaskHousehold.TASKTYPE)){
			return new TaskHousehold();
		} else if (taskType.equals(TaskSprayInsecticide.TASKTYPE)){
			return new TaskSprayInsecticide();
		}
		
		throw new Exception("TaskType " + taskType + " unknown. Unable to generate new task.");
	}

}
