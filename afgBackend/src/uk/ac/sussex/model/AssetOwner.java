/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
