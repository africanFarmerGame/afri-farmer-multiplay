/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import java.util.Set;

import org.junit.Test;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;

public class MarketAssetFactoryTest {

	@Test
	public void testFetchMarketAssets() {
		GameFactory gf = new GameFactory();
		Game game = null;
		try {
			game = gf.fetchGame(1);
		} catch (Exception e){
			e.printStackTrace();
			fail("Problem with the gamefactory");
		}
		
		MarketAssetFactory maf = new MarketAssetFactory();
		Set<MarketAsset> marketAssets = null;
		try {
			marketAssets = maf.fetchMarketAssets(game);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unexpected problem: " + e.getMessage());
		}
		assertFalse(marketAssets == null);
		assertFalse(marketAssets.size() == 0);
		AssetFactory af = new AssetFactory();
		for (MarketAsset marketAsset : marketAssets){
			assertFalse(marketAsset.getId()==null);
			Asset a = null;
			try {
				a = af.fetchAsset(marketAsset.getAsset().getId());
			} catch (Exception e) {
				e.printStackTrace();
				fail("Problem getting an asset.");
			}
			assertNotNull(a);
			assertFalse(a.getName()==null);
			assertFalse(a.getMeasurement()==null);
			assertFalse(a.getType()==null);
			assertFalse(a.getType().equals("CASH"));
			assertFalse(marketAsset.getBuyPrice()==null);
			assertFalse(marketAsset.getSellPrice()==null);
			assertFalse(marketAsset.getAmount()==null);
		}
	}

}
