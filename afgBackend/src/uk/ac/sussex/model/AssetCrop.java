package uk.ac.sussex.model;

public class AssetCrop extends Asset {
	private Integer epYield;
	private Integer lpYield;
	private Asset outputAsset;
	private Integer maturity;
	private Integer weedLoss;
	/**
	 * @return the ep_yield
	 */
	public Integer getEPYield() {
		return epYield;
	}
	/**
	 * @param ep_yield the ep_yield to set
	 */
	public void setEPYield(Integer ep_yield) {
		this.epYield = ep_yield;
	}
	/**
	 * @return the lp_yield
	 */
	public Integer getLPYield() {
		return lpYield;
	}
	/**
	 * @param lp_yield the lp_yield to set
	 */
	public void setLPYield(Integer lp_yield) {
		this.lpYield = lp_yield;
	}
	/**
	 * @return the outputAsset
	 */
	public Asset getOutputAsset() {
		return outputAsset;
	}
	/**
	 * @param outputAsset the outputAsset to set
	 */
	public void setOutputAsset(Asset outputAsset) {
		this.outputAsset = outputAsset;
	}
	/**
	 * @return the maturity - the number of seasons from sowing to full maturity.
	 */
	public Integer getMaturity() {
		return maturity;
	}
	/**
	 * @param maturity the maturity to set
	 */
	public void setMaturity(Integer maturity) {
		this.maturity = maturity;
	}
	/**
	 * @return the weedLoss
	 */
	public Integer getWeedLoss() {
		return weedLoss;
	}
	/**
	 * @param weedLoss the weedLoss to set
	 */
	public void setWeedLoss(Integer weedLoss) {
		this.weedLoss = weedLoss;
	}
	
}
