package uk.ac.sussex.model.tasks;

import java.util.HashSet;
import java.util.Set;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;
import uk.ac.sussex.utilities.Logger;

public class TaskFarmElsewhere extends Task {
	public static String TASKTYPE =  "TASK_FARM_ELSEWHERE";
	public static String DISPLAYNAME = "Farm For Someone Else";
	public TaskFarmElsewhere(){
		super();
		this.setTaskType(TASKTYPE);
		this.addOptionalParam("Asset");
		this.addOptionalParam("AssetAmount");
	}
	@Override
	public String getDisplayName() {
		return DISPLAYNAME;
	}

	@Override
	public void execute() {
		Boolean actorAvailable = false;
		try {
			actorAvailable = confirmActorAvailability(this, null);
		} catch (Exception e) {
			this.setStatus(ERROR);
			this.setNotes("There was a problem confirming the availability of the person doing this task.");
			Logger.ErrorLog("TaskFarmElsewhere", "Problem confirming actor availability: " + e.getMessage());
		} 
		if(actorAvailable){
			this.setStatus(COMPLETED);
			this.setNotes("The person you allocated to help farm elsewhere successfully turned up to work.");
		} else {
			this.setStatus(ERROR);
			this.setNotes("The person allocated to this task already had too many other tasks to do.");
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
		//Need to fetch a list of all the hearths in the same game, then discard this one. 
		GameFactory gf = new GameFactory();
		Game hearthGame;
		Integer gameId = household.getGame().getId();
		try {
			hearthGame = gf.fetchGame(gameId);
		} catch (Exception e) {
			String message = "Problem fetching game " + gameId + ": " + e.getMessage();
			Logger.ErrorLog("TaskFarmElsewhere.fetchPossibleLocations", message);
			return null;
		}
		HearthFactory hf = new HearthFactory();
		Set<Hearth> households;
		try {
			households = hf.fetchGameHearths(hearthGame);
		} catch (Exception e) {
			String message = "Problem fetching hearths: " + e.getMessage();
			Logger.ErrorLog("TaskFarmElsewhere.fetchPossibleLocations", message);
			return null;
		}
		Integer myHearthId = household.getId();
		Set<TaskOption> locations = new HashSet<TaskOption>();
		for (Hearth hearth: households){
			if(hearth.getId()!=myHearthId){
				TaskOption to = new TaskOption();
				to.setValue(hearth.getId());
				to.setName(hearth.getName());
				to.setType(hearth.getType());
				to.setStatus(TaskOption.VALID);
				locations.add(to);
			}
		}
		return locations;
	}

	@Override
	public Set<TaskOption> fetchPossibleActors(Hearth household) {
		//Only adults from this household are eligible. 
		Set<TaskOption> actors = this.fetchAdultOptions(household);
		return actors;
	}

	@Override
	public Set<TaskOption> fetchPossibleAssets(Hearth household) {
		// None required.
		return null;
	}

}
