package uk.ac.sussex.model.seasons;

import uk.ac.sussex.model.AssetCrop;

public class SeasonalWeatherCropEffect {
	private AssetCrop crop;
	private Integer plantingTime;
	private Integer yieldReduction;
	public SeasonalWeatherCropEffect(AssetCrop crop, Integer plantingTime, Integer yieldReduction){
		
		this.crop = crop;
		this.plantingTime = plantingTime;
		this.yieldReduction = yieldReduction;
	}
	/**
	 * @return the crop
	 */
	public AssetCrop getCrop() {
		return crop;
	}
	/**
	 * @return the plantingTime
	 */
	public Integer getPlantingTime() {
		return plantingTime;
	}
	/**
	 * @return the yieldReduction
	 */
	public Integer getYieldReduction() {
		return yieldReduction;
	}
}
