/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.seasons;

import java.util.Iterator;
import java.util.List;

import uk.ac.sussex.model.SeasonDetail;
import uk.ac.sussex.model.game.Game;

public abstract class WeatherList {
	private Game game;
	
	public WeatherList(Game game){
		this.game = game;
		this.setupPotentialWeather();
	}
	public abstract void setupPotentialWeather();
	protected void addSeasonalWeather(SeasonWeather sw, String seasonName){
		SeasonList sl = game.fetchSeasonList();
		sl.addSeasonalWeather(sw, seasonName);
	}
	public List<SeasonWeather> fetchCurrentSeasonWeathers(){
		SeasonList seasonList = game.fetchSeasonList();
		Season currentSeason = seasonList.getCurrentSeason();
		List<SeasonWeather> seasonalWeather = currentSeason.fetchSeasonWeather();
		return seasonalWeather;
	}
	public SeasonalWeatherCropEffect fetchSeasonalWeatherCropEffect(SeasonDetail sd, Integer cropId, Integer cropPlanting) {
		String weatherId = sd.getWeather();
		if(weatherId == null){
			return null;
		}
		//Start by getting the season weathers,
		SeasonList seasonList = game.fetchSeasonList();
		List<SeasonWeather> seasonWeather = seasonList.fetchSeasonalWeather(sd.getSeason());
		//Then finding the season weather that is appropriate. 
		Boolean foundWeather = false;
		Iterator<SeasonWeather> iterator = seasonWeather.iterator();
		SeasonWeather currentWeather = null;
		String soughtWeather = sd.getWeather();
		while(iterator.hasNext() && !foundWeather){
			currentWeather = iterator.next();
			if(currentWeather.getWeather().getId().equals(soughtWeather)){
				foundWeather = true;
			}
		}
		//Then get the cropId
		return currentWeather.fetchCropEffect(cropId, cropPlanting);
	}
}
