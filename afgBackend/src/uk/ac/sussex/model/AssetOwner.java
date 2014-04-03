package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseObject;

public class AssetOwner extends BaseObject {
	private Integer id;
	private Asset asset;
	private Double amount;
	private Hearth hearth;
	private PlayerChar owner;
	public AssetOwner(){
		super();
		this.addOptionalParam("Id");
		this.addOptionalParam("Hearth");
		this.addOptionalParam("Owner");
	}
	/**
	 * @param id the id to set
	 */
	public void setId(Integer id) {
		this.id = id;
	}
	/**
	 * @return the id
	 */
	public Integer getId() {
		return id;
	}
	/**
	 * @param asset the asset to set
	 */
	public void setAsset(Asset asset) {
		this.asset = asset;
	}
	/**
	 * @return the asset
	 */
	public Asset getAsset() {
		return asset;
	}
	/**
	 * @param amount the amount to set
	 */
	public void setAmount(Double amount) {
		this.amount = amount;
	}
	/**
	 * @return the amount
	 */
	public Double getAmount() {
		return amount;
	}
	/**
	 * @param hearth the hearth to set
	 */
	public void setHearth(Hearth hearth) {
		this.hearth = hearth;
	}
	/**
	 * @return the hearth
	 */
	public Hearth getHearth() {
		return hearth;
	}
	/**
	 * @param owner the owner to set
	 */
	public void setOwner(PlayerChar owner) {
		this.owner = owner;
	}
	/**
	 * @return the owner
	 */
	public PlayerChar getOwner() {
		return owner;
	}
}
