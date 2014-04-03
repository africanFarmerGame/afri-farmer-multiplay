package uk.ac.sussex.handlers;

import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.seasons.Season;
import uk.ac.sussex.model.seasons.SeasonList;
import uk.ac.sussex.model.tasks.*;
import uk.ac.sussex.utilities.GameHelper;
import uk.ac.sussex.utilities.Logger;
import uk.ac.sussex.utilities.UserHelper;

import com.smartfoxserver.v2.annotations.MultiHandler;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.extensions.SFSExtension;

@MultiHandler
public class FarmMultiHandler extends BaseClientRequestHandler {

	@Override
	public void handleClientRequest(User user, ISFSObject params) {
		String requestId = params.getUtfString(SFSExtension.MULTIHANDLER_REQUEST_ID);
		Integer hearthId = params.getInt("hearthId");
		try {
		    switch(FarmMultiEnum.toOption(requestId)) {
		    	case GET_FIELD_DETAILS:
		    		String owner = params.getUtfString("fieldOwner");
		    		Logger.Log(user.getName(), "Requested the field details from FarmMultiHandler for owner " + owner + " id " + hearthId.toString());
		    		
		     		this.getFieldDetails(hearthId, owner, user);
		     		break;
		    	case GET_POSSIBLE_TASKS:
		    		Logger.Log(user.getName(), "Requested a list of possible tasks for hearth " + hearthId.toString());
		    		this.getPossibleTasks(hearthId, user);
		    		break;
		    	case SAVE_TASK:
		    		Logger.Log(user.getName(), "Is trying to save a task.");
		    		this.saveTask(user, params);
		    		break;
		    	case GET_HOUSEHOLD_TASKS:
		    		Logger.Log(user.getName(), "Requested a list of household tasks for hearth " + hearthId.toString());
		    		this.getTasks(user, hearthId);
		    		break;
		    	case DELETE_TASK:
		    		Integer taskId = params.getInt("taskId");
		    		Logger.Log(user.getName(), "Asked to delete task " + taskId);
		    		this.deleteTask(user, taskId);
		    		break;
		    	case GM_FETCH_PENDING_TASKS:
		    		Logger.Log(user.getName(), "Asked for the number of pending tasks");
		    		this.gmFetchPendingTasksCount(user);
		    		break;
		    	default:
		    		Logger.Log(user.getName(), "Tried to ask for " + requestId + " from FarmMultiHandler");
		        	ISFSObject errObj = new SFSObject();
		        	errObj.putUtfString("message", "Unable to action request "+requestId);
		        	send("farmError", errObj, user);
		        	break;
		    	}
		}catch (Exception e) {
			ISFSObject errObj = SFSObject.newInstance();
	    	String message = "There has been a problem with request " + requestId + ": " +e.getMessage() ;
 			errObj.putUtfString("message", message);
 			Logger.ErrorLog("FarmMultiHandler.handleClientRequest(" + requestId + ")", message);
 			send(requestId + "_error", errObj, user);
		}

	}
	
	private void getFieldDetails(Integer ownerId, String owner, User user) throws Exception {
		
		List<Field> fields;
		if(owner.equals("H")){
			HearthFactory hf = new HearthFactory();
			Hearth hearth = null;
			try {
				hearth = hf.fetchHearth(ownerId);
			} catch (Exception e) {
				String message = "(FarmMultiHandler.getFieldDetails) Problem fetching details for hearth " + ownerId + ": " + e.getMessage();
				throw new Exception (message);
			}
			fields =  hearth.fetchFields();
		} else if (owner.equals("P")) {
			PlayerCharFactory pcf = new PlayerCharFactory();
			PlayerChar pc = null;
			try {
				pc = pcf.fetchPlayerChar(ownerId);
			} catch (Exception e) {
				String message = "(FarmMultiHandler.getFieldDetails) Problem fetching details for playerChar " + ownerId + ": " + e.getMessage();
				throw new Exception (message);
			}
			fields = pc.fetchFields();
		} else {
			throw new Exception ("(FarmMultiHander.getFieldDetails) Not sure what the owner of these fields is: " + owner);
		}
			
		Game game = UserHelper.fetchUserGame(user);
		
		SeasonDetail sd = game.getCurrentSeasonDetail();
		
		SFSArray outputArray = SFSArray.newInstance();
		
		for (Field field : fields) {
			SFSObject fieldObject = SFSObject.newInstance();
			try {
				fieldObject.putInt("Id", field.getId());
				fieldObject.putUtfString("Name", field.getName());
				fieldObject.putInt("Quality", field.getQuality());
				Asset crop = field.getCrop();
				if(crop==null){
					fieldObject.putNull("Crop");
					fieldObject.putNull("CropAge");
					fieldObject.putNull("CropHealth");
					fieldObject.putNull("CropPlanting");
					fieldObject.putNull("Weeded");
				} else {
					fieldObject.putInt("Crop", crop.getId());
					fieldObject.putInt("CropAge", field.getCropAge());
					fieldObject.putInt("CropHealth", field.getCropHealth());
					fieldObject.putInt("CropPlanting", field.getCropPlanting());
					fieldObject.putInt("Weeded", field.getCropWeeded());
					fieldObject.putInt("ExpectedYield", field.calculatePossibleYield());
					fieldObject = checkHazards(fieldObject, field, sd);
				}
				Asset fertiliser = field.getFertiliser();
				if(fertiliser == null){
					fieldObject.putNull("Fertiliser");
				} else {
					fieldObject.putInt("Fertiliser", fertiliser.getId());
				}

			} catch (Exception e) {
				String message = "(FarmMultiHandler.getFieldDetails) There was a problem adding field " + field.getName() + " to the SFSObject. " + e.getMessage();
				throw new Exception(message);
			}
			//TODO: Add hearth or owner.
			outputArray.addSFSObject(fieldObject);
		}
		
		SFSObject sendObject = SFSObject.newInstance();
		sendObject.putSFSArray("FieldDetails", outputArray);
		send("FieldDetails", sendObject, user);
		
	}
	private void getPossibleTasks(Integer hearthId, User user) throws Exception {
		Game game = UserHelper.fetchUserGame(user);
		TaskList taskList = game.fetchTaskList();
		
		
		
		SFSArray ptArray = wrapPossibleTasks(taskList, hearthId, game);

		SFSObject ptObj = SFSObject.newInstance();
		ptObj.putSFSArray("PotentialTasks", ptArray);
		
		send("PossibleTasks", ptObj, user);
	}
	private void saveTask(User user, ISFSObject params) throws Exception {
		
		String taskType = params.getUtfString("taskType");
		Task task;
		Integer taskId = params.getInt("taskId");
		Game game = UserHelper.fetchUserGame(user);
		TaskList tl = game.fetchTaskList();
		Integer hearthId = params.getInt("taskHearth");
		if(taskId>0){
			//We're updating a task.
			task = tl.getHouseholdTask(taskId);
		} else {
			//This is a new task. 
			task = tl.newTaskInstance(taskType);
			HearthFactory hf = new HearthFactory();
			Hearth household = hf.fetchHearth(hearthId);
			task.setHousehold(household);
			
			SeasonDetail currentSeason = game.getCurrentSeasonDetail();
			task.setSeason(currentSeason);
			//Need to generate the task number too. 
			task.setTaskNumber(tl.calculateNextTaskNumber(household));
		}
		Integer actorId = params.getInt("taskActor");
		if(actorId!=null && actorId>0){
			AllChars actor = new AllChars();
			actor.setId(actorId);
			task.setActor(actor);
		}
		
		Integer assetId = params.getInt("taskAsset");
		if(assetId!=null && assetId>0){
			Asset asset = new Asset();
			asset.setId(assetId);
			task.setAsset(asset);
			task.setAssetAmount(1);
		}
		
		Integer locId = params.getInt("taskLocation");
		if(locId!=null && locId>0){
			Location loc = new Location();
			loc.setId(locId);
			task.setLocation(loc);
		}
		
		task.save();
		SFSObject taskObj = this.translateTaskToSFSObject(task);
		//I need to get the rooms for this hearth's home and farm. 
		Zone currentZone = this.getParentExtension().getParentZone();
		List<User> users = GameHelper.fetchTaskListUsers(currentZone, hearthId);
		SFSObject wrapperObj = SFSObject.newInstance();
		wrapperObj.putSFSObject("Task", taskObj);
		send("NewTask", wrapperObj, users);

		//Also need to send all the new potential task info. 
		SFSArray potentialTasks = wrapPossibleTasks(tl, hearthId, game);
		if(potentialTasks !=null){
			SFSObject potentialTasksObj = SFSObject.newInstance();
			potentialTasksObj.putSFSArray("PotentialTasks",potentialTasks);
			send("PossibleTasks", potentialTasksObj, users);
		} else {
			Logger.ErrorLog("FarmMultiHandler.saveTask", "The potential tasks array was null. This is an error.");
		}
		
		updateGMManagerTaskNumbers(task.getHousehold(), game);
		
	}
	private void getTasks(User user, Integer hearthId) throws Exception {
		
		//Need to get a list of tasks for this household, which I think is going to use the tasklist.
		HearthFactory hf = new HearthFactory();
		Hearth household = hf.fetchHearth(hearthId);
		Game game = UserHelper.fetchUserGame(user);
		TaskList tl = game.fetchTaskList();
		List<Task> tasks = tl.getHouseholdTasks(household);
		
		SFSObject tasksObj = SFSObject.newInstance();
		SFSArray tasksArray = SFSArray.newInstance();
		for(Task task : tasks){
			SFSObject taskObj = this.translateTaskToSFSObject(task);
			tasksArray.addSFSObject(taskObj);
		}
		tasksObj.putSFSArray("Tasks", tasksArray);
		send("HouseholdTasks", tasksObj, user);
	}
	private void deleteTask(User user, Integer taskId) throws Exception {
		Game game = UserHelper.fetchUserGame(user);
		TaskList tl = game.fetchTaskList();
		Task task = tl.getHouseholdTask(taskId);
		SFSArray tasksArray = SFSArray.newInstance();
		if(task.getStatus().equals(Task.PENDING)){
			task.setDeleted(1);
			task.save();
			SFSObject taskObj = this.translateTaskToSFSObject(task);
			tasksArray.addSFSObject(taskObj);
			//Need to renumber all the tasks above this one. 
			List<Task> tasks = tl.fetchTasksToRenumber(task.getHousehold(), task.getTaskNumber());
			if(tasks!=null && tasks.size()>0){
				for(Task newerTask: tasks){
					newerTask.setTaskNumber(newerTask.getTaskNumber() - 1);
					newerTask.save();
					tasksArray.addSFSObject(this.translateTaskToSFSObject(newerTask));
				}
			}
			//I need to get the rooms for this hearth's home and farm. 
			Zone currentZone = this.getParentExtension().getParentZone();
			List<User> users = GameHelper.fetchTaskListUsers(currentZone, task.getHousehold().getId());
			SFSObject wrapperObj = SFSObject.newInstance();
			wrapperObj.putSFSArray("tasks", tasksArray);
			send("DeletedTask", wrapperObj, users);
			
			updateGMManagerTaskNumbers(task.getHousehold(), game);
		}
	}
	private void gmFetchPendingTasksCount(User user) throws Exception {
		Game game = UserHelper.fetchUserGame(user);
		
		HearthFactory hearthFactory = new HearthFactory();
		Set<Hearth> hearths = hearthFactory.fetchGameHearths(game);
		TaskList tl = game.fetchTaskList();
		SFSArray hearthArray = SFSArray.newInstance();
		for (Hearth hearth: hearths) {
			SFSObject hearthObj = SFSObject.newInstance();
			hearthObj.putInt("HearthId", hearth.getId());
			int pendingTasks = tl.countAllPendingTasks(hearth);
			hearthObj.putInt("PendingTaskCount", pendingTasks);
			hearthArray.addSFSObject(hearthObj);
		}
		SFSObject sendObject = SFSObject.newInstance();
		sendObject.putSFSArray("TaskCounts", hearthArray);
		send("gm_pending_task_count", sendObject, user);
	}
	private SFSObject translateTaskToSFSObject(Task task) throws Exception {
		SFSObject taskObj = SFSObject.newInstance();
		taskObj.putInt("Id", task.getId());
		taskObj.putInt("Hearth", task.getHousehold().getId());
		taskObj.putUtfString("Type", task.getTaskType());
		taskObj.putUtfString("TypeDisplay", task.getDisplayName());
		Integer locId = task.getLocation().getId();
		LocationFactory lf = new LocationFactory();
		Location loc = lf.fetchLocation(locId);
		if(loc!=null){
			taskObj.putInt("LocationId", loc.getId());
			taskObj.putUtfString("LocationName", loc.getName());
			taskObj.putUtfString("LocationType", loc.getType());
		} else {
			taskObj.putNull("LocationId");
			taskObj.putNull("LocationName");
			taskObj.putNull("LocationType");
		}
		if(task.getAsset() != null){
			taskObj.putInt("Asset", task.getAsset().getId());
			taskObj.putInt("AssetAmount", task.getAssetAmount());
		} else {
			taskObj.putNull("Asset");
			taskObj.putNull("AssetAmount");
		}
		AllCharsFactory acf = new AllCharsFactory();
		if(task.getActor()!= null){
			SFSObject actorObj = SFSObject.newInstance();
			AllChars actor = acf.fetchAllChar(task.getActor().getId());
			actorObj.putInt("id", actor.getId());
			if(actor.getName()!=null){
				actorObj.putUtfString("firstname", actor.getName());
			} else {
				actorObj.putNull("firstname");
			}
			
			actorObj.putUtfString("familyname", actor.getFamilyName());
			actorObj.putUtfString("role", actor.getRole().getId());
			actorObj.putInt("hearthid", actor.getHearth().getId());
			
			taskObj.putSFSObject("Actor", actorObj);
		} else {
			taskObj.putNull("Actor");
		}
		taskObj.putInt("Status", task.getStatus());
		if(task.getStatus().equals(Task.PENDING)){
			taskObj.putInt("Readonly", 0);
		} else {
			taskObj.putInt("Readonly", 1);
		}
		taskObj.putInt("Deleted", task.getDeleted());
		if(task.getNotes() != null){
			taskObj.putUtfString("Notes", task.getNotes());
		} else {
			taskObj.putNull("Notes");
		}
		taskObj.putInt("TaskNumber", task.getTaskNumber());
		taskObj.putInt("SeasonId", task.getSeason().getId());
		return taskObj;
	}
	private SFSObject translateTaskOptionToSFSObject(TaskOption to) {
		SFSObject toObj = SFSObject.newInstance();
		toObj.putInt("Value", to.getValue());
		toObj.putUtfString("Name", to.getName());
		toObj.putUtfString("Type", to.getType());
		toObj.putInt("Status", to.getStatus());
		switch (to.getStatus()){
			case TaskOption.VALID:
				toObj.putNull("Notes");
				break;
			case TaskOption.INVALID:
				toObj.putUtfString("Notes", to.getNotes());
				break;
		}
		return toObj;
	}
	private SFSObject checkHazards(SFSObject fieldObject, Field field, SeasonDetail sd) throws Exception{
		try{
			HazardFactory hazardFactory = new HazardFactory();

			FieldHazardHistory fhh = hazardFactory.fetchCurrentFieldHazard(field, sd);
			if(fhh!=null){
				CropHazardEffect effect = hazardFactory.fetchCropHazardEffect(fhh.getCropHazardEffect().getId());
				CropHazard hazard = hazardFactory.fetchCropHazard(effect.getCropHazard().getId());
				fieldObject.putUtfString("Hazard", hazard.getName());
				fieldObject.putInt("FullRed", effect.getReduction());
				fieldObject.putInt("MitigatedRed", effect.getMitigatedRed());
				//TODO: Add hazard notes. 
				fieldObject.putUtfString("HazardNotes", "More information on the problem. Try mitigating by spraying Pesticide, if you can.");
			}
		} catch (Exception e) {
			String message = "Problem checking the hazards for field " + field.getId();
			throw new Exception(message);
		}
		return fieldObject;
	}
	private SFSArray wrapPossibleTasks(TaskList taskList, Integer hearthId, Game game) throws Exception{
		SeasonList seasonList = game.fetchSeasonList();
		Season currentSeason = seasonList.getCurrentSeason();
		
		HearthFactory hf = new HearthFactory();
		Hearth hearth = hf.fetchHearth(hearthId);
		
		Set<Task> potentialTasks = taskList.getPotentialTasks(currentSeason.getId());
		SFSArray ptArray = SFSArray.newInstance(); 
		if(potentialTasks != null) {
			for (Task pt: potentialTasks){
				SFSObject task = SFSObject.newInstance();
				Set<TaskOption> actors = pt.fetchPossibleActors(hearth);
				SFSArray actorsObj = SFSArray.newInstance();
				if (actors != null) {
					for(TaskOption ac : actors){
						actorsObj.addSFSObject(this.translateTaskOptionToSFSObject(ac));
					}
					task.putSFSArray("Actors", actorsObj);
				} else {
					task.putNull("Actors");
				}
				Set<TaskOption> locations = pt.fetchPossibleLocations(hearth);
				SFSArray locationsObj = SFSArray.newInstance();
				if(locations != null){
					for(TaskOption loc: locations){
						locationsObj.addSFSObject(this.translateTaskOptionToSFSObject(loc));
					}
					task.putSFSArray("Locations", locationsObj);
				} else {
					task.putNull("Locations");
				}
				Set<TaskOption> assets = pt.fetchPossibleAssets(hearth);
				SFSArray assetsObj = SFSArray.newInstance();
				if(assets != null){
					for(TaskOption asset: assets){
						assetsObj.addSFSObject(this.translateTaskOptionToSFSObject(asset));
					}
					task.putSFSArray("Assets", assetsObj);
				} else {
					task.putNull("Assets");
				}
				task.putUtfString("DisplayName", pt.getDisplayName());
				task.putUtfString("Type", pt.getTaskType());
				ptArray.addSFSObject(task);
			}
		}
		return ptArray;
	}
	private void updateGMManagerTaskNumbers(Hearth household, Game game) {
		TaskList tl = game.fetchTaskList();
		User bankerUser = null;
		try {
			bankerUser = GameHelper.fetchBankerFromHome(getApi(), game);
		} catch (Exception e){
			Logger.Log("FarmMultiHandler.updateGMManagerTaskNumbers", "Problem fetching banker for game " + game.getGameName() + ": " + e.getMessage());
			return;
		}
		try {
			Integer pendingTaskCount = tl.countAllPendingTasks(household);
			SFSObject sendObject = SFSObject.newInstance();
			sendObject.putInt("HearthId", household.getId());
			sendObject.putInt("PendingTaskCount", pendingTaskCount);
			send("gm_pending_tasks_updated", sendObject, bankerUser);
		} catch (Exception e) {
			Logger.ErrorLog("FarmMultiHandler.updateGMManagerTaskNumbers", "Unable to count pending tasks for hearth " + household.getId() + ": " + e.getMessage());
		}
		
	}
}
