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
