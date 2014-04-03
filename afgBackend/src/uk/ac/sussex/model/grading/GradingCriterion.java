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
