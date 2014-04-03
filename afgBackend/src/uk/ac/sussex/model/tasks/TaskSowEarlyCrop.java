package uk.ac.sussex.model.tasks;

import uk.ac.sussex.model.*;

public class TaskSowEarlyCrop extends TaskSowCrop {
	public static String TASKTYPE = "TASK_SOW_EARLY_CROP";
	public static String DISPLAYNAME = "Sow crop";
	public TaskSowEarlyCrop(){
		super();
		this.setPlantingType(Field.EARLY_PLANTING);
		this.setTaskType(TASKTYPE);
	}

	@Override 
	public String getDisplayName(){
		return DISPLAYNAME; 
	}
}
