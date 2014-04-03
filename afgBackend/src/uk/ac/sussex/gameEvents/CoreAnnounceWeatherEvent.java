/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.gameEvents;

import java.util.Iterator;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.seasons.*;
import uk.ac.sussex.utilities.Logger;

public class CoreAnnounceWeatherEvent extends GameEvent {

	public CoreAnnounceWeatherEvent(Game game) {
		super(game);
	}

	@Override
	public void fireEvent() throws Exception {
		SeasonWeather chosenSeasonalWeather = null;
		try {
			//Need to start by generating the weather for the season.
			WeatherList weatherList = game.fetchWeatherList();
			List<SeasonWeather> seasonalWeather = weatherList.fetchCurrentSeasonWeathers();
			Double weatherGenerator = Math.random();
			
			Double maxProbability = 0.0;
			Double minProbability = 0.0;
			Boolean chosen = false;
			
			Iterator<SeasonWeather> weatherIterator = seasonalWeather.iterator();
			
			while(weatherIterator.hasNext() && chosen==false){
				chosenSeasonalWeather = weatherIterator.next();
				maxProbability = minProbability + chosenSeasonalWeather.getProbability();
				chosen = ((maxProbability > weatherGenerator) && (minProbability <= weatherGenerator));
				minProbability = maxProbability;
			}
			
			SeasonDetailFactory sdf = new SeasonDetailFactory();
			SeasonDetail sd = sdf.fetchCurrentSeasonDetail(game);
			sd.setWeather(chosenSeasonalWeather.getWeather().getId());
			sd.save();
		} catch (Exception e){
			String message = "Problem generating the weather - " + e.getMessage();
			Logger.ErrorLog("CoreAnnounceWeatherEvent.fireEvent", message);
			throw new Exception (message);
		}
		try {
			//Now I need to set the crop health reductions for any field with a crop.
			HearthFactory hf = new HearthFactory();
			Set<Hearth> hearths = hf.fetchGameHearths(game);
			
			FieldFactory ff = new FieldFactory();
			for(Hearth hearth :hearths) {
				List<Field> fields = ff.getHearthFields(hearth);
				for(Field field: fields){
					Asset crop = field.getCrop();
					if(crop!=null){
						SeasonalWeatherCropEffect cropEffect = chosenSeasonalWeather.fetchCropEffect(crop.getId(), field.getCropPlanting());
						Integer cropHealth = field.getCropHealth();
						cropHealth = cropHealth - cropEffect.getYieldReduction();
						field.setCropHealth(cropHealth);
						field.save();
					}
				}
			}
			
		} catch (Exception e) {
			String message = "Problem updating the crop health - " + e.getMessage();
			Logger.ErrorLog("CoreAnnounceWeatherEvent.fireEvent", message);
			throw new Exception(message);
		}
	}

	@Override
	public void generateNotifications() throws Exception {
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		SeasonDetail sd = sdf.fetchCurrentSeasonDetail(game);
		
		String notification = "Weather Announcement: \n";
		notification += "The weather has been " + sd.getWeather() + " \n";
		notification += "Note that poor weather may affect your crop health.\n";
		
		SeasonNotificationFactory snf = new SeasonNotificationFactory();
		snf.updateSeasonNotifications(notification, game);
	}

}
