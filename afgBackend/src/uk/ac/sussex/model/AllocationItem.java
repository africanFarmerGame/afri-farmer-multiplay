package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseObject;

public class AllocationItem extends BaseObject {
	private Integer id;
	private Asset asset;
	private Allocation allocation;
	private AllChars character;
	private Integer amount;
	
	public AllocationItem() {
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
	 * @return the allocation
	 */
	public Allocation getAllocation() {
		return allocation;
	}

	/**
	 * @param allocation the allocation to set
	 */
	public void setAllocation(Allocation allocation) {
		this.allocation = allocation;
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
	 * @return the amount
	 */
	public Integer getAmount() {
		return amount;
	}

	/**
	 * @param amount the amount to set
	 */
	public void setAmount(Integer amount) {
		this.amount = amount;
	}
}
