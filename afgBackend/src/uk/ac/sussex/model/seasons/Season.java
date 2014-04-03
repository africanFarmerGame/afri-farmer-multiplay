/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.seasons;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.ListIterator;
import java.util.Set;

import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.gameStage.GameStage;
import uk.ac.sussex.model.tasks.Task;
import uk.ac.sussex.utilities.Logger;

public abstract class Season {
	protected String id;
	protected String name;
	private Integer displayOrder;
	private Season nextSeason;
	private List<GameStage> stages = new ArrayList<GameStage>();
	private GameStage currentStage = null;
	protected Game game = null;
	private Set<Task> seasonalTasks;
	private List<SeasonWeather> seasonalWeather;
	
	public Season(Game game, String seasonId){
		this.game = game;
		this.id = seasonId;
	}
	public String getId() {
		return this.id;
	}
	public String getName() {
		return name;
	}
	public Integer getDisplayOrder() {
		return this.displayOrder;
	}
	public void setGame(Game game){
		this.game = game;
	}
	public void setDisplayOrder(Integer displayOrder) {
		this.displayOrder = displayOrder;
	}
	public Season getNextSeason() {
		return nextSeason;
	}
	public void setNextSeason(Season nextSeason) {
		this.nextSeason = nextSeason;
	}
	public void setCurrentStage(GameStage newStage){
		this.currentStage = newStage;
	}
	public void addStage(GameStage stage){
		this.stages.add(stage);
	}
	public List<GameStage> getStages(){
		return stages;
	}
	public GameStage fetchStage(String stageName) throws Exception{
		for(GameStage stage : stages){
			if(stage.getName().equals(stageName)){
				return stage;
			}
		}
		throw new Exception ("No GameStage found with name " + stageName);
	}
	public GameStage changeStage() throws Exception {
		if(currentStage != null){
			try{
				currentStage.firePostStageEvents();
			} catch (Exception e){
				String message = e.getMessage();
				Logger.ErrorLog("Season.changeStage", "Problem changing stage: " + message);
			}
			try {
				currentStage.generatePostStageNotifications();
			} catch (Exception e) {
				String message = e.getMessage();
				Logger.ErrorLog("Season.changeStage", "Problem generating notifications: " + message);
			}
		} 
		currentStage = fetchNextStage();
		return currentStage;
	}
	public GameStage fetchNextStage() {
		Integer listPos = 0;
		if(currentStage != null){
			listPos = stages.indexOf(currentStage) + 1;
		}
		ListIterator<GameStage> li = stages.listIterator(listPos);
		GameStage nextStage = null;
		if(li.hasNext()){
			nextStage = li.next();
			//currentStage.firePreStageEvents(); //This needs to happen after the season detail has been created and so on.
		} 
		return nextStage;
	}
	public void addPossibleTask(Task newTask) {
		if(this.seasonalTasks==null){
			 this.seasonalTasks = new HashSet<Task>();
		}
		this.seasonalTasks.add(newTask);
	}
	public Set<Task> getPossibleTasks() {
		return this.seasonalTasks;
	}
	public void addSeasonalWeather(SeasonWeather sw) {
		if(this.seasonalWeather==null){
			this.seasonalWeather = new ArrayList<SeasonWeather>();
		}
		this.seasonalWeather.add(sw);
	}
	public List<SeasonWeather> fetchSeasonWeather() {
		return this.seasonalWeather;
	}
}
