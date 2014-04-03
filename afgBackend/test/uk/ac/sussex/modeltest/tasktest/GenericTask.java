package uk.ac.sussex.modeltest.tasktest;

import java.util.Set;

import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.tasks.Task;
import uk.ac.sussex.model.tasks.TaskFarmElsewhere;
import uk.ac.sussex.model.tasks.TaskOption;
import uk.ac.sussex.utilities.Logger;

public class GenericTask extends Task {
	public static String TASKTYPE =  "GENERIC_TASK";
	public static String DISPLAYNAME = "Generic";
	public GenericTask(){
		super();
		this.setTaskType(TASKTYPE);
		this.addOptionalParam("Asset");
		this.addOptionalParam("AssetAmount");
		this.addOptionalParam("Location");
	}
	@Override
	public String getDisplayName() {
		return DISPLAYNAME;
	}

	@Override
	public void execute() {
		Boolean actorAvailable = false;
		try {
			actorAvailable = this.confirmActorAvailability(this, TaskFarmElsewhere.TASKTYPE);
		} catch (Exception e) {
			e.printStackTrace();
			this.setStatus(ERROR);
			this.setNotes("We had an issue confirming actor availability");
		}
		if (actorAvailable){
			this.setStatus(COMPLETED);			
		} else if (this.getNotes()==null){
			this.setStatus(ERROR);
			this.setNotes("The actor was unavailable.");
		}
		try {
			this.save();
		} catch (Exception e) {
			e.printStackTrace();
			Logger.ErrorLog("GenericTask.execute", "Saving got screwed.");
		}
	}

	@Override
	public Set<TaskOption> fetchPossibleLocations(Hearth household) {
		return null;
	}

	@Override
	public Set<TaskOption> fetchPossibleActors(Hearth household) {
		return null;
	}

	@Override
	public Set<TaskOption> fetchPossibleAssets(Hearth household) {
		return null;
	}

}
