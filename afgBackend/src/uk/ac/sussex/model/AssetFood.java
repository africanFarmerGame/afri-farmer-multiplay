/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model;

public class AssetFood extends AssetCrop {
	private Integer protein;
	private Integer carbs;
	private Integer nutrients;
	
	public static String MAIZE = "Maize";
	/**
	 * @param protein the protein to set
	 */
	public void setProtein(Integer protein) {
		this.protein = protein;
	}
	/**
	 * @return the protein
	 */
	public Integer getProtein() {
		return protein;
	}
	/**
	 * @param carbs the carbs to set
	 */
	public void setCarbs(Integer carbs) {
		this.carbs = carbs;
	}
	/**
	 * @return the carbs
	 */
	public Integer getCarbs() {
		return carbs;
	}
	/**
	 * @param nutrients the nutrients to set
	 */
	public void setNutrients(Integer nutrients) {
		this.nutrients = nutrients;
	}
	/**
	 * @return the nutrients
	 */
	public Integer getNutrients() {
		return nutrients;
	}
	
	
}
