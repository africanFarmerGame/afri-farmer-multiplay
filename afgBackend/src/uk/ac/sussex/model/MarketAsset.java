/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.model.game.Game;

public class MarketAsset extends BaseObject {
	private Integer id;
	private Asset asset;
	private Double amount;
	private Double buyPrice;
	private Double sellPrice;
	private Game game;
	
	public MarketAsset() {
		super();
		this.addValidationParams();
	}
	private void addValidationParams() {
		this.addOptionalParam("Id");
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getId() {
		return id;
	}
	public void setAsset(Asset asset) {
		this.asset = asset;
	}
	public Asset getAsset() {
		return asset;
	}
	public void setAmount(Double amount) {
		this.amount = amount;
	}
	public Double getAmount() {
		return amount;
	}
	/**
	 * The buy price is the price that the market buys for. It is lower than the sell price.
	 * @return
	 */
	public void setBuyPrice(Double buyPrice) {
		this.buyPrice = buyPrice;
	}
	/**
	 * The buy price is the price that the market buys for. It is lower than the sell price.
	 * @return Double buyPrice.
	 */
	public Double getBuyPrice() {
		return buyPrice;
	}
	public void setSellPrice(Double sellPrice) {
		this.sellPrice = sellPrice;
	}
	public Double getSellPrice() {
		return sellPrice;
	}
	public void setGame(Game game) {
		this.game = game;
	}
	public Game getGame() {
		return game;
	}
	
}
