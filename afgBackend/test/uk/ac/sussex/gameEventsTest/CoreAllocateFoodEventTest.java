/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

/**
 * 
 */
package uk.ac.sussex.gameEventsTest;

import static org.junit.Assert.*;

import java.util.Date;
import java.util.HashMap;
//import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.junit.Test;

import uk.ac.sussex.gameEvents.CoreAllocateFoodEvent;
import uk.ac.sussex.gameEvents.CoreCreateDefaultDietAllocationEvent;
import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.CoreGame;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;

/**
 * @author em97
 *
 */
public class CoreAllocateFoodEventTest {

	@Test
	public void testFireEvent() {
		Date date = new Date();
		Game game = createGame("alloctestGame" + date.getTime());
		CoreCreateDefaultDietAllocationEvent createAllocations = new CoreCreateDefaultDietAllocationEvent(game);
		try {
			createAllocations.fireEvent();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't create allocations");
		}
		this.setAssetAmounts(game);
		CoreAllocateFoodEvent allocateFood = new CoreAllocateFoodEvent(game);
		try {
			allocateFood.fireEvent();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't fire the event");
		}
		
	}
	@Test
	public void testGenerateNotification() {
		//Temporary game hack - really should run the top test first and change the name of the game accordingly.
		GameFactory gf = new GameFactory();
		Game game = null;
		try {
			game = gf.fetchGame(1);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't fetch my game");
		}
		
		CoreAllocateFoodEvent allocateFood = new CoreAllocateFoodEvent(game);
		
		try {
			allocateFood.generateNotifications();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't generate my notifications");
		}
	}
	
/**	@Test
	public void testAssignDietLevel(){
		//This is a temporary test - the function is normally private, but I need to run it through.
		Date date = new Date();
		GameFactory gameFactory = new GameFactory();
		Game game = null;
		try {
			game = gameFactory.fetchGame("x6");
		} catch (Exception e) {
			e.printStackTrace();
			fail("couldn't get the game.");
		}
		
		NPCFactory npcf = new NPCFactory();
		NPC adultMale1 = null;
		try {
			adultMale1 = npcf.fetchNPC(216);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get my adult male");
		}
		
		DietaryRequirementFactory drf = new DietaryRequirementFactory();
		Map<DietaryLevels, DietaryRequirement> requirements = drf.fetchDietaryRequirements(adultMale1);
		
		Allocation allocation = new Allocation();
		allocation.setName("Checking" + date.getTime());
		allocation.setActual(0);
		allocation.setDeleted(0);
		allocation.setGameYear(3);
		allocation.setHousehold(adultMale1.getHearth());
		allocation.setSelected(0);
		try {
			allocation.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't save allocation");
		}
		
		Asset maize = new Asset();
		maize.setId(2);
		Asset beans = new Asset();
		beans.setId(7);
		Asset horti = new Asset();
		horti.setId(11);
		
		AllocationItem aiMaize = new AllocationItem();
		aiMaize.setAllocation(allocation);
		aiMaize.setAsset(maize);
		aiMaize.setCharacter(adultMale1);
		aiMaize.setAmount(2);
		AllocationItem aiBeans = new AllocationItem();
		aiBeans.setAllocation(allocation);
		aiBeans.setAsset(beans);
		aiBeans.setCharacter(adultMale1);
		aiBeans.setAmount(1);
		AllocationItem aiHorti = new AllocationItem();
		aiHorti.setAllocation(allocation);
		aiHorti.setCharacter(adultMale1);
		aiHorti.setAsset(horti);
		aiHorti.setAmount(1);
		try {
			aiMaize.save();
			aiBeans.save();
			aiHorti.save();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			fail("couldn't save allocation itmes");
		}
		
		
		
		CoreAllocateFoodEvent allocateFood = new CoreAllocateFoodEvent(game);
		try {
			allocateFood.assignDietLevel(adultMale1, requirements, allocation);
		} catch (Exception e) {
			e.printStackTrace();
			fail("couldn't run function");
		}
		try {
			adultMale1 = npcf.fetchNPC(adultMale1.getId());
		} catch (Exception e) {
			e.printStackTrace();
			fail ("Couldn't re-fetch adult ");
		}
		assertEquals(DietaryLevels.toOption(adultMale1.getDiet()), DietaryLevels.C);
	}*/
	
	private Game createGame(String gamename){
		GameFactory gf = new GameFactory();
		Game game = null;
		try {
			game = gf.createGame(CoreGame.TYPE, gamename, "", 13, gamename, 2);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to create game " + gamename);
		}
		return game;
	}
	private void setAssetAmounts(Game game){
		HearthFactory hf = new HearthFactory();
		Set<Hearth> hearths = null;
		try {
			hearths = hf.fetchGameHearths(game);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Can't get the hearths");
		}
		AllocationFactory alFactory = new AllocationFactory();
		AllocationItemFactory aiFactory = new AllocationItemFactory();
		AssetOwnerFactory aoFactory = new AssetOwnerFactory();
		try {
			for (Hearth hearth : hearths){
				Allocation allocation = alFactory.fetchCurrentHearthAllocation(hearth, 0);
				Map<Asset, Double> assetCount = new HashMap<Asset, Double>();
				Set<AllocationItem> allocationItems = aiFactory.fetchAllocationItems(allocation);
				for (AllocationItem ai : allocationItems){
					Asset aiAsset = ai.getAsset();
					if(!assetCount.containsKey(aiAsset)){
						assetCount.put(aiAsset, 0.0);
					}
					Double assetAmount = assetCount.get(aiAsset);
					assetAmount += ai.getAmount();
					assetCount.put(aiAsset, assetAmount);
				}
				for (Asset key: assetCount.keySet()){
					AssetOwner ao = aoFactory.fetchSpecificAsset(hearth, key);
					if(hearth.getHousenumber()==1){
						ao.setAmount(assetCount.get(key) - 1);
					} else {
						ao.setAmount(assetCount.get(key));
					}
					ao.save();
				}
			}
		} catch (Exception e){
			e.printStackTrace();
			fail("Unable to generate asset amounts.");
		}
	}
}
