/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
