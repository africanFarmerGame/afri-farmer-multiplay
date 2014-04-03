/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

/**
 * 
 */
package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import java.util.Set;

import org.junit.Test;

import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.HearthFactory;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.model.Asset;
import uk.ac.sussex.model.AssetFactory;
import uk.ac.sussex.model.AssetOwner;
import uk.ac.sussex.model.AssetOwnerFactory;

/**
 * @author em97
 *
 */
public class AssetOwnerFactoryTest {

	/**
	 * Test method for {@link uk.ac.sussex.model.assets.AssetOwnerFactory#assignOwnership(uk.ac.sussex.model.Hearth, uk.ac.sussex.model.assets.Asset, java.lang.Double)}.
	 */
	@Test
	public void testAssignOwnershipHearthAssetDouble() {
		AssetOwnerFactory aof = new AssetOwnerFactory();
		
		Hearth hearth = fetchHearth(1);
		Asset asset = fetchAsset("Manure");

		try {
			aof.assignOwnership(hearth, asset, 1.0);
		} catch (Exception e){
			fail("Error assigning ownership: " + e.getMessage());
		}
	}

	/**
	 * Test method for {@link uk.ac.sussex.model.assets.AssetOwnerFactory#assignOwnership(uk.ac.sussex.model.PlayerChar, uk.ac.sussex.model.assets.Asset, java.lang.Double)}.
	 */
	@Test
	public void testAssignOwnershipPlayerCharAssetDouble() {
		AssetOwnerFactory aof = new AssetOwnerFactory();
		
		PlayerChar pc = fetchPlayerChar(2);
		Asset asset = fetchAsset("Manure");

		try {
			aof.assignOwnership(pc, asset, 1.0);
		} catch (Exception e){
			fail("Error assigning ownership: " + e.getMessage());
		}
	}

	/**
	 * Test method for {@link uk.ac.sussex.model.assets.AssetOwnerFactory#fetchPCAssets(uk.ac.sussex.model.PlayerChar)}.
	 */
	@Test
	public void testFetchPCAssets() {
		fail("Not yet implemented");
	}

	/**
	 * Test method for {@link uk.ac.sussex.model.assets.AssetOwnerFactory#fetchHearthAssets(uk.ac.sussex.model.Hearth)}.
	 */
	@Test
	public void testFetchHearthAssets() {
		Hearth hearth = fetchHearth(1);
		AssetOwnerFactory aof = new AssetOwnerFactory();
		try {
			Set<AssetOwner> aos = aof.fetchHearthAssets(hearth); 
			assertNotNull(aos);
			assertEquals(11, aos.size());
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the hearth assets: " + e.getMessage());
		}
	}
	/**
	 * Test method for 
	 */
	@Test
	public void testFetchSpecificAsset() {
		Hearth hearth = fetchHearth(1);
		Asset maize = fetchAsset("Maize");
		
		AssetOwnerFactory aof = new AssetOwnerFactory();
		try {
			AssetOwner ao = aof.fetchSpecificAsset(hearth, maize);
			assertNotNull(ao);
			
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the asset owner record.");
		}
		
	}
	@Test
	public void testFetchSpecificPCAsset(){
		Asset cash = fetchAsset("Cash");
		PlayerChar banker = fetchPlayerChar(43);
		AssetOwnerFactory aof = new AssetOwnerFactory();
		AssetOwner ao = null;
		try {
			ao = aof.fetchSpecificPCAsset(banker, cash);
		} catch (Exception e){
			e.printStackTrace();
			fail("Problem. Dunno what.");
		}
		assertNotNull(ao);
	}
	private Hearth fetchHearth(Integer hearthId){
		HearthFactory hf = new HearthFactory();
		Hearth hearth = null;
		try {
			hearth = hf.fetchHearth(hearthId);
		} catch (Exception e) {
			e.printStackTrace();
			fail ("problem getting the hearth");
		}
		assertNotNull(hearth);
		return hearth;
	}
	private Asset fetchAsset(String assetName){
		AssetFactory af = new AssetFactory();
		Asset asset = null;
		try {
			asset = af.fetchAsset(assetName);
		} catch (Exception e) {
			e.printStackTrace();
			fail ("Problem getting the asset " + assetName);
		}
		assertNotNull(asset);
		return asset;
	}
	private PlayerChar fetchPlayerChar(Integer pcId){
		PlayerCharFactory pcf = new PlayerCharFactory();
		PlayerChar pc = null;
		try {
			pc = pcf.fetchPlayerChar(pcId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem with fetching player " + pcId);
		}
		assertNotNull(pc);
		return pc;
	}
}
