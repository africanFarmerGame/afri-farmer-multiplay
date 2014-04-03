/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
