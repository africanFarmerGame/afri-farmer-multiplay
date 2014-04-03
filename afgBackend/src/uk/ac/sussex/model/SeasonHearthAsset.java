package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseObject;

public class SeasonHearthAsset extends BaseObject {
	private Integer id;
	private SeasonDetail season;
	private Hearth hearth;
	private Asset asset;
	private Double amount;
	
	public SeasonHearthAsset() {
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
	 * @return the asset
	 */
	public Asset getAsset() {
		return asset;
	}

	/**
	 * @param asset the asset to set
	 */
	public void setAsset(Asset asset) {
		this.asset = asset;
	}

	/**
	 * @return the amount
	 */
	public Double getAmount() {
		return amount;
	}

	/**
	 * @param amount the amount to set
	 */
	public void setAmount(Double amount) {
		this.amount = amount;
	}

}
