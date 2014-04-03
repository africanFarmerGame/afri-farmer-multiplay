package uk.ac.sussex.model.game;

import uk.ac.sussex.model.grading.CoreGameCriteria;
import uk.ac.sussex.model.seasons.CoreSeasonList;
import uk.ac.sussex.model.seasons.CoreWeatherList;
import uk.ac.sussex.model.tasks.CoreTaskList;
import uk.ac.sussex.model.village.CoreVillage;

public class CoreGame extends Game {
	public static String TYPE = "CORE-GAME";
	public static String TYPE_DISPLAY = "Core";
	
	public CoreGame() {
		super();
		this.setGameType(TYPE);
		this.setGameTypeDisplay(TYPE_DISPLAY);
		this.setVillageType(new CoreVillage());
		this.setGameCriteria(new CoreGameCriteria());
	}
	@Override 
	protected void setSeasonList(){
		super.setSeasonList(new CoreSeasonList(this));
	}
	@Override 
	protected void setTaskList(){
		super.setTaskList(new CoreTaskList(this));
	}
	@Override 
	protected void setWeatherList(){
		super.setWeatherList(new CoreWeatherList(this));
	}
}
