/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.handlers;

import java.util.Iterator;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;
import uk.ac.sussex.model.tasks.TaskOption;
import uk.ac.sussex.utilities.GameHelper;
import uk.ac.sussex.utilities.Logger;
import uk.ac.sussex.utilities.UserHelper;

import com.smartfoxserver.v2.annotations.MultiHandler;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.extensions.SFSExtension;

@MultiHandler
public class MarketMultiHandler extends BaseClientRequestHandler {

	@Override
	public void handleClientRequest(User user, ISFSObject params) {
		String requestId = params.getUtfString(SFSExtension.MULTIHANDLER_REQUEST_ID);
	    try {
		    switch(MarketMultiEnum.toOption(requestId)) {
		    	case MANAGE_MARKET_ASSETS:
		     		Logger.Log(user.getName(), "Requested the manager market assets list from MarketMultiHandler");
	     			this.managerMarketAssets(user);
		     		break;
		    	case PLAYER_MARKET_ASSETS:
		    		Logger.Log(user.getName(), "Requested the currently in-stock market assets list from MarketMultiHandler");
	    			this.playerMarketAssets(user);
		    		break;
		    	case PLAYER_CURRENT_ASSETS:
		    		Logger.Log(user.getName(), "Requested their player assets in market asset format from MarketMultiHandler");
	    			this.playerCurrentAssets(user);
		    		break;
		    	case UPDATE_MARKET_ASSET:
		    		Integer assetId = params.getInt("Id");
		    		Logger.Log(user.getName(), "Updated details for market asset " + assetId);
	    			this.updateMarketAsset(user, params);
		    		break;
		    	case SUBMIT_BUY_REQUEST:
		    		Integer buyAssetId = params.getInt("AssetId");
		    		Double buyQuantity = params.getDouble("Quantity");
		    		String buyOwner = params.getUtfString("Owner");
		    		Logger.ErrorLog("MarketMultiHandler.handleClientRequest(Submit buy)", "About to go buy stuff.");
		    		Logger.Log(user.getName(), "Attempted to buy " + buyQuantity + " of asset " + buyAssetId + " for " + buyOwner);
	    			this.submitBuyRequest(user, buyAssetId, buyQuantity, buyOwner);
		    		break;
		    	case SUBMIT_SELL_REQUEST:
		    		Integer sellAssetId = params.getInt("AssetId");
		    		Double sellQuantity = params.getDouble("Quantity");
		    		String sellOwner = params.getUtfString("Owner");
		    		Integer sellOption = params.getInt("Option");
		    		if(sellQuantity == 0 && sellOption>0){
		    			Logger.Log(user.getName(), "Attempted to sell assetId " + sellOption + ", which is asset " + sellAssetId + " for "  + sellOwner);
		    		} else {
		    			Logger.Log(user.getName(), "Attempted to sell " + sellQuantity + " of asset " + sellAssetId + " for " + sellOwner);
		    		}
		    		this.submitSellRequest(user, sellAssetId, sellOption, sellQuantity, sellOwner);
		    		break;
		    	default:
		    		Logger.Log(user.getName(), "Tried to ask for " + requestId + " from MarketMultiHandler");
		        	ISFSObject errObj = SFSObject.newInstance();
		        	errObj.putUtfString("message", "Unable to action request "+requestId);
		        	send("marketError", errObj, user);
		        	break;
		    }
	    } catch (Exception e) {
	    	ISFSObject errObj = SFSObject.newInstance();
	    	String message = "There has been a problem with request " + requestId + ": " +e.getMessage() ;
 			errObj.putUtfString("message", message);
 			Logger.ErrorLog("MarketMultiHandler.handleClientRequest(" + requestId + ")", message);
 			send(requestId + "_error", errObj, user);
	    }

	}
	private void managerMarketAssets(User user) throws Exception{

		PlayerChar pc = UserHelper.fetchUserPC(user);
		
		MarketAssetFactory maf = new MarketAssetFactory();
		Game game = pc.getGame();
		Set<MarketAsset> marketAssets = maf.fetchMarketAssets(game);
		
		SFSArray outputArray = SFSArray.newInstance();
		
		if(marketAssets==null || marketAssets.size() == 0){
			//There aren't any set up for this game yet. (Might move this later)
			marketAssets = maf.createGameMarketAssets(game);
		}
		for (MarketAsset marketAsset : marketAssets){
			SFSObject assetObject = translateMarketAsset(marketAsset);
			outputArray.addSFSObject(assetObject);
		}
		
		SFSObject sendObject = SFSObject.newInstance();
		sendObject.putSFSArray("AssetDetails", outputArray);
		send("ManagerMarketAssetDetails", sendObject, user);
	}
	private void playerMarketAssets(User user) throws Exception {		
		SFSObject sendObject = wrapMarketAssets(user);
		send("InStockMarketAssetDetails", sendObject, user);
	}
	
	private void playerCurrentAssets(User user) throws Exception {
		//Tricky. Do they have access to the whole hearth asset list? Or just theirs specifically? 
		
		AssetFactory assetFactory = new AssetFactory();
		PlayerChar pc = UserHelper.fetchUserPC(user);
		HearthFactory hf = new HearthFactory();
		Hearth hearth = pc.getHearth();
		if(hearth!=null){
			hearth = hf.fetchHearth(hearth.getId());
		}
				
		
		Set<Asset> assets = assetFactory.fetchAssets();
		SFSArray pcAssetsArray = SFSArray.newInstance();
		SFSArray hearthAssetsArray = SFSArray.newInstance();
		for(Asset asset: assets){
			Double playerAmount = asset.fetchAmountPlayerOwns(pc);
			if(playerAmount != null){
				
				SFSObject pcAsset = translatePrivateAssets(asset.fetchAmountPlayerOwns(pc), asset.getId(), "P", null);
				pcAssetsArray.addSFSObject(pcAsset);
			}
			if(hearth!=null){
				Double hearthAmount = asset.fetchAmountHearthOwn(hearth);
				if(hearthAmount!=null){
					List<TaskOption> sellOptions = asset.fetchHearthSellOptions(hearth);
					SFSObject hearthAsset = translatePrivateAssets(asset.fetchAmountHearthOwn(hearth), asset.getId(), "H", sellOptions);
					hearthAssetsArray.addSFSObject(hearthAsset);
				}
			}
		}
		
		SFSObject sendObject = SFSObject.newInstance();
		sendObject.putSFSArray("PCAssetDetails", pcAssetsArray);
		sendObject.putSFSArray("hearthAssetDetails", hearthAssetsArray);
		send("PlayerMarketAssetDetails", sendObject, user);
	}
	
	private void updateMarketAsset(User user, ISFSObject params) throws Exception {
		Integer assetId = params.getInt("Id");
		Double newAmount = params.getDouble("Amount");
		Double newBuyPrice = params.getDouble("BuyPrice");
		Double newSellPrice = params.getDouble("SellPrice");
		//TODO: Add a whole load of checking here - 
		MarketAssetFactory maf = new MarketAssetFactory();
		MarketAsset ma = maf.fetchMarketAsset(assetId);
		if(ma != null){
			ma.setAmount(newAmount);
			ma.setBuyPrice(newBuyPrice);
			ma.setSellPrice(newSellPrice);
			ma.save();
		}
	}
	private void submitBuyRequest(User user, Integer assetId, Double quantity, String owner) throws Exception {
		PlayerChar pc = UserHelper.fetchUserPC(user);
		GameFactory gf = new GameFactory();
		Game game = gf.fetchGame(pc.getGame().getId());
		
		AssetFactory af = new AssetFactory();
		Asset asset = af.fetchAsset(assetId);
		
		String successMessage = "You tried to buy " + quantity.intValue() + " " + asset.getMeasurement() + "(s) of " + asset.getName() + "\n";
		
		//First check there's enough in the market for this. 
		MarketAsset marketAsset = asset.fetchMarketAsset(game);
		
		Double marketAssetAmount = marketAsset.getAmount();
		if(marketAssetAmount<quantity){
			//Reduce the amount you're trying to sell to what's available.
			quantity = marketAssetAmount;
			successMessage += "Sadly, the market only had " + quantity.intValue() + " \n";
		}
		
		Asset cash = af.fetchAsset(8);
		Double marketAssetSellPrice = marketAsset.getSellPrice();
		SFSObject messageObj = SFSObject.newInstance();
		
		if(owner.equals("H")){
			HearthFactory hearthFactory = new HearthFactory();
			Hearth household = hearthFactory.fetchHearth(pc.getHearth().getId());
			Double householdCashAmount = cash.fetchAmountHearthOwn(household);
			Double maxPurchase = Math.floor(householdCashAmount/marketAssetSellPrice);
			if(maxPurchase < quantity){
				//Reduce the amount you can buy to what they can afford. 
				quantity = maxPurchase;
				successMessage += "You didn't quite have enough cash (" + householdCashAmount + " Afris) for that. \n";
				
			}
			quantity = asset.buyAssetAmount(household, quantity);
			if(quantity>0){
				successMessage += "You have purchased "+ quantity.intValue() + " " + asset.getMeasurement() + "(s) of " + asset.getName() + " for your hearth";
			} else {
				successMessage += "You have been unable to buy any " + asset.getName() + " at this time.";
			}
			//Update the list of personal assets for the family
			List<User> family = GameHelper.fetchOnlineHearthUsers(this.getApi(), household);
			SFSArray familyAssetsArray = SFSArray.newInstance();
			familyAssetsArray.addSFSObject(translatePrivateAssets(cash.fetchAmountHearthOwn(household), cash.getId(), owner, null));
			familyAssetsArray.addSFSObject(translatePrivateAssets(asset.fetchAmountHearthOwn(household), asset.getId(), owner, asset.fetchHearthSellOptions(household)));
			
			SFSObject familyAssets = SFSObject.newInstance();
			familyAssets.putSFSArray("HearthAssets", familyAssetsArray);
			send("HearthAssetsUpdated", familyAssets, family);
			updateHouseholdBankOverview(household, game);
		}

		messageObj.putUtfString("message", successMessage);
		send("buy_request_success", messageObj, user);
		SFSObject marketAssets = wrapMarketAssets(user);
		//Need to get all the players in the market place. 
		List<User> marketeers = GameHelper.fetchMarketUsers(this.getParentExtension().getParentZone(), game);
		send("marketAssetUpdate", marketAssets, marketeers);
	}
	private void submitSellRequest(User user, Integer assetId, Integer optionId, Double quantity, String owner) throws Exception {
		PlayerChar pc = UserHelper.fetchUserPC(user);
		GameFactory gf = new GameFactory();
		Game game = gf.fetchGame(pc.getGame().getId());
		
		AssetFactory af = new AssetFactory();
		Asset cash = af.fetchAsset(Asset.CASH);
		Asset sellAsset = af.fetchAsset(assetId);
		SFSObject messageObj = SFSObject.newInstance();
		
		String successMessage = "";
		if(owner.equals("H")){
			HearthFactory hf = new HearthFactory();
			Hearth hearth = hf.fetchHearth(pc.getHearth().getId());
			Double initialCashAmount = cash.fetchAmountHearthOwn(hearth);
			if((optionId==null||optionId==0)&&quantity>0){
				//AssetOwner sellAssetOwner = aof.fetchSpecificAsset(hearth, sellAsset);
				successMessage = "You tried to sell " + quantity.intValue() + " " + sellAsset.getMeasurement() + "(s) of " + sellAsset.getName() + " to the market.\n";
				quantity = sellAsset.sellAssetAmount(hearth, quantity);
				if(quantity>0){
					successMessage += "You have successfully sold " + quantity.toString() + " " + sellAsset.getMeasurement() + "(s) of " + sellAsset.getName() + " for your hearth.\n";
					Double cashAmount = cash.fetchAmountHearthOwn(hearth) - initialCashAmount;
					successMessage += "The market has paid you " + cashAmount.intValue() + " " + cash.getMeasurement() + "s";
				} else {
					successMessage += "You have been unable to sell any of " + sellAsset.getName();
				}
			} else if(optionId!=null&&optionId>0) {
				sellAsset.sellSpecificAsset(hearth, optionId);
				successMessage += "You have successfully sold your " + sellAsset.getName() + ".\n";
				Double cashAmount = cash.fetchAmountHearthOwn(hearth) - initialCashAmount;
				successMessage += "The market has paid you " + cashAmount.intValue() + " " + cash.getMeasurement() + "s";
			} else {
				successMessage += "You have been unable to sell any of " + sellAsset.getName();
			}
			//Update the list of personal assets for the family
			List<User> family = GameHelper.fetchOnlineHearthUsers(this.getApi(), hearth);
			SFSArray familyAssetsArray = SFSArray.newInstance();
			familyAssetsArray.addSFSObject(translatePrivateAssets(cash.fetchAmountHearthOwn(hearth), cash.getId(), owner, null));
			familyAssetsArray.addSFSObject(translatePrivateAssets(sellAsset.fetchAmountHearthOwn(hearth), sellAsset.getId(), owner, sellAsset.fetchHearthSellOptions(hearth)));
			SFSObject familyAssets = SFSObject.newInstance();
			familyAssets.putSFSArray("HearthAssets", familyAssetsArray);
			send("HearthAssetsUpdated", familyAssets, family);
		}
		messageObj.putUtfString("message", successMessage);
		send("sell_request_success", messageObj, user);
		
		//Update the list of market assets for the whole game.
		SFSObject marketAssets = wrapMarketAssets(user);
		List<User> marketeers = GameHelper.fetchMarketUsers(this.getParentExtension().getParentZone(), game);
		send("marketAssetUpdate", marketAssets, marketeers);
	}
	private SFSObject translateMarketAsset(MarketAsset marketAsset){
		SFSObject output = SFSObject.newInstance();
		output.putInt("Id", marketAsset.getId());
		output.putInt("Asset", marketAsset.getAsset().getId());
		output.putDouble("BuyPrice", marketAsset.getBuyPrice());
		output.putDouble("SellPrice", marketAsset.getSellPrice());
		output.putDouble("Amount", marketAsset.getAmount());
		return output;
	}
	private SFSObject translatePrivateAssets(Double amount, Integer assetId, String owner, List<TaskOption> sellOptions){
		SFSObject output = SFSObject.newInstance();
		//output.putInt("Id", ao.getId());
		output.putDouble("Amount", amount);
		output.putInt("Asset", assetId);
		output.putUtfString("Owner", owner);
		if(sellOptions==null){
			output.putNull("SellOptions");
		} else {
			SFSArray optionArray = SFSArray.newInstance();
			for (TaskOption to: sellOptions){
				SFSObject option = translateTaskOptionToSFSObject(to);
				optionArray.addSFSObject(option);
			}
			output.putSFSArray("SellOptions", optionArray);
		}
		return output;
	}
	private SFSObject wrapMarketAssets(User user) throws Exception {
		AssetFactory assetFactory = new AssetFactory();
		Game game = UserHelper.fetchUserGame(user);
		PlayerChar pc = UserHelper.fetchUserPC(user);
		Hearth hearth = pc.getHearth();
		
		SFSArray outputArray = SFSArray.newInstance();
		
		Set<Asset> assets = assetFactory.fetchAssets();
		for(Asset asset: assets){
			MarketAsset marketAsset = asset.fetchMarketAsset(game);
			if(marketAsset!=null){	// If an asset is not in the market (e.g. cash) it should be null.
				SFSObject assetObject = translateMarketAsset(marketAsset);
				if(hearth!=null){
					List<TaskOption> buyOptions = asset.fetchHearthBuyOptions(hearth);
					if(buyOptions==null){
						//At the moment it always will..
						assetObject.putNull("BuyOptions");
					} else {
						SFSArray optionArray = SFSArray.newInstance();
						for (TaskOption to: buyOptions){
							SFSObject option = translateTaskOptionToSFSObject(to);
							optionArray.addSFSObject(option);
						}
						assetObject.putSFSArray("BuyOptions", optionArray);
					}
				} else {
					assetObject.putNull("BuyOptions");
					assetObject.putNull("SellOptions");
				}
				outputArray.addSFSObject(assetObject);
			}
		}
		SFSObject sendObject = SFSObject.newInstance();
		sendObject.putSFSArray("AssetDetails", outputArray);
		return sendObject;
	}
	private void updateHouseholdBankOverview(Hearth hearth, Game game){
		User bankerUser = GameHelper.fetchBankerFromBank(getApi(), game);
		if(bankerUser==null){
			//Don't bother with the rest of this, the banker isn't in the bank.
			return;
		}
		
		AssetOwnerFactory aoFactory = new AssetOwnerFactory();
		MarketAssetFactory maFactory = new MarketAssetFactory();
		SFSObject hearthDetail = SFSObject.newInstance();
		hearthDetail.putInt("HearthId", hearth.getId());
		Set<MarketAsset> marketAssets = null;
		try {
			marketAssets = maFactory.fetchMarketAssets(game);
		} catch (Exception e) {
			Logger.ErrorLog("MarketMultiHandler.updateHouseholdBankOverview", "Problem getting the market assets for game " + game.getGameName() + ": " + e.getMessage());
		}
		try{
			Double assetValue = 0.0;
			Double cashValue = 0.0;
			Set<AssetOwner> hearthAssets = aoFactory.fetchHearthAssets(hearth);
			for(AssetOwner hearthAsset: hearthAssets){
				Integer assetId = hearthAsset.getAsset().getId();
				//This is a list of non-cash assets.
				if(!assetId.equals(Asset.CASH)){
					Iterator<MarketAsset> maIterator = marketAssets.iterator();
					Boolean notFound = true;
					MarketAsset ma = null;
					while(maIterator.hasNext()&&notFound){
						ma = maIterator.next();
						if(ma.getAsset().getId().equals(assetId)){
							notFound = false;
						}
					}
					if(!notFound){
						assetValue += ma.getBuyPrice() * hearthAsset.getAmount();
					}
				} else {
					cashValue += hearthAsset.getAmount();
				}
			}
			hearthDetail.putDouble("HearthCash", cashValue);
			hearthDetail.putDouble("HearthAssets", assetValue);
			
		} catch (Exception e) {
			Logger.ErrorLog("BankMultiHandler.fetchManagerOverview", "Problem calculating cash value for hearth " + hearth.getId() + "'s assets: " + e.getMessage());
			hearthDetail.putDouble("HearthCash", 0);
			hearthDetail.putDouble("HearthAssets", 0);
		}
		send("GMHouseholdBankAssetsUpdated", hearthDetail, bankerUser);
	}
	private SFSObject translateTaskOptionToSFSObject(TaskOption to) {
		SFSObject toObj = SFSObject.newInstance();
		toObj.putInt("Value", to.getValue());
		toObj.putUtfString("Name", to.getName());
		toObj.putUtfString("Type", to.getType());
		toObj.putInt("Status", to.getStatus());
		switch (to.getStatus()){
			case TaskOption.VALID:
				toObj.putNull("Notes");
				break;
			case TaskOption.INVALID:
				toObj.putUtfString("Notes", to.getNotes());
				break;
		}
		return toObj;
	}
}
