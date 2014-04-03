/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

/**
 * 
 */
package uk.ac.sussex.model.grading;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.base.BaseObject;

/**
 * @author eam31
 *
 */
public class GradingCriterion extends BaseObject implements ICriterion {
	private Integer id;
	private String type;
	private PlayerChar pc;
	private Hearth hearth;
	private Integer gameYear;
	private Double value; 
	
	public GradingCriterion() {
		this.addOptionalParam("Id"); // Gets set on save.
	}
	
	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getId() {
		return id;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getType() {
		return type;
	}

	public void setPc(PlayerChar pc) {
		this.pc = pc;
	}

	public PlayerChar getPc() {
		return pc;
	}

	public void setHearth(Hearth hearth) {
		this.hearth = hearth;
	}

	public Hearth getHearth() {
		return hearth;
	}

	public void setGameYear(Integer gameYear) {
		this.gameYear = gameYear;
	}

	public Integer getGameYear() {
		return gameYear;
	}

	public void setValue(Double value) {
		this.value = value;
	}

	public Double getValue() {
		return value;
	}

	/* (non-Javadoc)
	 * @see uk.ac.sussex.model.grading.ICriterion#calculateValue(uk.ac.sussex.model.PlayerChar)
	 */
	@Override
	public void calculateValue(PlayerChar pc, Integer gameYear) {
		// TODO Auto-generated method stub

	}

	/* (non-Javadoc)
	 * @see uk.ac.sussex.model.grading.ICriterion#displayYearEndOutput(uk.ac.sussex.model.PlayerChar, java.lang.Integer)
	 */
	@Override
	public String displayYearEndOutput(PlayerChar pc, Integer gameYear) {
		return "";
	}
	
	/* (non-Javadoc)
	 * @see uk.ac.sussex.model.grading.ICriterion#displayFinalReckoning(uk.ac.sussex.model.PlayerChar)
	 */
	@Override
	public String displayFinalReckoning(PlayerChar pc) {
		// TODO Auto-generated method stub
		return null;
	}

}
