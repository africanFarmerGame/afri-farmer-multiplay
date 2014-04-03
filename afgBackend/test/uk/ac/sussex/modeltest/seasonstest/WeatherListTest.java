/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.modeltest.seasonstest;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.junit.Test;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;
import uk.ac.sussex.model.seasons.*;

public class WeatherListTest {

	@Test
	public void testFetchSeasonalWeatherCropEffect() {
		
		GameFactory gf = new GameFactory();
		Game seasonalGame = null;
		Game sampleGame = null;
		try {
			sampleGame = gf.fetchGame(1);
			seasonalGame = gf.fetchGame(2);
		} catch (Exception e2) {
			e2.printStackTrace();
			fail ("Problem getting the games");
		}
		
		WeatherList seasonalWL = seasonalGame.fetchWeatherList();
		WeatherList sampleWL = sampleGame.fetchWeatherList();
		
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		SeasonDetail noWeatherSD = null;
		SeasonDetail weatherSetSD = null;
		try {
			noWeatherSD = sdf.fetchSeasonDetail(1);
			weatherSetSD = sdf.fetchSeasonDetail(2);
		} catch (Exception e1) {
			e1.printStackTrace();
			fail ("Problem with the seasonDetails");
		}
		
		AssetFactory af = new AssetFactory();
		Asset maize = null;
		try {
			maize = af.fetchAsset("Maize");
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get hold of the maize.");
		}
		Integer cropId = maize.getId();
		
		
		SeasonalWeatherCropEffect earlyMaizeEffect = sampleWL.fetchSeasonalWeatherCropEffect(weatherSetSD, cropId, Field.EARLY_PLANTING);
		assertNotNull(earlyMaizeEffect);
		assertEquals((Integer) 0, earlyMaizeEffect.getYieldReduction());
		SeasonalWeatherCropEffect lateMaizeEffect = sampleWL.fetchSeasonalWeatherCropEffect(weatherSetSD, cropId, Field.LATE_PLANTING);
		assertNotNull(lateMaizeEffect);
		assertEquals((Integer) 0, lateMaizeEffect.getYieldReduction());
		SeasonalWeatherCropEffect noWeatherSetEffect = seasonalWL.fetchSeasonalWeatherCropEffect(noWeatherSD, cropId, Field.EARLY_PLANTING);
		assertNull(noWeatherSetEffect);
		
	}
	//This is to test my code repeatedly, because I"m not sure it's working. 
	@Test
	public void testingProportions(){
		//Weather storms = new Weather("STORMS", "Storms");
		Weather rains = new Weather("RAINS", "Rain");
		Weather poorRains = new Weather("POOR_RAINS", "Poor Rain");
		Weather noRains = new Weather("NO_RAINS", "No Rain");
		//Weather fine = new Weather("FINE", "Fine");
		
		SeasonWeather earlyRainsRains = new SeasonWeather(rains, (float) 0.7);
		SeasonWeather earlyRainsPoorRains = new SeasonWeather(poorRains, (float) 0.2);
		SeasonWeather earlyRainsNoRains = new SeasonWeather(noRains, (float) 0.1);
		
		List<SeasonWeather> seasonalWeather = new ArrayList<SeasonWeather>();
		seasonalWeather.add(earlyRainsRains);
		seasonalWeather.add(earlyRainsNoRains);
		seasonalWeather.add(earlyRainsPoorRains);
		
		int earlyRainsRainsCounter = 0;
		int earlyRainsPoorRainsCounter = 0;
		int earlyRainsNoRainsCounter = 0;
		
		int maxCycles = 20;
		
		for (int i=0;i<maxCycles;i++){
			Double weatherGenerator = Math.random();
			
			System.out.println("Weather probability: " + weatherGenerator);
			
			Double maxProbability = 0.0;
			Double minProbability = 0.0;
			Boolean chosen = false;
			Iterator<SeasonWeather> weatherIterator = seasonalWeather.iterator();
			SeasonWeather chosenSeasonalWeather = null;
			while(weatherIterator.hasNext() && chosen==false){
				chosenSeasonalWeather = weatherIterator.next();
				maxProbability = minProbability + chosenSeasonalWeather.getProbability();
				System.out.println("MaxProbability set to " + maxProbability + " min set to " + minProbability);
				chosen = ((maxProbability > weatherGenerator) && (minProbability <= weatherGenerator));
				System.out.println("Chosen is " + chosen);
				minProbability = maxProbability;
			}
			if(chosenSeasonalWeather == null){
				//That's a problem.
				fail("Weather is null");
			} 
			String chosenWeatherId = chosenSeasonalWeather.getWeather().getId();
			if(chosenWeatherId.equals(earlyRainsRains.getWeather().getId())){
				earlyRainsRainsCounter ++;
			} else if(chosenWeatherId.equals(earlyRainsPoorRains.getWeather().getId())){
				earlyRainsPoorRainsCounter ++;
			} else if (chosenWeatherId.equals(earlyRainsNoRains.getWeather().getId())){
				earlyRainsNoRainsCounter ++;
			}
			
		}
		assertEquals(maxCycles, earlyRainsRainsCounter + earlyRainsNoRainsCounter + earlyRainsPoorRainsCounter );
		System.out.println("EarlyRainsRains " + earlyRainsRainsCounter);
		System.out.println("EarlyRainsPoor " + earlyRainsPoorRainsCounter);
		System.out.println("EarlyRainsNo " + earlyRainsNoRainsCounter);
		
	}
}
