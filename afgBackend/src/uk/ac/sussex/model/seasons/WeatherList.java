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
