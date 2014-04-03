/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.Asset;
import uk.ac.sussex.model.AssetOwner;
import uk.ac.sussex.model.base.BaseFactory;
import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.model.base.RestrictionList;

public class AssetOwnerFactory extends BaseFactory {
	public AssetOwnerFactory() {
		super(new AssetOwner());
	}
	//TODO: Check whether any of this asset is already owned and increase the amount rather than creating a new record. 
	public void assignOwnership(Hearth hearth, Asset asset, Double amount) throws Exception{
		AssetOwner ao = new AssetOwner();
		ao.setHearth(hearth);
		ao.setAmount(amount);
		ao.setAsset(asset);
		ao.save();
	}
	public void assignOwnership(PlayerChar pc, Asset asset, Double amount) throws Exception {
		AssetOwner ao = new AssetOwner();
		ao.setOwner(pc);
		ao.setAsset(asset);
		ao.setAmount(amount);
		ao.save();
	}
	/**
	 * This will accept an allChar rather than just a PlayerChar, and just return an
	 * empty set if they don't feature.
	 * @param pc
	 * @return
	 * @throws Exception
	 */
	public Set<AssetOwner> fetchPCAssets(AllChars pc) throws Exception {
		RestrictionList rl = new RestrictionList();
		rl.addEqual("owner", pc);
		List<BaseObject> objects = this.fetchManyObjects(rl);
		Set<AssetOwner> assets = new HashSet<AssetOwner>();
		for (BaseObject object: objects){
			assets.add((AssetOwner) object);
		}
		return assets;
	}
	public Set<AssetOwner> fetchHearthAssets(Hearth hearth) throws Exception {
		RestrictionList rl = new RestrictionList();
		rl.addEqual("hearth", hearth);
		List<BaseObject> objects = this.fetchManyObjects(rl);
		Set<AssetOwner> assets = new HashSet<AssetOwner>();
		for (BaseObject object: objects){
			assets.add((AssetOwner) object);
		}
		return assets;
	}
	public AssetOwner fetchSpecificAsset(Hearth hearth, Asset asset) throws Exception {
		RestrictionList rl = new RestrictionList();
		rl.addEqual("hearth", hearth);
		rl.addEqual("asset", asset);
		AssetOwner assetOwner = (AssetOwner) this.fetchSingleObjectByRestrictions(rl);
		return assetOwner;
	}
	public AssetOwner fetchSpecificPCAsset(PlayerChar pc, Asset asset) throws Exception {
		RestrictionList rl = new RestrictionList();
		rl.addEqual("owner", pc);
		rl.addEqual("asset", asset);
		AssetOwner assetOwner = (AssetOwner) this.fetchSingleObjectByRestrictions(rl);
		return assetOwner;
	}
}
