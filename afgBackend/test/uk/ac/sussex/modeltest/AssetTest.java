/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.Test;

import uk.ac.sussex.model.Asset;
import uk.ac.sussex.model.AssetFactory;
import uk.ac.sussex.model.AssetOwner;
import uk.ac.sussex.model.AssetOwnerFactory;
import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.HearthFactory;
import uk.ac.sussex.model.MarketAsset;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;
import uk.ac.sussex.model.tasks.TaskOption;

public class AssetTest {

	@Test
	public void testFetchAmountHearthOwn() {
		fail("Not yet implemented");
	}

	@Test
	public void testBuyAssetAmount() {
		Asset cash = fetchAsset("Cash");
		Asset land = fetchAsset("Land");
		//Asset beans = fetchAsset("Beans");
		
		Hearth hearth = fetchHearth(3);
		MarketAsset landMa = null;
		try {
			landMa = land.fetchMarketAsset(hearth.getGame());
		} catch (Exception e1) {
			e1.printStackTrace();
			fail("Fetching land MA");
		}
		try{
			AssetOwnerFactory aof = new AssetOwnerFactory();
			AssetOwner cashOwner = aof.fetchSpecificAsset(hearth, cash);
			cashOwner.setAmount(cashOwner.getAmount() + 2*landMa.getSellPrice());
			cashOwner.save();
		} catch(Exception e){
			e.printStackTrace();
			fail("Increasing cash");
		}
		
		Double initialCash = null;
		try {
			initialCash = cash.fetchAmountHearthOwn(hearth);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			fail("initial cash");
		}
		Double initialLand = null;
		try {
			initialLand = land.fetchAmountHearthOwn(hearth);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			fail("Initial land");
		}
		try {
			@SuppressWarnings("unused")
			Double quantity = land.buyAssetAmount(hearth, 2.0);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			fail("buy");
		}
		Double finalCash = null;
		try {
			finalCash = cash.fetchAmountHearthOwn(hearth);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			fail("final cash");
		}
		Double finalLand = null;
		try {
			finalLand = land.fetchAmountHearthOwn(hearth);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			fail("final land");
		}
		assertTrue(finalCash<initialCash);
		assertTrue(finalLand == initialLand+2);
	}
	@Test
	public void testFetchAmountPlayerOwns() {
		Asset cash = fetchAsset("Cash");
		Asset land = fetchAsset("Land");
		//Asset manure = fetchAsset("Manure");
		//Asset beans = fetchAsset("Beans");
		
		PlayerChar noAssets = fetchPC(3);
		Double cashAmount = null;
		try {
			cashAmount = cash.fetchAmountPlayerOwns(noAssets);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem with cash.");
		}
		assertNull(cashAmount);
		
		Double landAmount = null;
		try {
			landAmount = land.fetchAmountPlayerOwns(noAssets);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem with land.");
		}
		assertNotNull(landAmount);
		assertEquals((Double)0.0, landAmount);
	}

	@Test
	public void testFetchMarketAsset() {
		Asset cash = fetchAsset("Cash");
		Asset land = fetchAsset("Land");
		Asset manure = fetchAsset("Manure");
		Asset beans = fetchAsset("Beans");
		
		Game game = fetchGame(1);
		
		MarketAsset cashMA = null;
		try {
			cashMA = cash.fetchMarketAsset(game);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to fetch cash MA");
		}
		assertNull(cashMA);
		
		MarketAsset landMA = null;
		try {
			landMA = land.fetchMarketAsset(game);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to fetch land MA");
		}
		assertNotNull(landMA);
		assertEquals(landMA.getAsset().getId(), land.getId());
		
		MarketAsset manureMA = null;
		try {
			manureMA = manure.fetchMarketAsset(game);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to fetch manure MA");
		}
		assertNotNull(manureMA);
		assertEquals(manureMA.getAsset().getId(), manure.getId());
		
		MarketAsset beansMA = null;
		try {
			beansMA = beans.fetchMarketAsset(game);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to fetch beans MA");
		}
		assertNotNull(beansMA);
		assertEquals(beansMA.getAsset().getId(), beans.getId());
	}
	@Test 
	public void testFetchHearthBuyOptions() {
		Hearth hearth = fetchHearth(1);
		Asset cash = fetchAsset("Cash");
		Asset land = fetchAsset("Land");
		Asset manure = fetchAsset("Manure");
		Asset beans = fetchAsset("Beans");
		List<TaskOption> cashOptions = null;
		try {
			cashOptions = cash.fetchHearthBuyOptions(hearth);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to fetch cash options");
		}
		assertNull(cashOptions);
		
		List<TaskOption> landOptions = null;
		try {
			landOptions = land.fetchHearthBuyOptions(hearth);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to fetch land options");
		}
		assertNull(landOptions);
		
		List<TaskOption> manureOptions = null;
		try {
			manureOptions = manure.fetchHearthBuyOptions(hearth);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to fetch manure options");
		}
		assertNull(manureOptions);
		
		List<TaskOption> beansOptions = null;
		try {
			beansOptions = beans.fetchHearthBuyOptions(hearth);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to fetch beans options");
		}
		assertNull(beansOptions);
	}
	@Test 
	public void testFetchHearthSellOptions() {
		Hearth hearth = fetchHearth(1);
		Asset cash = fetchAsset("Cash");
		Asset land = fetchAsset("Land");
		Asset manure = fetchAsset("Manure");
		Asset beans = fetchAsset("Beans");
		List<TaskOption> cashOptions = null;
		try {
			cashOptions = cash.fetchHearthSellOptions(hearth);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to fetch cash options");
		}
		assertNull(cashOptions);
		
		List<TaskOption> landOptions = null;
		try {
			landOptions = land.fetchHearthSellOptions(hearth);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to fetch land options");
		}
		assertNotNull(landOptions);
		
		List<TaskOption> manureOptions = null;
		try {
			manureOptions = manure.fetchHearthSellOptions(hearth);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to fetch manure options");
		}
		assertNull(manureOptions);
		
		List<TaskOption> beansOptions = null;
		try {
			beansOptions = beans.fetchHearthSellOptions(hearth);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to fetch beans options");
		}
		assertNull(beansOptions);
	}
	private Asset fetchAsset(String assetName){
		Asset asset = null;
		AssetFactory assetFactory = new AssetFactory();
		try {
			asset = assetFactory.fetchAsset(assetName);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to fetch asset " + assetName);
		}
		return asset;
	}
	private Game fetchGame(Integer gameId){
		Game game = null;
		GameFactory gf = new GameFactory();
		try {
			game = gf.fetchGame(gameId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to fetch game " + gameId);
		}
		return game;
	}
	private Hearth fetchHearth(Integer hearthId){
		Hearth hearth = null;
		HearthFactory hf = new HearthFactory();
		try {
			hearth = hf.fetchHearth(hearthId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to fetch hearth");
		}
		return hearth;
	}
	private PlayerChar fetchPC(Integer pcId){
		PlayerChar pc = null;
		PlayerCharFactory pcf = new PlayerCharFactory();
		try {
			pc = pcf.fetchPlayerChar(pcId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("No pc.");
		}
		return pc;
	}
}
