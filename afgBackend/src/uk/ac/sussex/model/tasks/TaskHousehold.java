package uk.ac.sussex.model.tasks;

import java.util.HashSet;
import java.util.Set;

import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.utilities.Logger;

public class TaskHousehold extends Task {
	public static String TASKTYPE =  "TASK_HOUSEHOLD";
	public static String DISPLAYNAME = "Household chores";
	
	public TaskHousehold() {
		super();
		this.setTaskType(TASKTYPE);
		this.addOptionalParam("Asset");
		this.addOptionalParam("AssetAmount");
	}

	@Override
	public String getDisplayName() {
		return DISPLAYNAME;
	}

	@Override
	public void execute() {
		//TODO: Work out what actually ought to happen here, and some kind of punishment if they don't do this?
		Boolean actorAvailable = false;
		try {
			actorAvailable = this.confirmActorAvailability(this, null);
		} catch (Exception e1) {
			this.setStatus(ERROR);
			this.setNotes("There was a problem confirming the availability of the person you asked to do the household chores.");
			Logger.ErrorLog("TaskHousehold.execute", "Problem confirming actor availability: " + e1.getMessage());
		}
		if(actorAvailable){
			this.setStatus(COMPLETED);
			this.setNotes("The household chores were completed.");
		} else if(this.getNotes()==null){
			this.setStatus(ERROR);
			this.setNotes("The person you selected for household chores was too busy.");
		}
		try {
			this.save();
		} catch (Exception e) {
			String errorMessage = "Problem saving task id " + this.getId() + ": " + e.getMessage();
			Logger.ErrorLog("TaskBabysit.execute", errorMessage);
		}
	}

	@Override
	public Set<TaskOption> fetchPossibleLocations(Hearth household) {
		Set<TaskOption> locations = new HashSet<TaskOption>();
		TaskOption to = new TaskOption();
		to.setName(household.getName());
		to.setValue(household.getId());
		to.setType(household.getType());
		to.setStatus(TaskOption.VALID);
		try {
			TaskList tl = fetchHouseholdTasklist(household);
			if(tl!=null){
				Integer numBabysittingTasks = tl.countPendingLocationTasks(household, household, TASKTYPE);
				if(numBabysittingTasks > 0){
					to.setStatus(TaskOption.INVALID);
					to.setNotes("You already have a task set up for household chores. You only need one.");
				}
			} else {
				to.setStatus(TaskOption.WARNING);
				to.setNotes("An error meant I couldn't tell if this is your only household chores or not.");
			}
		} catch (Exception e) {
			String errorMessage = "Problem checking number of household chores tasks: "+ e.getMessage();
			Logger.ErrorLog("TaskHousehold.fetchPossibleLocations", errorMessage);
			to.setStatus(TaskOption.WARNING);
			to.setNotes("An error meant I couldn't tell if this is your only household chores or not.");
		}
	
		locations.add(to);
		
		return locations;
	}

	@Override
	public Set<TaskOption> fetchPossibleActors(Hearth household) {
		Set<TaskOption> actors = new HashSet<TaskOption>();
		actors.addAll(this.fetchAdultOptions(household));
		actors.addAll(this.fetchChildrenOptions(household));
		return actors;
	}

	@Override
	public Set<TaskOption> fetchPossibleAssets(Hearth household) {
		return null;
	}

}
