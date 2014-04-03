/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import java.util.List;
import java.util.Set;

import org.junit.Test;

import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;

import uk.ac.sussex.model.Asset;
import uk.ac.sussex.model.AssetCrop;
import uk.ac.sussex.model.AssetFactory;
import uk.ac.sussex.model.AssetFood;
import uk.ac.sussex.model.AssetOwner;
import uk.ac.sussex.model.AssetOwnerFactory;
import uk.ac.sussex.model.FertiliserCropEffect;
import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.HearthFactory;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;

public class AssetFactoryTest {
	/**
	 * Test method for {@link uk.ac.sussex.model.AssetFactory#fetchAsset(java.lang.String)}.
	 */
	@Test
	public void testFetchAsset() {
		AssetFactory af = new AssetFactory();
		try {
			Asset manure = af.fetchAsset("Manure");
			assertTrue(manure.getName().equals("Manure"));
		} catch (Exception e) {
			e.printStackTrace();
			fail(e.getMessage());
		}
	}
	/**
	 * Test method for {@link uk.ac.sussex.model.AssetFactory#fetchAssets()}.
	 */
	@Test
	public void testFetchAssets() {
		AssetFactory af = new AssetFactory();
		try {
			Set<Asset> assets = af.fetchAssets();
			assertFalse(assets == null);
			assertFalse(assets.size() == 0 );
			for(Asset asset:assets){
				System.out.println(asset.getName());
				System.out.println(asset.getClass());
				assertNotNull(asset.getId());
				assertNotNull(asset.getEdible());
				assertNotNull(asset.getGuideBuyPrice());
				assertNotNull(asset.getGuideSellPrice());
				assertNotNull(asset.getMeasurement());
				assertNotNull(asset.getName());
				assertNotNull(asset.getNotes());
				if(asset.getClass().getName() == "uk.ac.sussex.model.AssetFood"){
					AssetFood food = (AssetFood) asset;
					System.out.println("Testing carbs");
					assertNotNull(food.getCarbs());
				}
			}
			
		} catch (Exception e) {
			fail("Unexpected error: " + e.getMessage());
		}
	}
	@Test
	public void testFetchFoodAssets() {
		AssetFactory af = new AssetFactory();
		try {
			Set<AssetFood> foodAssets = af.fetchFoodAssets();
			assertFalse(foodAssets==null);
			assertFalse(foodAssets.size() == 0);
			for(Asset asset:foodAssets){
				System.out.println(asset.getName());
				System.out.println(asset.getClass());
			}
		}catch (Exception e) {
			fail("Unexpected error: "+ e.getMessage());
		}
	}
	
	@Test 
	public void testFetchCropAssets() {
		AssetFactory af = new AssetFactory();
		try {
			Set<AssetCrop> cropAssets = af.fetchCropAssets();
			assertFalse(cropAssets==null);
			assertFalse(cropAssets.size() == 0);
			for (Asset asset:cropAssets) {
				System.out.println(asset.getName());
				System.out.println(asset.getClass());
				System.out.println("Asset subtype: " + asset.getSubtype());
			}
		} catch (Exception e) {
			e.printStackTrace();
			fail ("Unexpected error: " + e.getMessage());
		}
	}
	@Test 
	public void testFetchNonMarketAssets() {
		AssetFactory af = new AssetFactory();
		Set<Asset> assets = null;
		try {
			assets = af.fetchNonMarketAssets();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem running the fetch");
		}
		assertNotNull(assets);
		assertEquals(1, assets.size());
	}
	@Test
	public void testFetchFertiliserCropEffect() {
		AssetFactory af = new AssetFactory();
		Asset fertiliser = null;
		try {
			fertiliser = af.fetchAsset(1);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem fetching manure");
		}
		Asset crop = null;
		try {
			crop = af.fetchAsset(7);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem fetching sorghum.");
		}
		FertiliserCropEffect fce = null;
		try {
			fce = af.fetchFertiliserCropEffect(fertiliser, crop);
		} catch (Exception e) {
			e.printStackTrace();
			fail("problem fetching fce");
		}
		assertNotNull(fce);
		
	}
	@Test
	public void testFetchHerbicide() {
		AssetFactory af = new AssetFactory();
		Set<Asset> herbicides = null;
		try {
			herbicides = af.fetchHerbicide();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get the herbicides");
		}
		assertNotNull(herbicides);
		for(Asset asset: herbicides){
			assertTrue(asset.getType().equals("HERBICIDE"));
		}
	}
	@Test
	public void testFetchInsecticides() {
		AssetFactory af = new AssetFactory();
		Set<Asset> insecticides = null;
		try {
			insecticides = af.fetchInsecticide();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get the insecticides");
		}
		assertNotNull(insecticides);
		assertTrue(insecticides.size() > 0);
		for(Asset asset: insecticides){
			assertTrue(asset.getType().equals("INSECTICIDE"));
		}
	}
	@Test
	public void testFetchAssetsForReclamation(){
		AssetFactory af = new AssetFactory();
		List<Asset> assets = null;
		try {
			assets = af.fetchAssetsForReclamation();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't fetch assets");
		}
		assertNotNull(assets);
		assertEquals(assets.size(), 14);
		assertEquals(assets.get(0).getId(), (Integer) 8);
	}
	@Test
	public void testFetchAssetAmount(){
		AssetFactory af = new AssetFactory();
		Hearth hearth = fetchHearth(1);
		Asset manure = null;
		try {
			manure = af.fetchAsset("Manure");
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get the shit");
		}
		Asset landAsset = null;
		try {
			landAsset = af.fetchAsset(15);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem fetching land asset");
		}
		Double amountLand = (double) 0;
		try{
			amountLand = landAsset.fetchAmountHearthOwn(hearth);
		} catch(Exception e) {
			e.printStackTrace();
			fail("changing amount didn't work");
		}
		System.out.println("Amount of land = " + amountLand);
		try{
			amountLand = landAsset.fetchAmountHearthOwn(hearth);
		} catch(Exception e) {
			e.printStackTrace();
			fail("changing amount didn't work");
		}
		System.out.println("Amount of land = " + amountLand);
		AssetOwner manureOwner = fetchAssetOwner(hearth, manure);
		Double manureAmount = (double) -1;
		try {
			manureAmount = manure.fetchAmountHearthOwn(hearth);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't count for shit.");
		}
		assertEquals(manureOwner.getAmount(), manureAmount);
		
	}
	private Hearth fetchHearth(Integer hearthId){
		HearthFactory hf = new HearthFactory();
		Hearth hearth = null;
		try {
			hearth = hf.fetchHearth(hearthId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unexpected problem fetching hearth " + hearthId);
		}
		return hearth;
	}
	private AssetOwner fetchAssetOwner(Hearth hearth, Asset asset){
		AssetOwnerFactory aof = new AssetOwnerFactory();
		AssetOwner owner = new AssetOwner();
		try {
			owner = aof.fetchSpecificAsset(hearth, asset);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't work out how much shit is owned.");
		}
		return owner;
	}
	@SuppressWarnings("unused")
	private PlayerChar fetchPlayerChar(Integer playerId) {
		PlayerCharFactory pcf = new PlayerCharFactory();
		PlayerChar playerChar = null;
		try {
			playerChar = pcf.fetchPlayerChar(playerId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't fetch the player");
		}
		return playerChar;
	}
	@Test
	public void TestGetAssets(){
		AssetFactory af = new AssetFactory();
		Set<Asset> assets = null;
		try{
			assets = af.fetchAssets();
		} catch (Exception e){
			e.printStackTrace();
			fail("There was a problem fetching the assets: " + e.getMessage());
		}
		//try {
			SFSArray assetsArray = SFSArray.newInstance();
			SFSArray foodAssetsArray = SFSArray.newInstance();
			SFSArray cropAssetsArray = SFSArray.newInstance();
			for (Asset asset: assets){
				SFSObject obj = SFSObject.newInstance();
				obj.putInt("Id", asset.getId());
				obj.putUtfString("Name", asset.getName());
				obj.putUtfString("Measurement", asset.getMeasurement());
				obj.putUtfString("Type", asset.getType());
				obj.putUtfString("Subtype", asset.getSubtype());
				obj.putInt("Edible", asset.getEdible());
				if(asset instanceof AssetFood){
					try {
						AssetFood food = (AssetFood) asset;
						obj.putInt("Protein", food.getProtein());
						obj.putInt("Carbs", food.getCarbs());
						obj.putInt("Nutrients", food.getNutrients());
						obj.putInt("EPYield", food.getEPYield());
						obj.putInt("LPYield", food.getLPYield());
						obj.putInt("OutputAsset", food.getOutputAsset().getId());
						obj.putInt("Maturity", food.getMaturity());
						foodAssetsArray.addSFSObject(obj);
					} catch (Exception e) {
						fail("There has been a problem with the food assets: " + e.getMessage());
					}
				} else if (asset instanceof AssetCrop){
					try {
						AssetCrop crop = (AssetCrop) asset;
						obj.putInt("EPYield", crop.getEPYield());
						obj.putInt("LPField", crop.getLPYield());
						obj.putInt("OutputAsset", crop.getOutputAsset().getId());
						obj.putInt("Maturity", crop.getMaturity());
						cropAssetsArray.addSFSObject(obj);
					} catch (Exception e) {
						fail("There has been a problem fetching the crop assets: " + e.getMessage());
					}
				} else {
					assetsArray.addSFSObject(obj);
				}
			}
		//} catch (Exception e){
			//e.printStackTrace();
			//fail("Strange problem.");
		//}
	}
}
