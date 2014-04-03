package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseObject;

public class FertiliserCropEffect extends BaseObject{
	private Integer id;
	private Asset fertiliser;
	private Asset crop;
	private Integer epYield;
	private Integer lpYield;
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
	 * @return the fertiliser
	 */
	public Asset getFertiliser() {
		return fertiliser;
	}
	/**
	 * @param fertiliser the fertiliser to set
	 */
	public void setFertiliser(Asset fertiliser) {
		this.fertiliser = fertiliser;
	}
	/**
	 * @return the crop
	 */
	public Asset getCrop() {
		return crop;
	}
	/**
	 * @param crop the crop to set
	 */
	public void setCrop(Asset crop) {
		this.crop = crop;
	}
	/**
	 * @return the epYield
	 */
	public Integer getEpYield() {
		return epYield;
	}
	/**
	 * @param epYield the epYield to set
	 */
	public void setEpYield(Integer epYield) {
		this.epYield = epYield;
	}
	/**
	 * @return the lpYield
	 */
	public Integer getLpYield() {
		return lpYield;
	}
	/**
	 * @param lpYield the lpYield to set
	 */
	public void setLpYield(Integer lpYield) {
		this.lpYield = lpYield;
	}
	
}
