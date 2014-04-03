/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseObject;

public class SeasonHearthStatus extends BaseObject {
	private Integer id;
	private SeasonDetail season;
	private Hearth hearth;
	private Integer numFields;
	private Integer totalFamily;
	private Integer livingFamily;
	private Integer deadFamily;
	private Integer totalAdults;
	private Integer numPCs;
	
	public SeasonHearthStatus() {
		super();
		this.addOptionalParam("Id");
	}

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
	 * @return the season
	 */
	public SeasonDetail getSeason() {
		return season;
	}

	/**
	 * @param season the season to set
	 */
	public void setSeason(SeasonDetail season) {
		this.season = season;
	}

	/**
	 * @return the hearth
	 */
	public Hearth getHearth() {
		return hearth;
	}

	/**
	 * @param hearth the hearth to set
	 */
	public void setHearth(Hearth hearth) {
		this.hearth = hearth;
	}

	/**
	 * @return the numFields
	 */
	public Integer getNumFields() {
		return numFields;
	}

	/**
	 * @param numFields the numFields to set
	 */
	public void setNumFields(Integer numFields) {
		this.numFields = numFields;
	}

	/**
	 * @return the totalFamily
	 */
	public Integer getTotalFamily() {
		return totalFamily;
	}

	/**
	 * @param totalFamily the totalFamily to set
	 */
	public void setTotalFamily(Integer totalFamily) {
		this.totalFamily = totalFamily;
	}

	/**
	 * @return the livingFamily
	 */
	public Integer getLivingFamily() {
		return livingFamily;
	}

	/**
	 * @param livingFamily the livingFamily to set
	 */
	public void setLivingFamily(Integer livingFamily) {
		this.livingFamily = livingFamily;
	}

	/**
	 * @return the deadFamily
	 */
	public Integer getDeadFamily() {
		return deadFamily;
	}

	/**
	 * @param deadFamily the deadFamily to set
	 */
	public void setDeadFamily(Integer deadFamily) {
		this.deadFamily = deadFamily;
	}

	/**
	 * @return the totalAdults
	 */
	public Integer getTotalAdults() {
		return totalAdults;
	}

	/**
	 * @param totalAdults the totalAdults to set
	 */
	public void setTotalAdults(Integer totalAdults) {
		this.totalAdults = totalAdults;
	}

	/**
	 * @return the numPCs
	 */
	public Integer getNumPCs() {
		return numPCs;
	}

	/**
	 * @param numPCs the numPCs to set
	 */
	public void setNumPCs(Integer numPCs) {
		this.numPCs = numPCs;
	}
	
}
