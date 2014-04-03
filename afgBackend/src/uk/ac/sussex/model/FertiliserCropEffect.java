/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseObject;

public class FertiliserCropEffect extends BaseObject{
	private Integer id;
	private Asset fertiliser;
	private Asset crop;
	private Integer epYield;
	private Integer lpYield;
	/**
	 * @return the id
	 */
	public Integer getId() {
		return id;
	}
	/**
	 * @param id the id to set
	 */
	public void setId(Integer id) {
		this.id = id;
	}
	/**
	 * @return the fertiliser
	 */
	public Asset getFertiliser() {
		return fertiliser;
	}
	/**
	 * @param fertiliser the fertiliser to set
	 */
	public void setFertiliser(Asset fertiliser) {
		this.fertiliser = fertiliser;
	}
	/**
	 * @return the crop
	 */
	public Asset getCrop() {
		return crop;
	}
	/**
	 * @param crop the crop to set
	 */
	public void setCrop(Asset crop) {
		this.crop = crop;
	}
	/**
	 * @return the epYield
	 */
	public Integer getEpYield() {
		return epYield;
	}
	/**
	 * @param epYield the epYield to set
	 */
	public void setEpYield(Integer epYield) {
		this.epYield = epYield;
	}
	/**
	 * @return the lpYield
	 */
	public Integer getLpYield() {
		return lpYield;
	}
	/**
	 * @param lpYield the lpYield to set
	 */
	public void setLpYield(Integer lpYield) {
		this.lpYield = lpYield;
	}
	
}
