/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseObject;

public class HealthHazard extends BaseObject {
	private Integer id;
	private String name;
	private String dietLevel;
	private Integer hospital; //This is the integer probability (e.g. 10 = 10% or 0.1) of the hazard causing hospitalisation.
	private Integer death; //This is the integer probability of the hazard causing death.
	private Double medicineCost;
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
	 * @return the name
	 */
	public String getName() {
		return name;
	}
	/**
	 * @param name the name to set
	 */
	public void setName(String name) {
		this.name = name;
	}
	/**
	 * @return the dietLevel
	 */
	public String getDietLevel() {
		return dietLevel;
	}
	/**
	 * @param dietLevel the dietLevel to set
	 */
	public void setDietLevel(String dietLevel) {
		this.dietLevel = dietLevel;
	}
	/**
	 * @return the hospital
	 */
	public Integer getHospital() {
		return hospital;
	}
	/**
	 * @param hospital the hospital to set
	 */
	public void setHospital(Integer hospital) {
		this.hospital = hospital;
	}
	/**
	 * @return the death
	 */
	public Integer getDeath() {
		return death;
	}
	/**
	 * @param death the death to set
	 */
	public void setDeath(Integer death) {
		this.death = death;
	}
	/**
	 * @return the medicineCost
	 */
	public Double getMedicineCost() {
		return medicineCost;
	}
	/**
	 * @param medicineCost the medicineCost to set
	 */
	public void setMedicineCost(Double medicineCost) {
		this.medicineCost = medicineCost;
	}
}
