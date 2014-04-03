package uk.ac.sussex.model.seasons;

import java.util.HashSet;
import java.util.Set;

import uk.ac.sussex.model.Field;

public class SeasonWeather {
	private Weather weather;
	private Float probability;
	private Set<SeasonalWeatherCropEffect> epCropEffects;
	private Set<SeasonalWeatherCropEffect> lpCropEffects;

	public SeasonWeather(Weather weather, Float probability){
		this.probability = probability;
		this.weather = weather;
	}
	public Weather getWeather(){
		return this.weather;
	}
	public Float getProbability(){
		return this.probability;
	}
	public void addEPCropEffect(SeasonalWeatherCropEffect cropEffect){
		if(epCropEffects==null){
			epCropEffects = new HashSet<SeasonalWeatherCropEffect>();
		}
		epCropEffects.add(cropEffect);
	}
	public void addLPCropEffect(SeasonalWeatherCropEffect cropEffect){
		if(lpCropEffects == null){
			lpCropEffects = new HashSet<SeasonalWeatherCropEffect>();
		}
		lpCropEffects.add(cropEffect);
	}
	public SeasonalWeatherCropEffect fetchCropEffect(Integer cropId, Integer cropPlanting){
		if(cropPlanting == Field.EARLY_PLANTING){
			return retrieveCropEffect(epCropEffects, cropId);
		} else {
			return retrieveCropEffect(lpCropEffects, cropId);
		}
	}
	private SeasonalWeatherCropEffect retrieveCropEffect(Set<SeasonalWeatherCropEffect> cropEffects, Integer cropId){
		for (SeasonalWeatherCropEffect cropEffect: cropEffects){
			if (cropEffect.getCrop().getId() == cropId){
				return cropEffect;
			}
		}
		return null;
	}
}
