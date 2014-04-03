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
