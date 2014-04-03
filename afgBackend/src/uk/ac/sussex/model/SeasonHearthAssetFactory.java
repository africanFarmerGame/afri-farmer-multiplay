package uk.ac.sussex.model;

import java.util.Set;

import uk.ac.sussex.model.base.BaseFactory;

public class SeasonHearthAssetFactory extends BaseFactory {

	public SeasonHearthAssetFactory() {
		super(new SeasonHearthAsset());
	}
	public void generateSeasonHearthAssets(Hearth hearth, SeasonDetail sd) throws Exception {
		AssetOwnerFactory aof = new AssetOwnerFactory();
		Set<AssetOwner> assets = aof.fetchHearthAssets(hearth);
		for(AssetOwner asset: assets){
			SeasonHearthAsset sha = new SeasonHearthAsset();
			sha.setSeason(sd);
			sha.setHearth(hearth);
			sha.setAsset(asset.getAsset());
			sha.setAmount(asset.getAmount());
			sha.save();
		}
	}
}
