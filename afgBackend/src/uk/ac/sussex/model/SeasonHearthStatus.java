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
