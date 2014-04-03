/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
