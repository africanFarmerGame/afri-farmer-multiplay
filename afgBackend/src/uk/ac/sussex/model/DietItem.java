package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseObject;

public class DietItem extends BaseObject {
	private Integer id;
	private Diet diet;
	private Asset asset;
	private Integer amount;
	
	public DietItem() {
		super();
		this.addOptionalParam("Id");
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
	 * @param diet the diet to set
	 */
	public void setDiet(Diet diet) {
		this.diet = diet;
	}
	/**
	 * @return the diet
	 */
	public Diet getDiet() {
		return diet;
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
	public void setAmount(Integer amount) {
		this.amount = amount;
	}
	/**
	 * @return the amount
	 */
	public Integer getAmount() {
		return amount;
	}
	
	
}
