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
