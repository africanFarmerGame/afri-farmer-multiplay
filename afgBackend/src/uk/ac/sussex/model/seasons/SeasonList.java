/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.seasons;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import uk.ac.sussex.utilities.Logger;

import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.HearthFactory;
import uk.ac.sussex.model.SeasonDetail;
import uk.ac.sussex.model.SeasonDetailFactory;
import uk.ac.sussex.model.SeasonHearthAssetFactory;
import uk.ac.sussex.model.SeasonHearthStatusFactory;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.gameStage.GameStage;
import uk.ac.sussex.model.tasks.Task;

public abstract class SeasonList {
	protected Set<Season> seasonList = new HashSet<Season>();
	private Season firstSeason;
	private Season endSeason;
	private Season currentSeason = null;
	private GameStage currentStage = null;
	protected Game game = null;
	
	public SeasonList(Game game) {
		this.setGame(game);
		this.setupSeasons();
		//Check to see if the game has a season detail, and if so set the current Season and Stage.
		this.readSeasonDetail();
	}
	
	protected abstract void setupSeasons();
	
	public Set<Season> fetchDisplayList() {
		Set<Season> displayList = new HashSet<Season>();
		for(Season season: seasonList){
			if(season.getDisplayOrder() > 0){
				displayList.add(season);
			}
		}
		return displayList;
	}
	
	protected void addSeason(Season season){
		if(seasonList.size() == 0){
			firstSeason = season;
		}
		seasonList.add(season);
	}
	protected void setEndSeason(Season season){
		//I think this should be away from the list. 
		endSeason = season;
	}
	public void changeGameStage() throws Exception {
		if(currentSeason==null){
			currentSeason = firstSeason;
		}
		GameStage newStage = null;
		while(newStage == null){
			newStage = currentSeason.changeStage();
			if(newStage==null){
				//Ok, best wrap up the season then. 
				this.endOfSeason();
				currentSeason = currentSeason.getNextSeason(); 
			}
		}
		currentStage = newStage;
	}
	public void endGame() throws Exception {
		//Need to wrap up the current stage. 
		if(currentSeason!=null) {
			currentSeason.changeStage();
			this.endOfSeason();
		}
		currentStage = null;
		currentSeason = endSeason;
		currentStage = currentSeason.changeStage();
	}
	public void firePreStageEvents() throws Exception {
		if(currentStage!=null){
			try{
				currentStage.firePreStageEvents();
			} catch (Exception e) {
				String message = e.getMessage();
				Logger.ErrorLog("SeasonList.firePreStageEvents", "Problem with pre-stage events: " + message);
			}
			try {
				currentStage.generatePreStageNotifications();
			} catch (Exception e) {
				String message = e.getMessage();
				Logger.ErrorLog("SeasonList.firePreStageEvents", "Problems with the pre-stage notifications" + message);
			}
		}
	}
	public Season getCurrentSeason() {
		return currentSeason;
	}
	public GameStage getCurrentStage(){
		return currentStage;
	}
	public GameStage fetchNextStage(){
		GameStage nextStage = currentSeason.fetchNextStage();
		if(nextStage == null){
			Season nextSeason = currentSeason.getNextSeason();
			if(nextSeason!=null){
				nextStage = nextSeason.fetchNextStage();
			}
		}
		return nextStage;
	}
	public Season fetchNextSeason(){
		GameStage nextStage = currentSeason.fetchNextStage();
		if(nextStage!=null){
			return currentSeason;
		} else {
			return currentSeason.getNextSeason();
		}
	}
	public void setGame(Game game){
		this.game = game;
	}
	public Season fetchFirstSeason() {
		return firstSeason;
	}
	public void addTaskToSeason(Task newTask, String seasonId) {
		for (Season season : seasonList){
			if(seasonId == season.getId()){
				season.addPossibleTask(newTask);
				break;
			}
		}
	}
	public Set<Task> fetchSeasonalTasks(String seasonId) {
		 for (Season season : seasonList) {
			 if(seasonId == season.getId()){
				 return season.getPossibleTasks();
			 }
		 }
		 return null;
	}
	public List<SeasonWeather> fetchSeasonalWeather(String seasonId) {
		Season season = null;
		try {
			season = fetchSeason(seasonId);
		} catch (Exception e) {
			//What do we want to do about that? Log and continue?
			String message = "Problem fetching season: " + e.getMessage();
			Logger.ErrorLog("SeasonList.fetchSeasonalWeather", message);
		}
		if(season!= null){
			return season.fetchSeasonWeather();
		} else {
			return null;
		}
	}
	public void addSeasonalWeather(SeasonWeather sw, String seasonId) {
		Season season = null;
		try {
			season = fetchSeason(seasonId);
		} catch (Exception e) {
			String message = "We have tried to fetch season " + seasonId + ".";
			Logger.ErrorLog("SeasonList.addSeasonalWeather", message);
		}
		if(season!=null){
			season.addSeasonalWeather(sw);
		}
	}
	public Integer fetchSeasonDisplayPos(String seasonId){
		Integer display = 0;
		Season season = null;
		try {
			season = this.fetchSeason(seasonId);
		} catch (Exception e) {
			Logger.ErrorLog("SeasonList.fetchSeasonDisplayPos", "Problem fetching season " + seasonId + ": " + e.getMessage());
		}
		if(season!=null){
			display = season.getDisplayOrder();
		}
		return display;
	}
	private void readSeasonDetail(){
		
		//Check we've got it all (not lazy initialised only).
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		Season currentSeason = null;
		GameStage currentStage = null;
		try{
			SeasonDetail sd = sdf.fetchCurrentSeasonDetail(game);
			currentSeason = fetchSeason(sd.getSeason());
			currentStage = currentSeason.fetchStage(sd.getGameStage());
		} catch (Exception e) {
			//I think we can just leave it as null without too much danger, but an error log would be a good plan.
			Logger.ErrorLog("SeasonList.readSeasonDetail", "Error reading seasons: " + e.getMessage());
		}
		this.currentSeason = currentSeason;
		this.currentStage = currentStage;
		if (currentStage != null) {
			this.currentSeason.setCurrentStage(this.currentStage);
		}
		//TODO: This needs to be improved on - this should be asking the season for the current stage, not the other way around.
	}
	private Season fetchSeason(String seasonId) throws Exception{
		for (Season season : seasonList){
			if(season.getId().equals(seasonId)){
				return season;
			}
		}
		//We should never get here. 
		throw new Exception("No season found with the name " + seasonId);
	}
	private void endOfSeason() throws Exception {
		//Need to store some details about all the hearths. 
		HearthFactory hf = new HearthFactory();
		Set<Hearth> hearths = hf.fetchGameHearths(game);
		
		SeasonHearthStatusFactory shsf = new SeasonHearthStatusFactory();
		SeasonHearthAssetFactory shaf = new SeasonHearthAssetFactory();
		SeasonDetail currentSeason = game.getCurrentSeasonDetail();
		
		for(Hearth hearth: hearths){
			shsf.generateSeasonHearthStatus(hearth, currentSeason);
			shaf.generateSeasonHearthAssets(hearth, currentSeason);
		}
	}
}
