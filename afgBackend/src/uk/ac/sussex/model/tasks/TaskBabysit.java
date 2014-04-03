/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.tasks;

import java.util.HashSet;
import java.util.Set;

import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.utilities.Logger;

public class TaskBabysit extends Task {
	public static String TASKTYPE =  "TASK_BABYSIT";
	public static String DISPLAYNAME = "Babysit";
	
	public TaskBabysit(){
		super();
		this.setTaskType(TASKTYPE);
		this.addOptionalParam("Asset");
		this.addOptionalParam("AssetAmount");
	}
	@Override
	public String getDisplayName() {
		// TODO Auto-generated method stub
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
			this.setNotes("There was a problem confirming the availability of the person you asked to babysit.");
			
			Logger.ErrorLog("TaskBabysit.execute", "Problem confirming actor availability " + e1.getMessage());
		}
		if(actorAvailable){
			this.setStatus(COMPLETED);
			this.setNotes("The babysitting was completed.");
		} else if(this.getNotes()==null){
			this.setStatus(ERROR);
			this.setNotes("The person you selected to babysit was too busy.");
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
		
		//Need to check there are some babies!
		Boolean hasBabies = false;
		try {
			hasBabies = household.needsBabysitter();
		} catch (Exception e1) {
			Logger.ErrorLog("TaskBabysit.fetchPossibleLocations", "Problem checking for babies: " + e1.getMessage());
			to.setStatus(TaskOption.INVALID);
			to.setNotes("A problem meant that I couldn't tell if you have any babies to babysit.");
		}
		if(!hasBabies && !to.getStatus().equals(TaskOption.INVALID)){
			to.setStatus(TaskOption.INVALID);
			to.setNotes("This household has no babies that need babysitting.");
		}
		if(!to.getStatus().equals(TaskOption.INVALID)){
			try {
				TaskList tl = fetchHouseholdTasklist(household);
				if(tl!=null){
					Integer numBabysittingTasks = tl.countPendingLocationTasks(household, household, TASKTYPE);
					if(numBabysittingTasks > 0){
						to.setStatus(TaskOption.INVALID);
						to.setNotes("You already have a task set up for babysitting. You only need one.");
					}
				} else {
					to.setStatus(TaskOption.INVALID);
					to.setNotes("An error meant I couldn't tell if this is your only babysitting task or not.");
				}
			} catch (Exception e) {
				String errorMessage = "Problem checking number of babysitting tasks: "+ e.getMessage();
				Logger.ErrorLog("TaskBabysit.fetchPossibleLocations", errorMessage);
				to.setStatus(TaskOption.INVALID);
				to.setNotes("An error meant I couldn't tell if this is your only babysitting task or not.");
			}
		}
		locations.add(to);
			
		return locations;
	}

	@Override
	public Set<TaskOption> fetchPossibleActors(Hearth household) {
		Set<TaskOption> actors = this.fetchAdultOptions(household);
		actors.addAll(this.fetchChildrenOptions(household));
		return actors;
	}

	@Override
	public Set<TaskOption> fetchPossibleAssets(Hearth household) {
		//No assets required.
		return null;
	}
	
}
