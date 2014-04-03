/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.tasks;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.Asset;
import uk.ac.sussex.model.AssetCrop;
import uk.ac.sussex.model.AssetFactory;
import uk.ac.sussex.model.AssetOwner;
import uk.ac.sussex.model.AssetOwnerFactory;
import uk.ac.sussex.model.Field;
import uk.ac.sussex.model.FieldFactory;
import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.utilities.Logger;

public class TaskHerbicide extends Task {
	public static String TASKTYPE =  "TASK_HERBICIDE";
	public static String DISPLAYNAME = "Spray herbicide";
	public TaskHerbicide(){
		super();
		this.setTaskType(TASKTYPE);
		this.addOptionalParam("Actor");
	}
	@Override
	public String getDisplayName() {
		return DISPLAYNAME;
	}

	@Override
	public void execute() {
		
		Hearth household = getHousehold();
		AssetFactory af = new AssetFactory();
		Asset herbicide = null;
		try {
			herbicide = af.fetchAsset(this.getAsset().getId());
		} catch (Exception e) {
			String message = "There was a problem getting the herbicide: " + e.getMessage();
			Logger.ErrorLog("TaskHerbicide.execute", message);
			this.setStatus(ERROR);
			this.setNotes("There was a problem finding the herbicide.");
		}
		if(herbicide!=null&&herbicide.getType().equals("HERBICIDE")){
			AssetOwnerFactory aof = new AssetOwnerFactory();
			
			AssetOwner herbicideOwner = null;
			try {
				herbicideOwner = aof.fetchSpecificAsset(household, herbicide);
			} catch (Exception e) {
				String message = "There was a problem getting the herbicide owner: " + e.getMessage();
				Logger.ErrorLog("TaskHerbicide.execute", message);
				this.setStatus(ERROR);
				this.setNotes("There was a problem working out how much herbicide you own.");
			}
			
			if(herbicideOwner!=null && herbicideOwner.getAmount()>=1){
				Boolean hasSprayKit = this.haveSprayKit(getHousehold(), af, aof);
				if(hasSprayKit){
					FieldFactory ff = new FieldFactory();
					Field field = null;
					try {
						field = ff.getFieldById(this.getLocation().getId());
					} catch (Exception e) {
						String message = "Problem fetching the field: " + e.getMessage();
						Logger.ErrorLog("TaskHerbicide.execute", message);
						this.setStatus(ERROR);
						this.setNotes("There was a problem identifying the field you wanted to use herbicide on.");
					}
				
					AssetCrop crop = null;
					if(field.getCrop()!=null){
						try {
							crop = (AssetCrop) af.fetchAsset(field.getCrop().getId());
						} catch (Exception e1) {
					 		String message = "Problem fetching the crop: " + e1.getMessage();
					 		Logger.ErrorLog("TaskFertilise.execute", message);
						}
					}
					if(field!=null && crop==null){
						this.setStatus(ERROR);
						this.setNotes("The field didn't contain a crop!");
					} else if (field!=null) {
						Integer maxWeedAge = crop.getMaturity() -2;
						Integer cropCurrentAge = field.getCropAge();
						if(cropCurrentAge > 0 && cropCurrentAge <= maxWeedAge){
							Integer currentHealth = field.getCropHealth();
							currentHealth += crop.getWeedLoss();
							field.setCropHealth(currentHealth);
							herbicideOwner.setAmount(herbicideOwner.getAmount() -1);
							try {
								field.save();
								herbicideOwner.save();
								this.setStatus(COMPLETED);	
							} catch (Exception e) {
								String message = "Problem saving field: " + e.getMessage();
								Logger.ErrorLog("TaskFertilise.execute", message);
								this.setStatus(ERROR);
								this.setNotes("We had a backend problem that meant this task couldn't be completed.");
							}					
						} else {
							this.setStatus(ERROR);
							this.setNotes("The crop in " + field.getName() + " does not need weeding right now.");
						}
					} 
				} else {
					this.setStatus(ERROR);
					this.setNotes("You needed a spray kit to perform this action.");
				}
			} else if (this.getStatus().equals(PENDING)) {
				this.setStatus(ERROR);
				this.setNotes("You didn't own enough herbicide to complete that task.");
			}
		} else {
			this.setStatus(ERROR);
			this.setNotes("There was something not quite right about that herbicide.");
		}
		try {
			this.save();
		} catch (Exception e) {
			String errorMessage = "Problem saving task id " + this.getId() + ": " + e.getMessage();
			Logger.ErrorLog("TaskHerbicide.execute", errorMessage);
		}
	}

	@Override
	public Set<TaskOption> fetchPossibleLocations(Hearth household) {
		FieldFactory fieldFactory = new FieldFactory();
		AssetFactory assetFactory = new AssetFactory();
		Set<TaskOption> possibleLocations = new HashSet<TaskOption>();
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
						to.setStatus(TaskOption.VALID);
					} else {
						to.setStatus(TaskOption.INVALID);
						to.setNotes("The crop in this field does not need herbicide.");
					}
				}else {
					to.setStatus(TaskOption.INVALID);
					to.setNotes("There is no crop in this field that needs herbicide.");
				}
				possibleLocations.add(to);
			}
			return possibleLocations;
		} catch (Exception e) {
			String errormessage = "Problem fetching the fields: " + e.getMessage();
			Logger.ErrorLog("TaskHerbicide.fetchPossibleLocations hearth " + household.getId(), errormessage);
			return null;
		}

	}

	@Override
	public Set<TaskOption> fetchPossibleActors(Hearth household) {
		//This task doesn't actually need any actors. 
		return null;
	}

	@Override
	public Set<TaskOption> fetchPossibleAssets(Hearth household) {
		//Need to look for the spray kit before this one is valid. 
		AssetFactory af = new AssetFactory();
		Set<Asset> herbicides = null;
		TaskList tl = fetchHouseholdTasklist(household);
		try {
			herbicides = af.fetchHerbicide();
		} catch (Exception e) {
			String message = "Problem getting herbicides for household " + household.getId().toString() + ": " + e.getMessage();
			Logger.ErrorLog("TaskHerbicide.fetchPossibleAssets", message);
			return null;
		}
		AssetOwnerFactory aof = new AssetOwnerFactory();
		Boolean hasSpraykit = this.haveSprayKit(household, af, aof);
		Set<TaskOption> options = new HashSet<TaskOption>();
		for(Asset herbicide: herbicides){
			TaskOption to = new TaskOption();
			to.setName(herbicide.getName());
			to.setValue(herbicide.getId());
			to.setType("HERBICIDE");
			AssetOwner herbicideOwner;
			try {
				herbicideOwner = aof.fetchSpecificAsset(household, herbicide);
			
				if(herbicideOwner!=null && herbicideOwner.getAmount()>0){
					Integer pendingAmount = tl.countPendingAssetAmount(household, herbicide);
					if(pendingAmount<=herbicideOwner.getAmount()){
						if(hasSpraykit){
							to.setStatus(TaskOption.VALID);
						} else {
							to.setStatus(TaskOption.INVALID);
							to.setNotes("You need to buy a Spray Kit to use herbicide.");
						}
					} else {
						to.setStatus(TaskOption.INVALID);
						to.setNotes("You have already assigned the herbicide you own.");
					}
				} else {
					to.setStatus(TaskOption.INVALID);
					to.setNotes("You do not own enough of this to use.");
				}
			} catch (Exception e) {
				String message = "Problem checking herbicide amounts for household " + household.getId() + ": " + e.getMessage();
				Logger.ErrorLog("TaskHerbicide.fetchPossibleAssets", message);
				to.setStatus(TaskOption.WARNING);
				to.setNotes("Not able to confirm the availability of this asset.");
			}
			options.add(to);
		}
		return options;
	}

}
