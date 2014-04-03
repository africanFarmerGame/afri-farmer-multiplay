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
import uk.ac.sussex.model.seasons.SeasonalWeatherCropEffect;
import uk.ac.sussex.utilities.Logger;

public abstract class TaskSowCrop extends Task {
	private Integer plantingType;
	public static String DISPLAYNAME = "Sow crop";
	
	@Override
	public String getDisplayName() {
		return DISPLAYNAME;
	}

	@Override
	public void execute() {
		// Sow crop needs to make sure the household own the asset.
		AssetOwnerFactory aof = new AssetOwnerFactory();
		FieldFactory ff = new FieldFactory();
		Boolean actorAvailable = false;
		try {
			actorAvailable = this.confirmActorAvailability(this, TaskFarmElsewhere.TASKTYPE);
		} catch (Exception e1) {
			this.setStatus(ERROR);
			this.setNotes("There was a problem getting the availability for the person you allocated to do this task.");
			Logger.ErrorLog("TaskSowCrop.execute", "Problem confirming actor availability: " + e1.getMessage());
		}
		if(actorAvailable){
			try {
				AssetOwner ao = aof.fetchSpecificAsset(getHousehold(), getAsset());
				Double amount = ao.getAmount();
				if(amount >= this.getAssetAmount()){
					//Now check whether the field has a crop. 
					//Field field = (Field) this.getLocation();
					Field field = ff.getFieldById(this.getLocation().getId());
					Asset currentCrop = field.getCrop();
					
					if(currentCrop==null){
						//	The field has no crop, and the hearth owner has sufficient seed. 
						
						amount = amount - this.getAssetAmount();
						ao.setAmount(amount);
						
						field.setCrop(getAsset());
						field.setCropAge(0);
						//Need to check the weather. 
						Integer cropHealthWeatherAdjustment = this.getCropYieldReduction(getAsset().getId()); 
						field.setCropHealth(100 - cropHealthWeatherAdjustment);
						field.setCropPlanting(plantingType);
						this.setStatus(COMPLETED);
						this.setNotes("The crop was successfully sown in " + field.getName());
						ao.save();
						field.save();
						updateFieldHistory(field, getAsset(), ff);
					} else {
						this.setNotes(field.getName() + " already has a crop planted in it.");
						this.setStatus(ERROR);
					}
				} else {
					this.setNotes("Your household did not have sufficient supplies to sow this field.");
					this.setStatus(ERROR);
				}
			} catch (Exception e) {
				String errormessage = "Problem executing task id " + this.getId() + ": " + e.getMessage();
				Logger.ErrorLog("TaskSowCrop.execute", errormessage);
				this.setStatus(ERROR);
				this.setNotes("We were unable to execute this task as a result of a back end problem. Sorry about that. It has been reported.");
			}
		} else if (this.getNotes()==null) {
			this.setStatus(ERROR);
			this.setNotes("The person you allocated to this task was unavailable.");
		}
		try {
			this.save();
		} catch (Exception e) {
			String errorMessage = "Problem saving task id " + this.getId() + ": " + e.getMessage();
			Logger.ErrorLog("TaskSowCrop.execute", errorMessage);
		}
	}

	@Override
	public Set<TaskOption> fetchPossibleLocations(Hearth household) {
		FieldFactory ff = new FieldFactory();
		try {
			List<Field> hearthFields = ff.getHearthFields(household);
			Set<TaskOption> fields = new HashSet<TaskOption>();
			
			TaskList tl = fetchHouseholdTasklist(household);
			for (Field field: hearthFields){
				//Check the pending tasks for this field.
				
				TaskOption to = new TaskOption();
				to.setName(field.getName());
				to.setValue(field.getId());
				to.setType(field.getType());
				if(field.getCrop()==null){
					//Check the other tasks for this field. If there are any we can't be planting.
					if(tl != null){
						Integer taskCount = tl.countPendingLocationTasks(household, field, getTaskType());
						if(taskCount>0){
							to.setStatus(TaskOption.INVALID);
							to.setNotes("There are other tasks pending for this field.");
						} else {
							to.setStatus(TaskOption.VALID);
						}
					} else {
						to.setStatus(TaskOption.WARNING);
						to.setNotes("An error means I am unable to tell what other tasks are set for this field this season.");
					}
				} else {
					to.setStatus(TaskOption.INVALID);
					to.setNotes("This field already contains a crop.");
				}
				fields.add(to);
			}
			return fields;
		} catch (Exception e) {
			//Not quite sure what to do with this. Log it and return null I guess.
			String errormessage = "Problem fetching the fields: " + e.getMessage();
			Logger.ErrorLog("TaskSowCrop.fetchPossibleLocations hearth " + household.getId(), errormessage);
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
		AssetFactory af = new AssetFactory();
		AssetOwnerFactory aof = new AssetOwnerFactory();
		TaskList tl = fetchHouseholdTasklist(household);
		try {
			Set<AssetCrop> cropAssets = af.fetchCropAssets();
			Set<TaskOption> possibleAssets = new HashSet<TaskOption>();
			for (Asset asset: cropAssets){
				AssetOwner assetOwner = aof.fetchSpecificAsset(household, asset);
				TaskOption to = new TaskOption();
				to.setName(asset.getName());
				to.setValue(asset.getId());
				to.setType(asset.getType());
				if(assetOwner!= null && assetOwner.getAmount()>=1){	//TODO Update this to reflect the amount of asset needed for this task.
					if(tl!=null){
						Integer pendingAmount = tl.countPendingAssetAmount(household, asset);
						if(pendingAmount >= assetOwner.getAmount()){
							to.setStatus(TaskOption.INVALID);
							to.setNotes("You have already assigned all of the seed you own for this season.");
						} else {
							to.setStatus(TaskOption.VALID);
						}
					} else {
						to.setStatus(TaskOption.WARNING);
						to.setNotes("An error meant I can't tell how much of this crop you have left.");
					}
				} else {
					to.setStatus(TaskOption.INVALID);
					to.setNotes("You do not have access to enough of this crop to plant.");
				}
				possibleAssets.add(to);
			}
			return possibleAssets;
		} catch (Exception e) {
			String errormessage = "Problem fetching assets: " + e.getMessage();
			Logger.ErrorLog("TaskSowCrop.fetchPossibleAssets hearth " + household.getId(), errormessage);
		}
		return null;
	}
	protected void setPlantingType(Integer plantingType){
		this.plantingType = plantingType;
	}
	private Integer getCropYieldReduction(Integer cropId) throws Exception{
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		SeasonalWeatherCropEffect swcp = null;
		try {
			SeasonDetail sd = sdf.fetchSeasonDetail(this.getSeason().getId());
			swcp = sd.fetchCropEffect(cropId, this.plantingType);
		} catch (Exception e) {
			String message = "Problem getting the crop reduction value for cropId " + cropId;
			throw new Exception (message);
		}
		if(swcp==null){
			return 0;
		} else {
			return swcp.getYieldReduction();
		}
	}
	private void updateFieldHistory(Field field, Asset crop, FieldFactory fieldFactory){
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		SeasonDetail sd = null;
		try {
			sd = sdf.fetchSeasonDetail(this.getSeason().getId());
		} catch (Exception e1) {
			Logger.ErrorLog("TaskSowCrop.updateFieldHistory", "Problem fetching field history for field " + field.getId() + " - unable to retrieve game year: " + e1.getMessage() );
			return;
		}
		Integer gameYear = sd.getGameYear();
		
		FieldHistory fieldHistory = null; 
		try {
			fieldHistory = fieldFactory.fetchSpecificFieldHistory(field, gameYear);
		} catch (Exception e) {
			Logger.ErrorLog("TaskSowCrop.updateFieldHistory", "Problem fetching field history for field " + field.getId() + " in game year " + gameYear + ": " + e.getMessage() );
			return;
		}
		
		fieldHistory.setCrop(crop);
		fieldHistory.setPlantingTime(this.plantingType);
		try {
			fieldHistory.save();
		} catch (Exception e) {
			Logger.ErrorLog("TaskSowCrop.updateFieldHistory", "Problem saving field history " + fieldHistory.getId() + ": " + e.getMessage()); 
		}
		return;
	}
}
