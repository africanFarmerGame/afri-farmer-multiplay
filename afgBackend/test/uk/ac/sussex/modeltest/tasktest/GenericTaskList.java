/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.modeltest.tasktest;

import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.tasks.Task;
import uk.ac.sussex.model.tasks.TaskBabysit;
import uk.ac.sussex.model.tasks.TaskFarmElsewhere;
import uk.ac.sussex.model.tasks.TaskHarvestCrop;
import uk.ac.sussex.model.tasks.TaskList;
import uk.ac.sussex.model.tasks.TaskSowEarlyCrop;
import uk.ac.sussex.model.tasks.TaskSowLateCrop;
import uk.ac.sussex.model.tasks.TaskWeedCrop;

public class GenericTaskList extends TaskList {

	public GenericTaskList(Game game) {
		super(game);
		// TODO Auto-generated constructor stub
	}

	@Override
	protected void setupPotentialTasks() {
		// TODO Auto-generated method stub

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
		} else if(taskType.equals(GenericTask.TASKTYPE)){
			return new GenericTask();
		}
		
		throw new Exception("TaskType " + taskType + " unknown. Unable to generate new task.");
	}

}
