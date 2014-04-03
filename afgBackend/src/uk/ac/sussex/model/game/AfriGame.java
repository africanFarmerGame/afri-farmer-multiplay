package uk.ac.sussex.model.game;

import uk.ac.sussex.model.grading.AfriGameCriteria;
import uk.ac.sussex.model.seasons.AfriSeasonList;
import uk.ac.sussex.model.seasons.CoreWeatherList;
import uk.ac.sussex.model.tasks.CoreTaskList;
import uk.ac.sussex.model.village.CoreVillage;

public class AfriGame extends Game {
	public static String TYPE = "AFRI-GAME";
	public static String TYPE_DISPLAY = "Afri"; //TODO think of a better name!
	
	public AfriGame() {
		super();
		this.setGameType(TYPE);
		this.setGameTypeDisplay(TYPE_DISPLAY);
		this.setVillageType(new CoreVillage());
		this.setGameCriteria(new AfriGameCriteria());
	}
	@Override 
	protected void setSeasonList(){
		super.setSeasonList(new AfriSeasonList(this));
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
