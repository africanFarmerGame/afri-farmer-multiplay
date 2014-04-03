/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.gameEvents;

import java.util.Iterator;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;

abstract public class CoreClaimOutstandingFinesEvent extends GameEvent {

	public CoreClaimOutstandingFinesEvent(Game game) {
		super(game);
	}

	@Override
	abstract public void fireEvent() throws Exception;
	
	protected void claimFines(String fineType) throws Exception{
		//Get a list of hearths. 
		HearthFactory hf = new HearthFactory();
		Set<Hearth> hearths = hf.fetchGameHearths(game);
		AssetFactory assetFactory = new AssetFactory();
		List<Asset> coreAssets = assetFactory.fetchAssetsForReclamation();
		BillFactory finesFactory = new BillFactory();
		AssetOwnerFactory assetOwnerFactory = new AssetOwnerFactory();
		MarketAssetFactory marketAssetFactory = new MarketAssetFactory();
		Set<MarketAsset> marketAssets = marketAssetFactory.fetchMarketAssets(game);
		//For each hearth get a list of outstanding fines
		for(Hearth hearth: hearths){
			List<Bill> fines = finesFactory.fetchOutstandingHearthFines(hearth, fineType);
			Iterator<Bill> fineIterator = fines.iterator();
			Set<AssetOwner> assetsOwned = assetOwnerFactory.fetchHearthAssets(hearth);
			Boolean hasAssets = true;
			while(hasAssets && fineIterator.hasNext()){
				//For each fine try to pay it by going through the assets
				Bill fine = fineIterator.next();
				Iterator<Asset> assetIterator = coreAssets.iterator();
				double outstandingAmount = fine.getLateRate();
				while(outstandingAmount>0 && assetIterator.hasNext()){
					//For each asset, get the assetOwner.
					Asset asset = assetIterator.next();
					Integer assetId = asset.getId();
					AssetOwner assetOwned = pickAssetOwner(assetsOwned, assetId);
					//If they have any, find out what it's worth.
					if(assetOwned != null && assetOwned.getAmount()>0){
						Double assetPrice;
						if(assetId.equals(Asset.CASH)){
							assetPrice = (double) 1;
						} else {
							MarketAsset marketAsset = pickMarketAsset(marketAssets, assetId);
							if(marketAsset!=null){
								assetPrice = marketAsset.getBuyPrice();
							} else {
								assetPrice = (double) 0;
							}
						}
						if(assetPrice>0){
							//Calculate number of asset needed to pay off the fine. 
							double requiredAsset = Math.ceil(outstandingAmount / assetPrice);
							double assetAmount = assetOwned.getAmount();
							if(assetAmount>=requiredAsset){
								//If they have this number, claim them.
								assetOwned.setAmount(assetAmount - requiredAsset);
								//Set outstanding amount to zero.
								outstandingAmount = (double) 0;
							} else {
								//Otherwise take what they have.
								assetOwned.setAmount((double) 0);
								//Decrement outstanding amount.
								outstandingAmount = outstandingAmount - assetAmount*assetPrice;
							}
							assetOwned.save();
						}
					}
				}
				if(outstandingAmount>0){
					//They can't have anything left, or it would have been taken.
					hasAssets = false;
				} else {
					fine.payBill();
				}
			}
		}
	}
	private AssetOwner pickAssetOwner(Set<AssetOwner> assetsOwned, Integer assetId){
		AssetOwner assetOwned = null;
		Iterator<AssetOwner> aoIterator = assetsOwned.iterator();
		while((assetOwned==null)&&aoIterator.hasNext()){
			AssetOwner nextAssetOwned = aoIterator.next();
			if(nextAssetOwned.getAsset().getId().equals(assetId)){
				assetOwned = nextAssetOwned;
			}
		}
		return assetOwned;
	}
	
	private MarketAsset pickMarketAsset(Set<MarketAsset> marketAssets, Integer assetId){
		MarketAsset marketAsset = null;
		Iterator<MarketAsset> maIterator = marketAssets.iterator();
		while((marketAsset==null)&&maIterator.hasNext()){
			MarketAsset nextMarketAsset = maIterator.next();
			if(nextMarketAsset.getAsset().getId().equals(assetId)){
				marketAsset = nextMarketAsset;
			}
		}
		return marketAsset;
	}
}
