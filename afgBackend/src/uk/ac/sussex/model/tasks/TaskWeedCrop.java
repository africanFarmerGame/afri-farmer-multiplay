/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

/**
 * 
 */
package uk.ac.sussex.model.tasks;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.AssetCrop;
import uk.ac.sussex.model.AssetFactory;
import uk.ac.sussex.model.Field;
import uk.ac.sussex.model.FieldFactory;
import uk.ac.sussex.model.FieldHistory;
import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.SeasonDetail;
import uk.ac.sussex.model.SeasonDetailFactory;
import uk.ac.sussex.utilities.Logger;

/**
 * @author em97
 *
 */
public class TaskWeedCrop extends Task {
	public static String TASKTYPE =  "TASK_WEED_CROP";
	public static String DISPLAYNAME = "Weed Crop";
	public TaskWeedCrop(){
		super();
		this.setTaskType(TASKTYPE);
		this.addOptionalParam("Asset");
		this.addOptionalParam("AssetAmount");
	}
	/* (non-Javadoc)
	 * @see uk.ac.sussex.model.tasks.Task#getDisplayName()
	 */
	@Override
	public String getDisplayName() {
		return DISPLAYNAME;
	}

	/* (non-Javadoc)
	 * @see uk.ac.sussex.model.tasks.Task#execute()
	 */
	@Override
	public void execute() {
		// Execute will take a field, check for crop, check crop is of the right age(?), 
		// and add the weeding loss back to the crop health. 
		// I therefore need a field with a crop of the right age. 
		FieldFactory fieldFactory = new FieldFactory();
		Boolean weeded = false;
		Boolean actorAvailable = false;
		try {
			actorAvailable = this.confirmActorAvailability(this, TaskFarmElsewhere.TASKTYPE);
		} catch (Exception e1) {
			this.setStatus(ERROR);
			this.setNotes("There was a problem getting the availability for the person you allocated to do this task.");
			Logger.ErrorLog("TaskWeedCrop.execute", "Problem confirming actor availability: " + e1.getMessage());
		}
		if(actorAvailable){
			try {
				if(this.getLocation()==null){
					this.setStatus(ERROR);
					this.setNotes("There was no location stored for the weed task.");
				} else {
					Field field = fieldFactory.getFieldById(this.getLocation().getId());
					if(field.getCrop()==null){
						this.setStatus(ERROR);
						this.setNotes(field.getName() + " had no crop to weed.");
					} else {
						AssetFactory af = new AssetFactory();
						AssetCrop crop = (AssetCrop) af.fetchAsset(field.getCrop().getId());
						Integer maxWeedAge = crop.getMaturity() -2;
						Integer cropCurrentAge = field.getCropAge();
						if(cropCurrentAge > 0 && cropCurrentAge <= maxWeedAge){
							field.setCropWeeded(1);
							field.save();
							weeded = true;
							this.setStatus(COMPLETED);	
							this.setNotes(field.getName() + " was weeded.");
						} else {
							this.setStatus(ERROR);
							this.setNotes("The crop in " + field.getName() + " does not need weeding right now.");
						}
					}
					this.updateFieldHistory(field, fieldFactory, weeded);
				}			
			} catch (Exception e) {
				String errormessage = "Problem executing task id " + this.getId() + ": " + e.getMessage();
				Logger.ErrorLog("TaskWeedCrop.execute", errormessage);
				this.setStatus(ERROR);
				this.setNotes("We were unable to execute this task as a result of a back end problem. Sorry about that. It has been reported.");
			}
		} else if (this.getNotes()==null) {
			this.setStatus(ERROR);
			this.setNotes("The person you allocated to do this task was not available.");
		}
		try {
			this.save();
		} catch (Exception e) {
			String errorMessage = "Problem saving task id " + this.getId() + ": " + e.getMessage();
			Logger.ErrorLog("TaskWeedCrop.execute", errorMessage);
		}

	}

	/* (non-Javadoc)
	 * @see uk.ac.sussex.model.tasks.Task#fetchPossibleLocations(uk.ac.sussex.model.Hearth)
	 */
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
						int weedingTaskCount = tl.countPendingLocationTasks(household, field, TaskWeedCrop.TASKTYPE);
						if(weedingTaskCount==0){
							to.setStatus(TaskOption.VALID);
						} else {
							to.setStatus(TaskOption.INVALID);
							to.setNotes("You are already weeding this field.");
						}
					} else {
						to.setStatus(TaskOption.INVALID);
						to.setNotes("The crop in this field does not need weeding.");
					}
				}else {
					to.setStatus(TaskOption.INVALID);
					to.setNotes("There is no crop in this field to weed.");
				}
				possibleLocations.add(to);
			}
			return possibleLocations;
		} catch (Exception e) {
			//Not quite sure what to do with this. Log it and return null I guess.
			String errormessage = "Problem fetching the fields: " + e.getMessage();
			Logger.ErrorLog("TaskWeedCrop.fetchPossibleLocations hearth " + household.getId(), errormessage);
			return null;
		}
	}

	/* (non-Javadoc)
	 * @see uk.ac.sussex.model.tasks.Task#fetchPossibleActors(uk.ac.sussex.model.Hearth)
	 */
	@Override
	public Set<TaskOption> fetchPossibleActors(Hearth household) {
		Set<TaskOption> actors = this.fetchAdultOptions(household);
		Set<TaskOption> externalActors = this.fetchExternalAdultFarmWorkers(household);
		if(externalActors != null && actors!=null){
			actors.addAll(externalActors);
		}
		return actors;
	}

	/* (non-Javadoc)
	 * @see uk.ac.sussex.model.tasks.Task#fetchPossibleAssets(uk.ac.sussex.model.Hearth)
	 */
	@Override
	public Set<TaskOption> fetchPossibleAssets(Hearth household) {
		// no assets required.
		return null;
	}

	private void updateFieldHistory(Field field, FieldFactory fieldFactory, Boolean weeded){
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		SeasonDetail sd = null;
		try {
			sd = sdf.fetchSeasonDetail(this.getSeason().getId());
		} catch (Exception e1) {
			Logger.ErrorLog("TaskWeedCrop.updateFieldHistory", "Problem fetching field history for field " + field.getId() + " - unable to retrieve game year: " + e1.getMessage() );
			return;
		}
		Integer gameYear = sd.getGameYear();
		
		FieldHistory fieldHistory = null; 
		try {
			fieldHistory = fieldFactory.fetchSpecificFieldHistory(field, gameYear);
		} catch (Exception e) {
			Logger.ErrorLog("TaskWeedCrop.updateFieldHistory", "Problem fetching field history for field " + field.getId() + "in game year " + gameYear + ": " + e.getMessage() );
			return;
		}
		if(weeded){
			fieldHistory.setWeeded(FieldHistory.WEEDED_YES);
		} else {
			fieldHistory.setWeeded(FieldHistory.WEEDED_NO);
		}
		try {
			fieldHistory.save();
		} catch (Exception e) {
			Logger.ErrorLog("TaskWeedCrop.updateFieldHistory", "Problem saving field history " + fieldHistory.getId() + ": " + e.getMessage()); 
		}
		return;
	}
}
