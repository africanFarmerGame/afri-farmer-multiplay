package uk.ac.sussex.model.tasks;

import uk.ac.sussex.model.*;

public class TaskSowLateCrop extends TaskSowCrop {
	public static String TASKTYPE = "TASK_SOW_LATE_CROP";
	public TaskSowLateCrop(){
		super();
		this.setPlantingType(Field.LATE_PLANTING);
		this.setTaskType(TASKTYPE);
	}
}
