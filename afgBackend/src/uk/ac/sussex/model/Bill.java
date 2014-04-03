/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseObject;

public class Bill extends BaseObject {
	private Integer id;
	private String description;
	private Double earlyRate;
	private Double lateRate;
	private Hearth payee;
	private SeasonDetail season;
	private Integer paid = 0;
	private String duration;
	private String billType;
	private AllChars character;
	
	public final static Integer BEEN_PAID = 1;
	public final static String ANNUAL = "annual";
	public final static String SEASONAL = "seasonal";
	
	public Bill() {
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
	 * @return the description
	 */
	public String getDescription() {
		return description;
	}

	/**
	 * @param description the description to set
	 */
	public void setDescription(String description) {
		this.description = description;
	}

	/**
	 * @return the earlyRate
	 */
	public Double getEarlyRate() {
		return earlyRate;
	}

	/**
	 * @param earlyRate the earlyRate to set
	 */
	public void setEarlyRate(Double earlyRate) {
		this.earlyRate = earlyRate;
	}

	/**
	 * @return the lateRate
	 */
	public Double getLateRate() {
		return lateRate;
	}

	/**
	 * @param lateRate the lateRate to set
	 */
	public void setLateRate(Double lateRate) {
		this.lateRate = lateRate;
	}

	/**
	 * @return the payee
	 */
	public Hearth getPayee() {
		return payee;
	}

	/**
	 * @param payee the payee to set
	 */
	public void setPayee(Hearth payee) {
		this.payee = payee;
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
	 * @return the paid
	 */
	public Integer getPaid() {
		return paid;
	}

	/**
	 * @param paid the paid to set
	 */
	public void setPaid(Integer paid) {
		this.paid = paid;
	}

	/**
	 * @return the duration
	 */
	public String getDuration() {
		return duration;
	}

	/**
	 * @param duration the duration to set
	 */
	public void setDuration(String duration) {
		this.duration = duration;
	}

	/**
	 * @return the billType
	 */
	public String getBillType() {
		return billType;
	}

	/**
	 * @param billType the billType to set
	 */
	public void setBillType(String billType) {
		this.billType = billType;
	}
	
	public void payBill() throws Exception {
		this.setPaid(BEEN_PAID);
		this.save();
	}

	public void setCharacter(AllChars character) {
		this.character = character;
	}

	public AllChars getCharacter() {
		return character;
	}
}
