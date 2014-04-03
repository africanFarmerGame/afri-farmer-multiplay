package uk.ac.sussex.model;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.base.BaseFactory;
import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.model.base.OrderList;
import uk.ac.sussex.model.base.RestrictionList;

public class AssetFactory extends BaseFactory {
	public AssetFactory() {
		super(new Asset());
	}
	public Asset fetchAsset(String name) throws Exception {
		RestrictionList rl = new RestrictionList();
		rl.addEqual("name", name);
		List<BaseObject> objects = this.fetchManyObjects(rl);
		if(objects.size() > 1){
			throw new Exception("Multiple assets with that name.");
		}
		if(objects.size() < 1){
			throw new Exception("No assets with that name.");
		}
		return (Asset) objects.get(0);
	}
	public Set<Asset> fetchAssets() throws Exception {
		RestrictionList rl = new RestrictionList();
		List<BaseObject> objects = this.fetchManyObjects(rl);
		Set<Asset> assets = new HashSet<Asset>();
		for (BaseObject object : objects ) {
			assets.add((Asset) object);
		}
		return assets;
	}
	public Set<AssetFood> fetchFoodAssets() throws Exception {
		RestrictionList rl = new RestrictionList();
		List <BaseObject> objects = this.fetchManySubclassObjects(new AssetFood(), rl);
		Set<AssetFood> foodAssets = new HashSet<AssetFood>();
		for(BaseObject object : objects){
			foodAssets.add((AssetFood) object);
		}
		return foodAssets;
	}
	public Set<AssetCrop> fetchCropAssets() throws Exception {
		RestrictionList rl = new RestrictionList();
		List <BaseObject> objects = this.fetchManySubclassObjects(new AssetCrop(), rl);
		Set<AssetCrop> cropAssets = new HashSet<AssetCrop>();
		for (BaseObject object :objects) {
			cropAssets.add((AssetCrop) object);
		}
		return cropAssets;
	}
	public Asset fetchAsset(Integer id) throws Exception {
		return (Asset) this.fetchSingleObject(id);
	}
	public Set<Asset> fetchFertilisers() throws Exception {
		RestrictionList rl = new RestrictionList();
		rl.addEqual("type", "FERTILISER");
		List <BaseObject> objects = this.fetchManyObjects(rl);
		Set<Asset> fertilisers = new HashSet<Asset>();
		for (BaseObject object: objects){
			fertilisers.add((Asset) object);
		}
		return fertilisers;
	}
	public Set<Asset> fetchMarketAssets() throws Exception {
		RestrictionList rl = new RestrictionList();
		rl.addNotEqual("type", "CASH");
		List<BaseObject> objects = this.fetchManyObjects(rl);
		Set<Asset> marketAssets = new HashSet<Asset>();
		for(BaseObject object : objects) {
			marketAssets.add((Asset)object);
		}
		return marketAssets;
	}
	public Set<Asset> fetchNonMarketAssets() throws Exception{
		//At the moment, this is going to be cash.
		RestrictionList rl = new RestrictionList();
		rl.addEqual("type", "CASH");
		List<BaseObject> objects = this.fetchManyObjects(rl);
		Set<Asset> nonMarketAssets = new HashSet<Asset>();
		for (BaseObject object : objects) {
			nonMarketAssets.add((Asset) object);
		}
		return nonMarketAssets;
	}
	public Set<Asset> fetchHerbicide() throws Exception {
		RestrictionList rl = new RestrictionList();
		rl.addEqual("type", "HERBICIDE");
		List<BaseObject> objects = this.fetchManyObjects(rl);
		Set<Asset> herbicides = new HashSet<Asset>();
		for (BaseObject object: objects){
			herbicides.add((Asset) object);
		}
		return herbicides;
	}
	public Set<Asset> fetchInsecticide() throws Exception {
		RestrictionList rl = new RestrictionList();
		rl.addEqual("type", "INSECTICIDE");
		List<BaseObject> objects = this.fetchManyObjects(rl);
		Set<Asset> insecticides = new HashSet<Asset>();
		for(BaseObject object: objects){
			insecticides.add((Asset) object);
		}
		return insecticides;
	}
	public FertiliserCropEffect fetchFertiliserCropEffect(Asset fertiliser, Asset crop) throws Exception{
		RestrictionList rl = new RestrictionList();
		rl.addEqual("fertiliser", fertiliser);
		rl.addEqual("crop", crop);
		List<BaseObject> effects = this.fetchManySubclassObjects(new FertiliserCropEffect(), rl);
		if(effects.size()<1){
			throw new Exception("No matching fertiliser crop effect for fertiliser " + fertiliser.getId() + " and crop " + crop.getId());
		} else if (effects.size()>1){
			throw new Exception("Too many matching fertiliser crop effects for fertiliser " + fertiliser.getId() + " and crop " + crop.getId());
		} else {
			return (FertiliserCropEffect) effects.iterator().next();
		}
		
	}
	public List<Asset> fetchAssetsForReclamation() throws Exception {
		RestrictionList rl = new RestrictionList();
		OrderList order = new OrderList();
		order.addAscending("reclaimOrder");
		List<BaseObject> objects = this.fetchManyObjects(rl, order);
		List<Asset> assets = new ArrayList<Asset>();
		for(BaseObject object: objects){
			assets.add((Asset) object);
		}
		return assets;
	}
}
