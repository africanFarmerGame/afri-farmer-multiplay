package uk.ac.sussex.model;

import java.util.List;

import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.tasks.TaskOption;

public class Asset extends BaseObject {
	private Integer id;
	private String name;
	private String measurement;
	private Integer edible;
	private String type;
	private String subtype;
	private Double guideBuyPrice;
	private Double guideSellPrice;
	private String notes;
	private Double initialStock;
	private Integer reclaimOrder;
	private AssetOwnerFactory assetOwnerFactory;
	private MarketAssetFactory marketAssetFactory;
	
	public static final Integer CASH = 8;
	public static final Integer SCHOOL_VOUCHER = 13;
	
	public Asset(){
		super();
		this.addOptionalParam("Id");
		assetOwnerFactory = new AssetOwnerFactory();
		marketAssetFactory = new MarketAssetFactory();
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
	 * @param name the name to set
	 */
	public void setName(String name) {
		this.name = name;
	}
	/**
	 * @return the name
	 */
	public String getName() {
		return name;
	}
	/**
	 * @param measurement the measurement to set
	 */
	public void setMeasurement(String measurement) {
		this.measurement = measurement;
	}
	/**
	 * @return the measurement
	 */
	public String getMeasurement() {
		return measurement;
	}
	/**
	 * @param edible the edible to set
	 */
	public void setEdible(Integer edible) {
		this.edible = edible;
	}
	/**
	 * @return the edible
	 */
	public Integer getEdible() {
		return edible;
	}
	/**
	 * @param type the type to set
	 */
	public void setType(String type) {
		this.type = type;
	}
	/**
	 * @return the type
	 */
	public String getType() {
		return type;
	}
	/**
	 * @return the subtype
	 */
	public String getSubtype() {
		return subtype;
	}
	/**
	 * @param subtype the subtype to set
	 */
	public void setSubtype(String subtype) {
		this.subtype = subtype;
	}
	public void setGuideBuyPrice(Double guideBuyPrice) {
		this.guideBuyPrice = guideBuyPrice;
	}
	public Double getGuideBuyPrice() {
		return guideBuyPrice;
	}
	public void setGuideSellPrice(Double guideSellPrice) {
		this.guideSellPrice = guideSellPrice;
	}
	public Double getGuideSellPrice() {
		return guideSellPrice;
	}
	/**
	 * @return the notes
	 */
	public String getNotes() {
		return notes;
	}
	/**
	 * @param notes the notes to set
	 */
	public void setNotes(String notes) {
		this.notes = notes;
	}
	/**
	 * @return the initialStock
	 */
	public Double getInitialStock() {
		return initialStock;
	}
	/**
	 * @param initialStock the initialStock to set
	 */
	public void setInitialStock(Double initialStock) {
		this.initialStock = initialStock;
	}
	/**
	 * @return the reclaimOrder
	 */
	public Integer getReclaimOrder() {
		return reclaimOrder;
	}
	/**
	 * @param reclaimOrder the reclaimOrder to set
	 */
	public void setReclaimOrder(Integer reclaimOrder) {
		this.reclaimOrder = reclaimOrder;
	}
	/**
	 * @param hearth
	 * @throws Exception if fetching assetOwner fails
	 */
	public Double fetchAmountHearthOwn(Hearth hearth) throws Exception {
		AssetOwner assetOwner = null;
		try {
			assetOwner = assetOwnerFactory.fetchSpecificAsset(hearth, this);
		} catch (Exception e) {
			throw new Exception("Unable to fetch amount owned of asset " + this.getName() + ": " + e.getMessage());
		}
		if(assetOwner==null){
			return null;
		} else {
			return assetOwner.getAmount();
		}
	}
	public Double fetchAmountPlayerOwns(PlayerChar pc) throws Exception{
		AssetOwner assetOwner = null;
		try {
			assetOwner = assetOwnerFactory.fetchSpecificPCAsset(pc, this);
		} catch (Exception e) {
			throw new Exception("Unable to fetch amount owned of asset " + this.getName() + ": " + e.getMessage());
		}
		if(assetOwner==null){
			return null;
		} else {
			return assetOwner.getAmount();
		}
	}
	public MarketAsset fetchMarketAsset(Game game) throws Exception {
		MarketAsset ma = null;
		if(this.getId().equals(CASH)){
			return null;
		}
		try{
			ma = marketAssetFactory.fetchMarketAssetbyAsset(this, game);
		} catch (Exception e) {
			throw new Exception("Unable to fetch market amounts for asset " + this.getName() + ": " + e.getMessage());
		}
		return ma;
	}
	public List<TaskOption> fetchHearthBuyOptions(Hearth hearth) throws Exception {
		return null;
	}
	public List<TaskOption> fetchHearthSellOptions(Hearth hearth) throws Exception {
		return null;
	}
	public Double buyAssetAmount(Hearth hearth, Double quantity) throws Exception{
		AssetOwner assetOwner = null;
		MarketAsset marketAsset = null;
		try{
			marketAsset = this.fetchMarketAsset(hearth.getGame());
		} catch(Exception e){
			throw new Exception ("Problem fetching the market details for asset " + getName() + ": " + e.getMessage());
		}
		try {
			assetOwner = assetOwnerFactory.fetchSpecificAsset(hearth, this);
			assetOwner.setAmount(assetOwner.getAmount() + quantity);
			assetOwner.save();
		} catch (Exception e) {
			throw new Exception("Problem with ownership record for asset " + this.getName() + ": " + e.getMessage());
		}
		try {
			Double cashAmount = quantity * marketAsset.getSellPrice();
			AssetOwner cashOwner = fetchCashAssetOwner(hearth);
			cashOwner.setAmount(cashOwner.getAmount()-cashAmount);
			cashOwner.save();
		} catch (Exception e1) {
			throw new Exception("Problem saving the cash exchange: " + e1.getMessage());
		}
		try {
			marketAsset.setAmount(marketAsset.getAmount() - quantity);
			marketAsset.save();				
		} catch (Exception e) {
			throw new Exception("Unable to complete the purchase due to an error with the market levels: " + e.getMessage());
		}
		return quantity;
	}
	public Double sellAssetAmount(Hearth hearth, Double quantity) throws Exception{
		AssetOwner assetOwner = null;
		try {
			assetOwner = assetOwnerFactory.fetchSpecificAsset(hearth, this);
			Double sellAssetAmount = assetOwner.getAmount();
			if(sellAssetAmount < quantity){
				quantity = sellAssetAmount;
				//successMessage += "Unfortunately, you only owned " + sellAssetOwnerAmount.intValue() + ". \n";
			}
			assetOwner.setAmount(sellAssetAmount-quantity);
			assetOwner.save();
		} catch (Exception e) {
			throw new Exception("Problem with ownership record for asset " + this.getName() + ": " + e.getMessage());
		}
		MarketAsset ma = null;
		try {
			ma = this.fetchMarketAsset(hearth.getGame());
			ma.setAmount(ma.getAmount() + quantity);
			ma.save();
		} catch (Exception e2) {
			throw new Exception("Problem saving the market record of this deal: " + e2.getMessage());
		}
		try {
			Double cashAmount = quantity * ma.getBuyPrice();
			AssetOwner cashOwner = fetchCashAssetOwner(hearth);
			cashOwner.setAmount(cashOwner.getAmount()+cashAmount);
			cashOwner.save();
		} catch (Exception e1) {
			throw new Exception("Problem saving the cash exchange: " + e1.getMessage());
		}
		
		return quantity;
	}
	public Boolean sellSpecificAsset(Hearth hearth, Integer assetId) throws Exception {
		throw new Exception("Selling a specific item of " + this.getName() + " is not supported. Please select a quantity to sell.");
	}
	public Double giveAssetAmount(Hearth giver, Hearth receiver, Double quantity) throws Exception{
		AssetOwner ownerAO = null;
		AssetOwner receiverAO = null;
		try {
			ownerAO = assetOwnerFactory.fetchSpecificAsset(giver, this);
			Double giveAmount = ownerAO.getAmount();
			if(giveAmount < quantity){
				quantity = giveAmount;
			}
			ownerAO.setAmount(giveAmount-quantity);
			ownerAO.save();
		} catch(Exception e){
			throw new Exception("Problem with the giver's ownership record for asset " + this.getName() + ": " + e.getMessage());
		}
		try{
			receiverAO = assetOwnerFactory.fetchSpecificAsset(receiver, this);
			receiverAO.setAmount(receiverAO.getAmount() + quantity);
			receiverAO.save();
		} catch (Exception e){
			throw new Exception("Problem with the receiver's ownership record for asset " + this.getName() + ": " + e.getMessage());
		}
		
		return quantity;
	}
	public Boolean giveSpecificAsset(Hearth giver, Hearth receiver, Integer optionId) throws Exception {
		throw new Exception("Giving a specific item of " + this.getName() + " is not supported. Please select a quantity to give.");
	}
	public Double giveAssetAmountFromBanker(Hearth receiver, Double quantity) throws Exception{
		AssetOwner receiverAO = null;
		try{
			receiverAO = assetOwnerFactory.fetchSpecificAsset(receiver, this);
			receiverAO.setAmount(receiverAO.getAmount() + quantity);
			receiverAO.save();
		} catch (Exception e){
			throw new Exception("Problem with the receiver's ownership record for asset " + this.getName() + ": " + e.getMessage());
		}
		
		return quantity;
	}
	protected AssetOwner fetchCashAssetOwner(Hearth hearth) throws Exception{
		AssetFactory assetFactory = new AssetFactory();
		Asset cash = null;
		try {
			cash = assetFactory.fetchAsset(CASH);
		} catch (Exception e) {
			throw new Exception("Problem fetching the cash Asset: " + e.getMessage());
		}
		AssetOwner cashAssetOwner = null;
		try {
			cashAssetOwner = assetOwnerFactory.fetchSpecificAsset(hearth, cash);
		} catch (Exception e) {
			throw new Exception("Problem fetching the asset owner record for cash: " + e.getMessage());
		}
		return cashAssetOwner;
	}
}
