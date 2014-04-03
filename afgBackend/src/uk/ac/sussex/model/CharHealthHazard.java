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
