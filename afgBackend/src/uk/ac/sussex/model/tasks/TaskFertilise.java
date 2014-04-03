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

public class TaskFertilise extends Task{
	public static String TASKTYPE =  "TASK_FERTILIZE";
	public static String DISPLAYNAME = "Fertilize";
	public TaskFertilise(){
		super();
		this.setTaskType(TASKTYPE);
	}
	@Override
	public String getDisplayName() {
		return DISPLAYNAME;
	}

	/**
	 * This needs to check the availability of the farmer, and the asset (and spray kit). Needs to see if 
	 * field is already fertilised, and then set the fertiliser field to the id of the fertiliser used.
	 */
	@Override
	public void execute() {
		Boolean actorAvailable = false;
		try {
			actorAvailable = this.confirmActorAvailability(this, TaskFarmElsewhere.TASKTYPE);
		} catch (Exception e1) {
			this.setStatus(ERROR);
			this.setNotes("There was a problem getting the availability for the person you allocated to do this task.");
			Logger.ErrorLog("TaskFertilise", "Problem confirming actor availability: " + e1.getMessage());
		}
		if(actorAvailable){
			AssetFactory af = new AssetFactory();
			Asset fertiliser = null;
			try {
				fertiliser = af.fetchAsset(this.getAsset().getId());
			} catch (Exception e) {
				String message = "There was a problem getting the fertiliser: " + e.getMessage();
				Logger.ErrorLog("TaskFertilise.execute", message);
				this.setStatus(ERROR);
				this.setNotes("There was a problem finding the fertiliser.");
			}
			if(fertiliser!=null && fertiliser.getType().equals("FERTILISER")){
				//Need to check amount and subtype. 
				AssetOwnerFactory aof = new AssetOwnerFactory();
				AssetOwner fertiliserOwned = null;
				Hearth household = getHousehold();
				try {
					fertiliserOwned = aof.fetchSpecificAsset(household, fertiliser);
				} catch (Exception e) {
					String message = "There was a problem getting the fertiliser Owner record: " + e.getMessage();
					Logger.ErrorLog("TaskFertilise.execute", message);
					this.setStatus(ERROR);
					this.setNotes("There was a problem working out how much fertiliser you own.");
				}
				Boolean ownFertiliser = true;
				if(fertiliserOwned!=null && fertiliserOwned.getAmount()>= 1) {
					/*if(fertiliser.getSubtype().equals("INORGANIC")){
						if(!haveSprayKit(household, af, aof)){
							this.setStatus(ERROR);
							this.setNotes("You need a spraykit to use that type of fertiliser.");
							ownFertiliser = false;
						}
					}*/
				} else if (fertiliserOwned!=null){
					this.setStatus(ERROR);
					this.setNotes("You did not have enough fertiliser to use.");
					ownFertiliser = false;
				} else {
					//No record for this house. 
					this.setStatus(ERROR);
					this.setNotes("You don't own enough fertiliser for this.");
					ownFertiliser = false;
				}
				if(ownFertiliser){
					Boolean fertilised = false;
					FieldFactory ff = new FieldFactory();
					Field field = null;
					try {
						field = ff.getFieldById(this.getLocation().getId());
					} catch (Exception e1) {
						String message = "Problem fetching the field: " + e1.getMessage();
						Logger.ErrorLog("TaskFertilise.execute", message);
					}
					if(field.getCrop()==null){
						this.setStatus(ERROR);
						this.setNotes("There was no crop in the field to fertilise.");
					} else if(field.getFertiliser()==null){
						field.setFertiliser(fertiliser);
						fertiliserOwned.setAmount(fertiliserOwned.getAmount() - 1);
						try{
							field.save();
							fertiliserOwned.save();
						} catch (Exception e) {
							String message = "Problem saving task output: " + e.getMessage();
							Logger.ErrorLog("TaskFertilise.execute", message);
							this.setStatus(ERROR);
							this.setNotes("There was a problem executing this task.");
						}
						this.setStatus(COMPLETED);
						this.setNotes(field.getName() + " was fertilised with " + fertiliser.getName());
						fertilised = true;
					} else {
						this.setStatus(ERROR);
						this.setNotes("This field has already been fertilised.");
					}
					updateFieldHistory(field, ff, fertilised);
				}
			} else if (fertiliser!=null){
				this.setStatus(ERROR);
				this.setNotes("There was something funny about that fertiliser.");
			}
		} else {
			this.setStatus(ERROR);
			this.setNotes("The person assigned to this task wasn't available.");
		}
		try {
			this.save();
		} catch (Exception e) {
			String errorMessage = "Problem saving task id " + this.getId() + ": " + e.getMessage();
			Logger.ErrorLog("TaskFertilise.execute", errorMessage);
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
					Integer cropAge = field.getCropAge();
					if(cropAge>0&&cropAge<=crop.getMaturity()-2){
						int fertilisingTaskCount = tl.countPendingLocationTasks(household, field, TaskFertilise.TASKTYPE);
						if(fertilisingTaskCount==0){
							to.setStatus(TaskOption.VALID);
						} else {
							to.setStatus(TaskOption.INVALID);
							to.setNotes("You are already fertilising this field.");
						}
					} else {
						to.setStatus(TaskOption.INVALID);
						to.setNotes("The crop in this field does not need fertilising.");
					}
				}else {
					to.setStatus(TaskOption.INVALID);
					to.setNotes("There is no crop in this field to fertilise.");
				}
				possibleLocations.add(to);
			}
			return possibleLocations;
		} catch (Exception e) {
			//Not quite sure what to do with this. Log it and return null I guess.
			String errormessage = "Problem fetching the fields: " + e.getMessage();
			Logger.ErrorLog("TaskFertilise.fetchPossibleLocations hearth " + household.getId(), errormessage);
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
		//Two types of asset to worry about here: Organic and inorganic fertiliser. 
		//Fetch both at once, then work out separately?
		AssetFactory af = new AssetFactory();
		Set<Asset> fertilisers = null;
		TaskList tl = fetchHouseholdTasklist(household);
		try {
			fertilisers = af.fetchFertilisers();
		} catch (Exception e) {
			String message = "Problem getting fertilisers for household " + household.getId().toString() + ": " + e.getMessage();
			Logger.ErrorLog("TaskFertilise.fetchPossibleAssets", message);
			return null;
		}
		AssetOwnerFactory aof = new AssetOwnerFactory();
		Set<TaskOption> assets = new HashSet<TaskOption>();
		
		for (Asset fertiliser: fertilisers){
			TaskOption to = new TaskOption();
			to.setName(fertiliser.getName());
			to.setValue(fertiliser.getId());
			to.setType("FERTILISER");
			AssetOwner fertiliserOwner = null;
			try {		
				fertiliserOwner = aof.fetchSpecificAsset(household, fertiliser);
				if(fertiliserOwner!=null && fertiliserOwner.getAmount()>=1){
					Integer pendingAmount = tl.countPendingAssetAmount(household, fertiliser);
					if(pendingAmount >= fertiliserOwner.getAmount()){
						to.setStatus(TaskOption.INVALID);
						to.setNotes("You have already allocated all of your available fertiliser.");
					} else {
						to.setStatus(TaskOption.VALID);
					}
				} else {
					to.setStatus(TaskOption.INVALID);
					to.setNotes("You do not have access to enough of this fertiliser.");
				}
			} catch (Exception e) {
				String message = "Problem getting ownership of " + fertiliser.getName() + " for household " + household.getId().toString() + ": " +e.getMessage();
				Logger.ErrorLog("TaskFertiliser.fetchPossibleAssets", message);
				to.setStatus(TaskOption.WARNING);
				to.setNotes("Problem checking available quantities of this fertiliser.");
			}
			assets.add(to);
		}
		return assets;
	}
	private void updateFieldHistory(Field field, FieldFactory fieldFactory, Boolean fertilised){
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		SeasonDetail sd = null;
		try {
			sd = sdf.fetchSeasonDetail(this.getSeason().getId());
		} catch (Exception e1) {
			Logger.ErrorLog("TaskFertilise.updateFieldHistory", "Problem fetching field history for field " + field.getId() + " - unable to retrieve game year: " + e1.getMessage() );
			return;
		}
		Integer gameYear = sd.getGameYear();
		
		FieldHistory fieldHistory = null; 
		try {
			fieldHistory = fieldFactory.fetchSpecificFieldHistory(field, gameYear);
		} catch (Exception e) {
			Logger.ErrorLog("TaskFertilise.updateFieldHistory", "Problem fetching field history for field " + field.getId() + "in game year " + gameYear + ": " + e.getMessage() );
			return;
		}
		if(fertilised){
			fieldHistory.setFertilised(FieldHistory.FERTILISED_YES);
		} else {
			fieldHistory.setFertilised(FieldHistory.FERTILISED_NO);
		}
		try {
			fieldHistory.save();
		} catch (Exception e) {
			Logger.ErrorLog("TaskFertilise.updateFieldHistory", "Problem saving field history " + fieldHistory.getId() + ": " + e.getMessage()); 
		}
		return;
	}
}
