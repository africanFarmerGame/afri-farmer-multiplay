/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.tasks;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.*;
import uk.ac.sussex.utilities.Logger;

public class TaskHarvestCrop extends Task {
	public static String TASKTYPE =  "TASK_HARVEST_CROP";
	public static String DISPLAYNAME = "Harvest crop";
	
	public TaskHarvestCrop(){
		super();
		this.setTaskType(TASKTYPE);
		this.addOptionalParam("Asset");
		this.addOptionalParam("AssetAmount");
	}
	@Override
	public String getDisplayName() {
		return TaskHarvestCrop.DISPLAYNAME;
	}

	@Override
	public void execute() {
		// Execute will take a field, check for crop, check crop is of the right age(?), 
		// calculate the amount of crop, then add the crop to the asset owners. 
		// I therefore need a field with a crop of the right age. 
		FieldFactory fieldFactory = new FieldFactory();
		Boolean actorAvailable = false;
		try {
			actorAvailable = this.confirmActorAvailability(this, TaskFarmElsewhere.TASKTYPE);
		} catch (Exception e1) {
			this.setStatus(ERROR);
			this.setNotes("There was a problem getting the availability for the person you allocated to do this task.");
			Logger.ErrorLog("TaskHarvestCrop.execute", "Problem confirming actor availability: " + e1.getMessage());
		}
		if(actorAvailable){
			try {
				if(this.getLocation()==null){
					this.setStatus(ERROR);
					this.setNotes("There was no location stored for the harvest task.");
				} else {
					Field field = fieldFactory.getFieldById(this.getLocation().getId());
					if(field.getCrop()==null){
						this.setStatus(ERROR);
						this.setNotes(field.getName() + " had no crop to harvest.");
					} else {
						AssetFactory af = new AssetFactory();
						AssetCrop crop = (AssetCrop) af.fetchAsset(field.getCrop().getId());
						Integer cropHarvestAge = crop.getMaturity() -1;
						if(field.getCropAge()<cropHarvestAge){
							this.setStatus(ERROR);
							this.setNotes("The crop in " + field.getName() + " was not ready to harvest yet.");
						} else {
							Integer harvestAmount = field.calculateYield(getSeason());
							
							AssetOwnerFactory aof = new AssetOwnerFactory();
							Asset outputAsset = af.fetchAsset(crop.getOutputAsset().getId());
							AssetOwner assetOwnership = aof.fetchSpecificAsset(field.getHearth(), outputAsset);
							Double newAmount = assetOwnership.getAmount() + harvestAmount;
							assetOwnership.setAmount(newAmount);
							assetOwnership.save();
							field.clearCrop();
							field.save();
							this.setStatus(COMPLETED);
							this.setNotes(field.getName() + " yielded " + harvestAmount.intValue() + " " + outputAsset.getMeasurement() + "s of " + outputAsset.getName());
							this.updateFieldHistory(field, fieldFactory, harvestAmount);
						}
					}
				}			
			} catch (Exception e) {
				String errormessage = "Problem executing task id " + this.getId() + ": " + e.getMessage();
				Logger.ErrorLog("TaskHarvestCrop.execute", errormessage);
				this.setStatus(ERROR);
				this.setNotes("We were unable to execute this task as a result of a back end problem. Sorry about that. It has been reported.");
			}
		} else if (this.getNotes() == null){
			this.setStatus(ERROR);
			this.setNotes("The person you selected for this task was unavailable.");
		}
		try {
			this.save();
		} catch (Exception e) {
			String errorMessage = "Problem saving task id " + this.getId() + ": " + e.getMessage();
			Logger.ErrorLog("TaskHarvestCrop.execute", errorMessage);
		}
	}

	@Override
	public Set<TaskOption> fetchPossibleLocations(Hearth household) {
		FieldFactory fieldFactory = new FieldFactory();
		AssetFactory assetFactory = new AssetFactory();
		Set<TaskOption> possibleLocations = new HashSet<TaskOption>();
		TaskList tl = fetchHouseholdTasklist(household);
		try {
			List<Field> fields = fieldFactory.getHearthFields(household);
			for (Field field : fields){
				TaskOption to = new TaskOption();
				to.setName(field.getName());
				to.setValue(field.getId());
				to.setType(field.getType());
				if(field.getCrop() != null){
					AssetCrop crop = (AssetCrop) assetFactory.fetchAsset(field.getCrop().getId());
					if((crop.getMaturity() - 1) == field.getCropAge()){
						int currentHarvestTasks = tl.countPendingLocationTasks(household, field, TASKTYPE);
						if(currentHarvestTasks>0){
							to.setStatus(TaskOption.INVALID);
							to.setNotes("There is already a harvest task set for this location.");
						} else {
							to.setStatus(TaskOption.VALID);
						}
					} else {
						to.setStatus(TaskOption.INVALID);
						to.setNotes("The crop in this field is not ready to harvest.");
					}
				}else {
					to.setStatus(TaskOption.INVALID);
					to.setNotes("There is no crop in this field to harvest.");
				}
				possibleLocations.add(to);
			}
			return possibleLocations;
		} catch (Exception e) {
			//Not quite sure what to do with this. Log it and return null I guess.
			String errormessage = "Problem fetching the fields: " + e.getMessage();
			Logger.ErrorLog("TaskHarvestCrop.fetchPossibleLocations hearth " + household.getId(), errormessage);
			return null;
		}
	}

	@Override
	public Set<TaskOption> fetchPossibleActors(Hearth household) {
		Set<TaskOption> actors = this.fetchAdultOptions(household);
		Set<TaskOption> externalActors = this.fetchExternalAdultFarmWorkers(household);
		if(externalActors != null && actors!=null){
			actors.addAll(externalActors);
		}
		return actors;
	}

	@Override
	public Set<TaskOption> fetchPossibleAssets(Hearth household) {
		// No Assets are necessary for this task. 
		return null;
	}

	private void updateFieldHistory(Field field, FieldFactory fieldFactory, Integer yield){
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		SeasonDetail sd = null;
		try {
			sd = sdf.fetchSeasonDetail(this.getSeason().getId());
		} catch (Exception e1) {
			Logger.ErrorLog("TaskHarvestCrop.updateFieldHistory", "Problem fetching field history for field " + field.getId() + " - unable to retrieve game year: " + e1.getMessage() );
			return;
		}
		Integer gameYear = sd.getGameYear();
		
		FieldHistory fieldHistory = null; 
		try {
			fieldHistory = fieldFactory.fetchSpecificFieldHistory(field, gameYear);
		} catch (Exception e) {
			Logger.ErrorLog("TaskHarvestCrop.updateFieldHistory", "Problem fetching field history for field " + field.getId() + "in game year " + gameYear + ": " + e.getMessage() );
			return;
		}
		fieldHistory.setYield(yield);
		try {
			fieldHistory.save();
		} catch (Exception e) {
			Logger.ErrorLog("TaskHarvestCrop.updateFieldHistory", "Problem saving field history " + fieldHistory.getId() + ": " + e.getMessage()); 
		}
		return;
	}
}
