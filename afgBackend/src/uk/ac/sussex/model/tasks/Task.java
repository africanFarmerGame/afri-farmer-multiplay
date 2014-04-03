/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.tasks;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;
import uk.ac.sussex.utilities.Logger;

public abstract class Task extends BaseObject {
	private String taskType;
	private Integer id;
	private SeasonDetail season;
	private Hearth household;
	private Location location;
	private AllChars actor;
	private Integer status = 0;
	private Asset asset;
	private Integer assetAmount;
	private String notes;
	private Integer deleted = 0;
	private Integer taskNumber;
	
	public static Integer PENDING = 0;
	public static Integer COMPLETED = 1;
	public static Integer ERROR = -1;
		
	public Task() {
		this.addOptionalParam("Id"); // Gets set on save.
		this.addOptionalParam("Notes");
	}
	/**
	 * @return the id
	 */
	public Integer getId() {
		return id;
	}
	/**
	 * @param id the id to set
	 */
	public void setId(Integer id) {
		this.id = id;
	}
	/**
	 * @return the season
	 */
	public SeasonDetail getSeason() {
		return season;
	}
	/**
	 * @param season the season to set
	 */
	public void setSeason(SeasonDetail season) {
		this.season = season;
	}
	/**
	 * @return the household
	 */
	public Hearth getHousehold() {
		return household;
	}
	/**
	 * @param household the household to set
	 */
	public void setHousehold(Hearth household) {
		this.household = household;
	}
	/**
	 * @return the location
	 */
	public Location getLocation() {
		return location;
	}
	/**
	 * @param location the location to set
	 */
	public void setLocation(Location location) {
		this.location = location;
	}
	public String getTaskType(){
		return taskType;
	}
	protected void setTaskType(String newTaskType){
		taskType = newTaskType;
	}
	
	/**
	 * @return the actor
	 */
	public AllChars getActor() {
		return actor;
	}
	/**
	 * @param actor the actor to set
	 */
	public void setActor(AllChars actor) {
		this.actor = actor;
	}
	/**
	 * @return the status
	 */
	public Integer getStatus() {
		return status;
	}
	/**
	 * @param status the status to set
	 */
	public void setStatus(Integer status) {
		this.status = status;
	}
	/**
	 * @return the asset
	 */
	public Asset getAsset() {
		return asset;
	}
	/**
	 * @param asset the asset to set
	 */
	public void setAsset(Asset asset) {
		this.asset = asset;
	}
	/**
	 * @return the assetAmount
	 */
	public Integer getAssetAmount() {
		return assetAmount;
	}
	/**
	 * @param assetAmount the assetAmount to set
	 */
	public void setAssetAmount(Integer assetAmount) {
		this.assetAmount = assetAmount;
	}
	/**
	 * @return the notes
	 */
	public String getNotes() {
		return notes;
	}
	/**
	 * @param notes the notes to set
	 */
	public void setNotes(String notes) {
		this.notes = notes;
	}
	/**
	 * @return the deleted
	 */
	public Integer getDeleted() {
		return deleted;
	}
	/**
	 * @param deleted the deleted to set
	 */
	public void setDeleted(Integer deleted) {
		this.deleted = deleted;
	}
	public void setTaskNumber(Integer taskNumber) {
		this.taskNumber = taskNumber;
	}
	public Integer getTaskNumber() {
		return taskNumber;
	}
	protected TaskList fetchHouseholdTasklist(Hearth household){
		GameFactory gf = new GameFactory();
		try {
			Game game = gf.fetchGame(household.getGame().getId());
			TaskList tl = game.fetchTaskList();
			return tl;
		} catch (Exception e) {
			String errorMessage = "Problem retrieving tasklist for hearth " + household.getId() + ": "+ e.getMessage();
			Logger.ErrorLog("TaskBabysit.fetchHouseholdTasklist", errorMessage);
			return null;
		}
	}
	public abstract String getDisplayName();
	public abstract void execute();
	public abstract Set<TaskOption> fetchPossibleLocations(Hearth household);
	public abstract Set<TaskOption> fetchPossibleActors(Hearth household);
	public abstract Set<TaskOption> fetchPossibleAssets(Hearth household);
	
	protected Set<TaskOption> fetchAdultOptions(Hearth household){
		NPCFactory npcf = new NPCFactory();
		Set<TaskOption> possibleActors;
		TaskList tl = fetchHouseholdTasklist(household);
		
		try {
			Set<PlayerChar> playerChars = household.getCharacters();
			possibleActors = new HashSet<TaskOption>();
			
			for (PlayerChar pc: playerChars){
				if(!pc.getAlive().equals(AllChars.DEAD)){
					TaskOption to = new TaskOption();
					to.setName(pc.getName() + " " + pc.getFamilyName());
					to.setValue(pc.getId());
					to.setType(pc.getRole().getId());
					
					if(pc.getAlive().equals(AllChars.ILL)){
						to.setStatus(TaskOption.INVALID);
						to.setNotes("This person is too ill to work.");
					} else {
						if(tl != null){
							//Check well enough to work. 
						
							Integer pendingTasks = tl.countPendingActorTasks(household, pc);
							if(pendingTasks < 2){
								to.setStatus(TaskOption.VALID);	
							} else {
								to.setStatus(TaskOption.INVALID);
								to.setNotes("This person is already working to capacity this season!");
							}
						} else {
							to.setStatus(TaskOption.WARNING);
							to.setNotes("An error meant I couldn't tell how much work this person is doing this season.");
						}
					}
					
					possibleActors.add(to);
				}
			}
			
		} catch (Exception e) {
			String errormessage = "Problem fetching the pcs: " + e.getMessage();
			Logger.ErrorLog("Task.fetchAdultOptions hearth " + household.getId(), errormessage);
			return null;
		}
		try {
			Set<NPC> npcs = npcf.fetchHearthChildren(household);
			for (NPC npc : npcs){
				if ((npc.isAdult())&&(!npc.getAlive().equals(AllChars.DEAD))){
					TaskOption to = new TaskOption();
					to.setName(npc.getName() + " " + npc.getFamilyName());
					to.setValue(npc.getId());
					to.setType(npc.getRole().getId());
					if(npc.getAlive().equals(AllChars.ILL)){
						to.setStatus(TaskOption.INVALID);
						to.setNotes("This person is too ill to work.");
					} else {
						if(tl != null){
							Integer pendingTasks = tl.countPendingActorTasks(household, npc);
							if(pendingTasks < 2){
								to.setStatus(TaskOption.VALID);	
							} else {
								to.setStatus(TaskOption.INVALID);
								to.setNotes("This person is already working to capacity this season!");
							}
						} else {
							to.setStatus(TaskOption.WARNING);
							to.setNotes("An error meant I couldn't tell how much work this person is doing this season.");
						}
					}
					possibleActors.add(to);
				}
			}
		} catch (Exception e) {
			String errormessage = "Problem fetching the npcs: " + e.getMessage();
			Logger.ErrorLog("Task.fetchAdultOptions hearth " + household.getId(), errormessage);
		}
		return possibleActors; 
	}
	protected Set<TaskOption> fetchChildrenOptions(Hearth household){
		//This is used for household tasks.
		NPCFactory npcf = new NPCFactory();
		Set<TaskOption> possibleActors = new HashSet<TaskOption>();
		TaskList tl = fetchHouseholdTasklist(household);
		try {
			Set<NPC> npcs = npcf.fetchHearthChildren(household);
			for (NPC npc : npcs){
				if((!npc.isAdult())&&(!npc.getAlive().equals(AllChars.DEAD))){
					TaskOption to = new TaskOption();
					to.setName(npc.getName() + " " + npc.getFamilyName());
					to.setValue(npc.getId());
					to.setType(npc.getRole().getId());
					if(npc.getAlive().equals(AllChars.ILL)){
						to.setStatus(TaskOption.INVALID);
						to.setNotes("This person is too ill to work.");
					} else {
						if(tl != null){
							Integer pendingTasks = tl.countPendingActorTasks(household, npc);
							if(pendingTasks < 1){
								to.setStatus(TaskOption.VALID);
							} else {
								to.setStatus(TaskOption.INVALID);
								to.setNotes("This person is already working to capacity this season!");
							}
						} else {
							to.setStatus(TaskOption.INVALID);
							to.setNotes("An error meant I couldn't tell how much work this person is doing this season.");
						}
					}
					possibleActors.add(to);
				}
			}
		} catch (Exception e) {
			String errormessage = "Problem fetching the npcs: " + e.getMessage();
			Logger.ErrorLog("Task.fetchChildrenOptions hearth " + household.getId(), errormessage);
			return null;
		}
		return possibleActors; 
	}
	protected Set<TaskOption> fetchExternalAdultFarmWorkers(Hearth household){
		Set<TaskOption> possibleActors = new HashSet<TaskOption>();
		//Need to find actors with a pending TaskFarmElsewhere task with the location as this hearth.
		TaskList tl = fetchHouseholdTasklist(household);
		List<Task> pendingTasks = null;
		try {
			pendingTasks = tl.fetchCurrentExternalTasks(household, TaskFarmElsewhere.TASKTYPE);
		} catch (Exception e) {
			String message = "Problem fetching pending tasks: " + e.getMessage();
			Logger.ErrorLog("Task.fetchExternalAdultFarmWorkers", message);
			return null;
		}
		AllCharsFactory acf = new AllCharsFactory();
		for (Task pending: pendingTasks){
			//TODO need to do something more with this to get the detail. 
			TaskOption to = new TaskOption();
			Integer actorId = pending.getActor().getId();
			if(actorId != null){
				try {
					AllChars actor = acf.fetchAllChar(actorId);
					Integer actorPending = tl.countPendingActorTasks(household, actor);
					to.setValue(actorId);
					to.setName(actor.getName() + " " + actor.getFamilyName());
					to.setType(actor.getRole().getId());
					if(actorPending >= 1){
						to.setStatus(TaskOption.INVALID);
						to.setNotes("You have already assigned this person to a task.");
					} else {
						to.setStatus(TaskOption.VALID);
					}
					possibleActors.add(to);
				} catch (Exception e) {
					Logger.ErrorLog("Task.fetchExternalAdultFarmWorkers", "Problem getting actor data for id " + actorId + ": " + e.getMessage());
				}
			}
		}
		//This could also screw up the task count. 
		return possibleActors;
	}
	protected Boolean confirmActorAvailability(Task task, String taskElsewhereType) throws Exception{
		//There's two things to check: 
		//Start by checking whether the task household is the same as the actor's household. 
		Integer taskHouseholdId = task.getHousehold().getId();
		HearthFactory hf = new HearthFactory();
		Hearth taskHousehold;
		try {
			taskHousehold = hf.fetchHearth(taskHouseholdId);
		} catch (Exception e1) {
			Logger.ErrorLog("Task.confirmActorAvailability", "Unable to get the household: " + e1.getMessage());
			throw e1;
		}
		TaskList tl = fetchHouseholdTasklist(taskHousehold);
		Integer actorId = task.getActor().getId();
		AllCharsFactory acf = new AllCharsFactory();
		AllChars actor = acf.fetchAllChar(actorId);
		Integer actorHouseholdId = actor.getHearth().getId();
		Integer maxTasksAllowed = 0;
		if(!taskHouseholdId.equals(actorHouseholdId)){
			//Is there a valid task....Elsewhere for them?
			List<Task> actorTasks = new ArrayList<Task>();
			
			//(Valid means this season, and that person won't have completed too many tasks in their own household.)
			try {
				List<Task> externalTasks = tl.fetchCurrentExternalTasks(taskHousehold, taskElsewhereType);
				for(Task nextTask : externalTasks){
					if(nextTask.getActor().getId().equals(actorId)){
						actorTasks.add(nextTask);
					}
				}
			} catch (Exception e) {
				Logger.ErrorLog("Task.confirmActorAvailability", "Unable to fetch external tasks: " + e.getMessage()); 
				throw e;
			}
			//If there is, loop through this again.
			if(actorTasks != null){
				for(Task actorTask: actorTasks){
					Boolean taskElsewhereOk = this.confirmActorAvailability(actorTask, null);
					if(taskElsewhereOk){
						maxTasksAllowed ++;
					}
				}
			}
		} else {
			if(actor.getAlive().equals(AllChars.ALIVE)){
				if(actor.isAdult()){
					maxTasksAllowed = 2;
				}else {
					maxTasksAllowed = 1;
				}
			} else {
				//If they are ill or dead they can't work. 
				maxTasksAllowed = 0;
			}
		}
		//Need a list of tasks, ordered by tasknumber, for the household concerned, and a task to match against.
		List<Task> householdTasks = tl.getCurrentHouseholdTasks(taskHousehold);
		Iterator<Task> householdTasksIt = householdTasks.iterator();
		Boolean foundTask = false;
		Integer taskId = task.getId();
		Integer taskCount = 0;
		while(householdTasksIt.hasNext() && !foundTask){
			Task householdTask = householdTasksIt.next();
			if(householdTask.getDeleted().equals(0)){
				Integer householdTaskId = householdTask.getId();
				if(householdTaskId.equals(taskId)){
					foundTask = true;
				} else {
					if(householdTask.getActor()!=null && householdTask.getActor().getId().equals(actorId)){
						taskCount ++;
					}
				}
			}
		}
		return (taskCount < maxTasksAllowed);
	}
	protected Boolean haveSprayKit(Hearth household, AssetFactory af, AssetOwnerFactory aof){
		AssetOwner spraykitOwner = null;
		try{
			Asset spraykit = af.fetchAsset("Spray kit");
			spraykitOwner = aof.fetchSpecificAsset(household, spraykit);
		} catch (Exception e) {
			String message = "Problem getting spray kit for household " + household.getId().toString() + ": " + e.getMessage();
			Logger.ErrorLog("TaskFertiliser.fetchPossibleAssets", message);
		}
		Boolean haveSprayKit = ((spraykitOwner!=null)&&(spraykitOwner.getAmount()>0));
		return haveSprayKit;
	}
}
