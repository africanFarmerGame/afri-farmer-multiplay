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
