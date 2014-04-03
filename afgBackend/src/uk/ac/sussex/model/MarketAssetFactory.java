/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.base.BaseFactory;
import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.model.base.RestrictionList;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.utilities.Logger;

public class MarketAssetFactory extends BaseFactory {

	public MarketAssetFactory() {
		super(new MarketAsset());
	}
	public Set<MarketAsset> fetchMarketAssets(Game game) throws Exception{
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("game", game);
		List<BaseObject> objects = this.fetchManyObjects(restrictions);
		Set<MarketAsset> assets = new HashSet<MarketAsset>();
		for (BaseObject object : objects ) {
			assets.add((MarketAsset) object);
		}
		return assets;
	}
	public Set<MarketAsset> fetchInStockAssets(Game game) throws Exception {
		AssetFactory af = new AssetFactory();
		Set<Asset> nonMarketAssets = af.fetchNonMarketAssets();
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("game", game);
		if(nonMarketAssets != null){
			for(Asset nonMarketAsset : nonMarketAssets){
				restrictions.addNotEqual("asset", nonMarketAsset);
			}
		}
		List<BaseObject> objects = this.fetchManyObjects(restrictions);
		Set<MarketAsset> assets = new HashSet<MarketAsset>();
		for (BaseObject object : objects ) {
			assets.add((MarketAsset) object);
		}
		return assets;
	}
	public MarketAsset fetchMarketAsset(Integer marketAssetId) throws Exception {
		return (MarketAsset) this.fetchSingleObject(marketAssetId);
	}
	public MarketAsset fetchMarketAssetbyAsset(Asset asset, Game game) throws Exception {
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("game", game);
		restrictions.addEqual("asset", asset);
		List<BaseObject> objects = this.fetchManyObjects(restrictions);
		if(objects.size() < 1){
			throw new Exception("No market asset record found for asset " + asset.getId()+ " in game " + game.getGameName() );
		} else if (objects.size() > 1) {
			throw new Exception("Too many market asset records found for asset " + asset.getId() + " in game " + game.getGameName() );
		} else {
			return (MarketAsset) objects.iterator().next();
		}
	}
	public Set<MarketAsset> createGameMarketAssets(Game game) throws Exception{
		Logger.Log("Internal", "MarketMultiHandler sez: Generating initial market assets");
		AssetFactory af = new AssetFactory();
		Set<Asset> baseAssets = af.fetchMarketAssets();
		Set<MarketAsset> marketAssets = new HashSet<MarketAsset>();
		for (Asset asset: baseAssets){
			MarketAsset ma = new MarketAsset();
			ma.setGame(game);
			ma.setAsset(asset);
			ma.setAmount(asset.getInitialStock());
			ma.setBuyPrice(asset.getGuideBuyPrice());
			ma.setSellPrice(asset.getGuideSellPrice());
			ma.save();
			marketAssets.add(ma);
		}
		return marketAssets;
	}
}
