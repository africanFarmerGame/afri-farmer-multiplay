/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
