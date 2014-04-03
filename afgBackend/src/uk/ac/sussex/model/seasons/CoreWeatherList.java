/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.seasons;

import java.util.Iterator;
import java.util.Set;

import uk.ac.sussex.model.AssetCrop;
import uk.ac.sussex.model.AssetFactory;
import uk.ac.sussex.model.Field;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.utilities.Logger;

public class CoreWeatherList extends WeatherList {

	public CoreWeatherList(Game game) {
		super(game);
	}

	@Override
	public void setupPotentialWeather() {
		Weather storms = new Weather("STORMS", "Storms");
		Weather rains = new Weather("RAINS", "Rain");
		Weather poorRains = new Weather("POOR_RAINS", "Poor Rain");
		Weather noRains = new Weather("NO_RAINS", "No Rain");
		Weather fine = new Weather("FINE", "Fine");
	
		SeasonWeather earlyRainsRains = new SeasonWeather(rains, (float) 0.7);
		SeasonWeather earlyRainsPoorRains = new SeasonWeather(poorRains, (float) 0.2);
		SeasonWeather earlyRainsNoRains = new SeasonWeather(noRains, (float) 0.1);
		
		SeasonWeather lateRainsRains = new SeasonWeather(rains, (float)0.7);
		SeasonWeather lateRainsPoorRains = new SeasonWeather(poorRains, (float)0.2);
		SeasonWeather lateRainsNoRains = new SeasonWeather(noRains, (float)0.1);
		
		SeasonWeather earlyHarvestFine = new SeasonWeather(fine,(float)0.7);
		SeasonWeather earlyHarvestPoorRains = new SeasonWeather(poorRains, (float)0.2);
		SeasonWeather earlyHarvestStorms = new SeasonWeather(storms, (float)0.1);
		
		SeasonWeather lateHarvestFine = new SeasonWeather(fine,(float)0.7);
		SeasonWeather lateHarvestPoorRains = new SeasonWeather(poorRains, (float)0.2);
		SeasonWeather lateHarvestStorms = new SeasonWeather(storms, (float)0.1);
		
		AssetFactory af = new AssetFactory();
		Set<AssetCrop> crops = null;
		try {
			crops = af.fetchCropAssets();
		} catch (Exception e) {
			String message = "There's been a problem fetching the crops: " + e.getMessage();
			Logger.ErrorLog("CoreWeatherList.setupPotentialWeather", message);
		}
		if(crops!=null){
			Iterator<AssetCrop> iterator = crops.iterator();
			while (iterator.hasNext()){
				AssetCrop crop = iterator.next();
				switch (crop.getId()){
				case 2: // Maize
					//Early rains
					earlyRainsRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 0));
					earlyRainsPoorRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 15));
					earlyRainsNoRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 25));
					//late rains
					lateRainsRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 0));
					lateRainsPoorRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 15));
					lateRainsNoRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 25));
					lateRainsRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 0));
					lateRainsPoorRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 15));
					lateRainsNoRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 25));
					//Early harvest
					earlyHarvestFine.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 0));
					earlyHarvestPoorRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 15));
					earlyHarvestStorms.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 25));
					earlyHarvestFine.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 0));
					earlyHarvestPoorRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 15));
					earlyHarvestStorms.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 25));
					//Late harvest
					lateHarvestFine.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 0));
					lateHarvestPoorRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 15));
					lateHarvestStorms.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 25));
					break;
				case 3: // High Yield Maize
					//Early rains
					earlyRainsRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 0));
					earlyRainsPoorRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 15));
					earlyRainsNoRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 27));
					//Late rains
					lateRainsRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 0));
					lateRainsPoorRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 15));
					lateRainsNoRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 27));
					lateRainsRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 0));
					lateRainsPoorRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 15));
					lateRainsNoRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 25));
					//Early harvest
					earlyHarvestFine.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 0));
					earlyHarvestPoorRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 15));
					earlyHarvestStorms.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 27));
					earlyHarvestFine.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 0));
					earlyHarvestPoorRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 15));
					earlyHarvestStorms.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 25));
					//Late harvest
					lateHarvestFine.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 0));
					lateHarvestPoorRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 15));
					lateHarvestStorms.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 25));
					break;
				case 4: //Cotton
					//Early rains
					earlyRainsRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 0));
					earlyRainsPoorRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 15));
					earlyRainsNoRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 30));
					//Late rains
					lateRainsRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 0));
					lateRainsPoorRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 15));
					lateRainsNoRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 30));
					lateRainsRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 0));
					lateRainsPoorRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 15));
					lateRainsNoRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 25));
					//Early harvest
					earlyHarvestFine.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 0));
					earlyHarvestPoorRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 15));
					earlyHarvestStorms.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 25));
					earlyHarvestFine.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 0));
					earlyHarvestPoorRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 15));
					earlyHarvestStorms.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 25));
					//Late harvest
					lateHarvestFine.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 0));
					lateHarvestPoorRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 15));
					lateHarvestStorms.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 25));
					break;
				case 7: //Sorgham
					//Early rains
					earlyRainsRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 0));
					earlyRainsPoorRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 10));
					earlyRainsNoRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 20));
					//Late rains
					lateRainsRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 0));
					lateRainsPoorRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 10));
					lateRainsNoRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 20));
					lateRainsRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 0));
					lateRainsPoorRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 10));
					lateRainsNoRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 20));
					//Early harvest
					earlyHarvestFine.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 0));
					earlyHarvestPoorRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 5));
					earlyHarvestStorms.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 10));
					earlyHarvestFine.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 0));
					earlyHarvestPoorRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 5));
					earlyHarvestStorms.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 10));
					//Late rains
					lateHarvestFine.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 0));
					lateHarvestPoorRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 5));
					lateHarvestStorms.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 10));
					break;
				case 10: // Drought tolerant maize
					//Early rains
					earlyRainsRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 0));
					earlyRainsPoorRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 10));
					earlyRainsNoRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 15));
					//Late rains
					lateRainsRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 0));
					lateRainsPoorRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 10));
					lateRainsNoRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 15));
					lateRainsRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 0));
					lateRainsPoorRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 10));
					lateRainsNoRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 15));
					//Early harvest
					earlyHarvestFine.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 0));
					earlyHarvestPoorRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 10));
					earlyHarvestStorms.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 15));
					earlyHarvestFine.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 0));
					earlyHarvestPoorRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 10));
					earlyHarvestStorms.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 15));
					//Late harvest
					lateHarvestFine.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 0));
					lateHarvestPoorRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 10));
					lateHarvestStorms.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 15));
					break;
				case 11: // Horticulture
					//Early rains
					earlyRainsRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 0));
					earlyRainsPoorRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 10));
					earlyRainsNoRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 15));
					//Late rains
					lateRainsRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 0));
					lateRainsPoorRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 15));
					lateRainsNoRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 25));
					lateRainsRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 0));
					lateRainsPoorRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 15));
					lateRainsNoRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 25));
					//Early harvest
					earlyHarvestFine.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 0));
					earlyHarvestPoorRains.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 15));
					earlyHarvestStorms.addEPCropEffect(new SeasonalWeatherCropEffect(crop, Field.EARLY_PLANTING, 25));
					earlyHarvestFine.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 0));
					earlyHarvestPoorRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 15));
					earlyHarvestStorms.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 25));
					//Late harvest
					lateHarvestFine.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 0));
					lateHarvestPoorRains.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 15));
					lateHarvestStorms.addLPCropEffect(new SeasonalWeatherCropEffect(crop, Field.LATE_PLANTING, 25));
					break;
				default:
					break;
			}
			}
		}
		
		addSeasonalWeather(earlyRainsRains, CoreEarlyRainsSeason.ID);
		addSeasonalWeather(earlyRainsPoorRains, CoreEarlyRainsSeason.ID);
		addSeasonalWeather(earlyRainsNoRains, CoreEarlyRainsSeason.ID);
		
		addSeasonalWeather(lateRainsRains, CoreLateRainsSeason.ID);
		addSeasonalWeather(lateRainsPoorRains, CoreLateRainsSeason.ID);
		addSeasonalWeather(lateRainsNoRains, CoreLateRainsSeason.ID);
		
		addSeasonalWeather(earlyHarvestFine, CoreEarlyHarvestSeason.ID);
		addSeasonalWeather(earlyHarvestPoorRains, CoreEarlyHarvestSeason.ID);
		addSeasonalWeather(earlyHarvestStorms, CoreEarlyHarvestSeason.ID);
		
		addSeasonalWeather(lateHarvestFine, CoreLateHarvestSeason.ID);
		addSeasonalWeather(lateHarvestPoorRains, CoreLateHarvestSeason.ID);
		addSeasonalWeather(lateHarvestStorms, CoreLateHarvestSeason.ID);
		
	}

}
