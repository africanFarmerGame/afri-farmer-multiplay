/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseObject;

public class CharHealthHazard extends BaseObject {
	private Integer id;
	private AllChars character;
	private HealthHazard hazard;
	private SeasonDetail season;
	private Integer outcome;
	private Bill bill;
	
	public static Integer OUTCOME_HOSPITAL = 1;
	public static Integer OUTCOME_DEATH = 0;
	
	public CharHealthHazard() {
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
	 * @return the character
	 */
	public AllChars getCharacter() {
		return character;
	}
	/**
	 * @param character the character to set
	 */
	public void setCharacter(AllChars character) {
		this.character = character;
	}
	/**
	 * @return the hazard
	 */
	public HealthHazard getHazard() {
		return hazard;
	}
	/**
	 * @param hazard the hazard to set
	 */
	public void setHazard(HealthHazard hazard) {
		this.hazard = hazard;
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
	 * @return the outcome
	 */
	public Integer getOutcome() {
		return outcome;
	}
	/**
	 * @param outcome the outcome to set
	 */
	public void setOutcome(Integer outcome) {
		this.outcome = outcome;
	}
	/**
	 * @return the bill
	 */
	public Bill getBill() {
		return bill;
	}
	/**
	 * @param bill the bill to set
	 */
	public void setBill(Bill bill) {
		this.bill = bill;
	}

}
