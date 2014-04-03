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
import uk.ac.sussex.model.AssetFactory;
import uk.ac.sussex.model.AssetOwner;
import uk.ac.sussex.model.AssetOwnerFactory;
import uk.ac.sussex.model.Field;
import uk.ac.sussex.model.FieldFactory;
import uk.ac.sussex.model.FieldHazardHistory;
import uk.ac.sussex.model.HazardFactory;
import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.SeasonDetail;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;
import uk.ac.sussex.utilities.Logger;

public class TaskSprayInsecticide extends Task {
	public static String TASKTYPE = "TASK_SPRAY_INSECTICIDE";
	public static String DISPLAYNAME = "Spray Pesticide";
	
	public TaskSprayInsecticide(){
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
		Asset insecticide = null;
		try {
			insecticide = af.fetchAsset(this.getAsset().getId());
		} catch (Exception e) {
			String message = "There was a problem getting the insecticide: " + e.getMessage();
			Logger.ErrorLog("TaskSprayInsecticide.execute", message);
			this.setStatus(ERROR);
			this.setNotes("There was a problem finding the insecticide.");
		}
		if(insecticide!=null && insecticide.getType().equals("INSECTICIDE")){
			AssetOwnerFactory aof = new AssetOwnerFactory();

			AssetOwner insecticideOwner = null;
			try {
				insecticideOwner = aof.fetchSpecificAsset(household, insecticide);
			} catch (Exception e) {
				String message = "There was a problem getting the insecticide owner: " + e.getMessage();
				Logger.ErrorLog("TaskSprayInsecticide.execute", message);
				this.setStatus(ERROR);
				this.setNotes("There was a problem working out how much insecticide you own.");
			}
			Double insecticideAmount = insecticideOwner.getAmount();
			if(insecticideOwner!=null && insecticideAmount>=1){
				Boolean hasSprayKit = this.haveSprayKit(getHousehold(), af, aof);
				if(hasSprayKit){
					FieldFactory ff = new FieldFactory();
					Field field = null;
					try {
						field = ff.getFieldById(this.getLocation().getId());
					} catch (Exception e) {
						String message = "Problem fetching the field: " + e.getMessage();
						Logger.ErrorLog("TaskSprayInsecticide.execute", message);
						this.setStatus(ERROR);
						this.setNotes("There was a problem identifying the field you wanted to use insecticide on.");
					}
					if(field!=null){
						HazardFactory hf = new HazardFactory();
						FieldHazardHistory fhh = null;
						try {
							fhh = hf.fetchCurrentFieldHazard(field, getSeason());
						} catch (Exception e) {
							String message = "Problem fetching the field hazard history: " + e.getMessage();
							Logger.ErrorLog("TaskSprayInsecticide.execute", message);
						}
						if(fhh!=null){
							insecticideOwner.setAmount(insecticideAmount - 1);
							fhh.setMitigated(FieldHazardHistory.MITIGATED);
							try{
								fhh.save();
								insecticideOwner.save();
								this.setStatus(COMPLETED);
							} catch (Exception e) {
								String message = "Problem saving the items: " + e.getMessage();
								Logger.ErrorLog("TaskSprayInsecticide.execute", message);
								this.setStatus(ERROR);
								this.setNotes("A back end error prevented this task from completing.");
							}
						} else {
							this.setStatus(ERROR);
							this.setNotes("There was nothing wrong with that crop.");
						}
					} else {
						if(this.getStatus() == PENDING){
							this.setStatus(ERROR);
							this.setNotes("The field doesn't seem to have been quite right.");
						}
					}
				} else {
					this.setStatus(ERROR);
					this.setNotes("You need a spray kit to apply " + insecticide.getName());
				}
			} else {
				this.setStatus(ERROR);
				this.setNotes("You didn't own enough " + insecticide.getName()+ " to perform this task.");
			}
		} else {
			this.setStatus(ERROR);
			this.setNotes("There was something dodgy about the insecticide.");
		}
		try {
			this.save();
		} catch (Exception e) {
			String errorMessage = "Problem saving task id " + this.getId() + ": " + e.getMessage();
			Logger.ErrorLog("TaskSprayInsecticide.execute", errorMessage);
		}
	}

	@Override
	public Set<TaskOption> fetchPossibleLocations(Hearth household) {
		FieldFactory fieldFactory = new FieldFactory();
		HazardFactory hazardFactory = new HazardFactory();
		Set<TaskOption> possibleLocations = new HashSet<TaskOption>();
		try {
			List<Field> fields = fieldFactory.getHearthFields(household);
			for (Field field : fields){
				TaskOption to = new TaskOption();
				to.setName(field.getName());
				to.setValue(field.getId());
				to.setType(field.getType());
				if(field.getCrop() != null){
					GameFactory gf = new GameFactory();
					Game game = gf.fetchGame(household.getGame().getId());
					SeasonDetail sd = game.getCurrentSeasonDetail();
					FieldHazardHistory fhh = hazardFactory.fetchCurrentFieldHazard(field, sd);
					if(fhh == null){
						to.setStatus(TaskOption.INVALID);
						to.setNotes("The crop in this field is healthy.");
					} else {
						to.setStatus(TaskOption.VALID);
					}
				}else {
					to.setStatus(TaskOption.INVALID);
					to.setNotes("There is no crop in this field.");
				}
				possibleLocations.add(to);
			}
			return possibleLocations;
		} catch (Exception e) {
			String errormessage = "Problem fetching the fields: " + e.getMessage();
			Logger.ErrorLog("TaskSprayInsecticide.fetchPossibleLocations hearth " + household.getId(), errormessage);
			return null;
		}
	}

	@Override
	public Set<TaskOption> fetchPossibleActors(Hearth household) {
		//No need for any actors on this one. 
		return null;
	}

	@Override
	public Set<TaskOption> fetchPossibleAssets(Hearth household) {
		//Need to look for the spray kit before this one is valid. 
		AssetFactory af = new AssetFactory();
		Set<Asset> insecticides = null;
		TaskList tl = fetchHouseholdTasklist(household);
		try {
			insecticides = af.fetchInsecticide();
		} catch (Exception e) {
			String message = "Problem getting insecticides for household " + household.getId().toString() + ": " + e.getMessage();
			Logger.ErrorLog("TaskSprayInsecticide.fetchPossibleAssets", message);
			return null;
		}
		AssetOwnerFactory aof = new AssetOwnerFactory();
		Boolean hasSpraykit = this.haveSprayKit(household, af, aof);
		Set<TaskOption> options = new HashSet<TaskOption>();
		for(Asset insecticide: insecticides){
			TaskOption to = new TaskOption();
			to.setName(insecticide.getName());
			to.setValue(insecticide.getId());
			to.setType("INSECTICIDE");
			AssetOwner herbicideOwner;
			try {
				herbicideOwner = aof.fetchSpecificAsset(household, insecticide);

				if(herbicideOwner!=null && herbicideOwner.getAmount()>0){
					Integer pendingAmount = tl.countPendingAssetAmount(household, insecticide);
					if(pendingAmount<=herbicideOwner.getAmount()){
						if(hasSpraykit){
							to.setStatus(TaskOption.VALID);
						} else {
							to.setStatus(TaskOption.INVALID);
							to.setNotes("You need to buy a Spray Kit to use insecticide.");
						}
					} else {
						to.setStatus(TaskOption.INVALID);
						to.setNotes("You have already assigned the insecticide you own.");
					}
				} else {
					to.setStatus(TaskOption.INVALID);
					to.setNotes("You do not own enough of this to use.");
				}
			} catch (Exception e) {
				String message = "Problem checking insecticide amounts for household " + household.getId() + ": " + e.getMessage();
				Logger.ErrorLog("TaskSprayInsecticide.fetchPossibleAssets", message);
				to.setStatus(TaskOption.WARNING);
				to.setNotes("Not able to confirm the availability of this asset.");
			}
			options.add(to);
		}
		return options;
	}

}
