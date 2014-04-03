/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
