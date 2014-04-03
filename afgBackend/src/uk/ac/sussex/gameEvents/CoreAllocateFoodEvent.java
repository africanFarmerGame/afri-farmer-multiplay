/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.gameEvents;

//import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
//import java.util.Map;
import java.util.Set;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.utilities.Logger;

/**
 * @author em97
 * Should remove the food from the chosen food allocation at the end of the food allocation stage. 
 */
public class CoreAllocateFoodEvent extends GameEvent {
	private Set<AssetOwner> hearthAssets;
	private Set<AllocationItem> allocationItems;
	private Integer totalFoods;
	private Set<AssetFood> foods;
	/**
	 * 
	 */
	public CoreAllocateFoodEvent(Game game) {
		super(game);
	}

	@Override
	public void fireEvent() throws Exception {
		//Ok. For a given game, work through each hearth. 
		AllocationFactory allocationFactory = new AllocationFactory();
		AllocationItemFactory allocationItemFactory = new AllocationItemFactory();
		AssetOwnerFactory assetOwnerFactory = new AssetOwnerFactory();
		AssetFactory assetFactory = new AssetFactory();
		PlayerCharFactory pcf = new PlayerCharFactory();
		NPCFactory npcf = new NPCFactory();
		//DietaryRequirementFactory drf = new DietaryRequirementFactory();
		foods = assetFactory.fetchFoodAssets();
		totalFoods = foods.size();
				
		Integer gameYear = game.getGameYear();
		Set<Hearth> hearths = game.fetchHearths();
		for (Hearth hearth: hearths){
			//Need to get the selected allocation
			Allocation selectedAllocation = null;
			try{
				selectedAllocation = allocationFactory.fetchCurrentHearthAllocation(hearth, gameYear);
			} catch (Exception e) {
				String message = "Problem getting selected allocation for hearth " + hearth.getId() + ": " + e.getMessage();
				Logger.ErrorLog("CoreAllocateFoodEvent.fireEvent", message);
			}
			if(selectedAllocation!=null){
				allocationItems = allocationItemFactory.fetchAllocationItems(selectedAllocation);
				Allocation actualAllocation = allocationFactory.createOrUpdateAllocation(-1, "Actual" + hearth.getId(), 0, hearth, game, 1);
				//The hearth members
				Set<PlayerChar> pcs = pcf.fetchHearthPCs(hearth);
				Set<NPC> npcs = npcf.fetchHearthChildren(hearth);
				//The hearth assets
				hearthAssets = assetOwnerFactory.fetchHearthAssets(hearth);
				Set <NPC> babies = new HashSet<NPC>();
				//For each hearth member, starting with player chars
				for (PlayerChar pc: pcs){
					//Only bother if they are alive.
					removeFood(pc, actualAllocation);
					pc.setDiet(actualAllocation.calculateAllocationDietLevel(pc));
					pc.save();
					if(pc.getBabyCount()>0){
						Set<NPC> pcbabies = npcf.fetchPCBabies(pc);
						babies.addAll(pcbabies);
					}
				}
				for (NPC npc: npcs){
					removeFood(npc, actualAllocation);
					npc.setDiet(actualAllocation.calculateAllocationDietLevel(npc));
					npc.save();
					if(npc.getBabyCount()>0){
						Set<NPC> npcbabies = npcf.fetchNPCBabies(npc);
						babies.addAll(npcbabies);
					}
				}
				for (NPC baby: babies){
					removeFood(baby, actualAllocation);
					baby.setDiet(actualAllocation.calculateAllocationDietLevel(baby));
					baby.save();
				}
				for(AssetOwner ao: hearthAssets){
					ao.save();
				}
			}
		}
		
	}
	
	private void removeFood(AllChars character, Allocation actualAllocation) throws Exception{
		if(character.getAlive().equals(AllChars.ALIVE)){
			Integer currentFoods = 0;
			Iterator<AllocationItem> itemIterator = allocationItems.iterator();
			Integer characterId = character.getId();
			while(currentFoods<totalFoods && itemIterator.hasNext()){
				AllocationItem currentItem = itemIterator.next();
				if(currentItem.getCharacter().getId().equals(characterId)){
					//At this point I need to cycle through the hearth assets to find the right asset. 
					Integer itemAssetId = currentItem.getAsset().getId();
					Iterator<AssetOwner> aoIterator = hearthAssets.iterator();
					Boolean foundAO = false;
					AssetOwner ao = null;
					while(!foundAO && aoIterator.hasNext()){
						ao = aoIterator.next();
						foundAO = (ao.getAsset().getId() == itemAssetId);
					}
					if(foundAO && ao!=null){
						Double currentAmount = ao.getAmount();
						//Check the currentAmount is greater than the amount needed.
						Integer neededAmount = currentItem.getAmount();
						Double newAmount = (double) 0;
						Integer amountGiven = newAmount.intValue();
						if(currentAmount>=neededAmount){
							newAmount = currentAmount - currentItem.getAmount();
							amountGiven = currentItem.getAmount();
						} else {
							newAmount = 0.0;
							amountGiven = currentAmount.intValue();
						}
						ao.setAmount(newAmount);
						AllocationItem ai = new AllocationItem();
						ai.setAllocation(actualAllocation);
						ai.setAmount(amountGiven);
						ai.setAsset(currentItem.getAsset());
						ai.setCharacter(character);
						ai.save();
						currentFoods ++;
					}
				}
			}
		}
	}
	@Override
	public void generateNotifications() throws Exception {
		Set<Hearth> hearths = game.fetchHearths();
		PlayerCharFactory pcf = new PlayerCharFactory();
		NPCFactory npcf = new NPCFactory();
		SeasonNotificationFactory snf = new SeasonNotificationFactory();
		AllocationFactory allocationFactory = new AllocationFactory();
		AllocationItemFactory allocationItemFactory = new AllocationItemFactory();
		AssetFactory assetFactory = new AssetFactory();
		
		Integer currentGameYear = game.getGameYear() - 1; //This needs to be one less, because by this stage increment game year will have been called. 
		
		for(Hearth hearth: hearths){
			Allocation actual = null;
			try {
				actual = allocationFactory.fetchActualHearthAllocation(hearth, currentGameYear);
			} catch (Exception e) {
				String message = e.getMessage();
				Logger.ErrorLog("CoreAllocateFoodEvent.generateNotifications", "Problem getting allocation for hearth " + hearth.getId() + " " + message); 
			}
			Set <NPC> babies = new HashSet<NPC>();
			Set<PlayerChar> pcs = pcf.fetchHearthPCs(hearth);
			String notification = "Diet Allocation: \n";
			notification += "The following diets were given to your household - \n";
			for (PlayerChar pc : pcs){
				if(!pc.getAlive().equals(AllChars.DEAD)){
					notification += pc.getDisplayName() + " - Diet Level " + pc.getDiet() + "\n";				
					if(actual!=null){
						Set<AllocationItem> allocationItems = allocationItemFactory.fetchCharacterAllocationItems(actual, pc);
						
						for(AllocationItem ai : allocationItems){
							Asset currentAsset = assetFactory.fetchAsset(ai.getAsset().getId());
							notification += currentAsset.getName() + ": " + ai.getAmount() + " " + currentAsset.getMeasurement() + "(s)\n";
						}
						notification += "\n";
						if(pc.getBabyCount()>0){
							Set<NPC> pcbabies = npcf.fetchPCBabies(pc);
							babies.addAll(pcbabies);
						}
					}
				}
			}
			
			Set<NPC> npcs = npcf.fetchHearthChildren(hearth);
			for(NPC npc: npcs){
				if(!npc.getAlive().equals(AllChars.DEAD)){
					notification += npc.getDisplayName() + " - Diet Level " + npc.getDiet() + "\n";
					if(actual!=null){
						Set<AllocationItem> allocationItems = allocationItemFactory.fetchCharacterAllocationItems(actual, npc);
						
						for(AllocationItem ai : allocationItems){
							Asset currentAsset = assetFactory.fetchAsset(ai.getAsset().getId());
							notification += currentAsset.getName() + ": " + ai.getAmount() + " " + currentAsset.getMeasurement() + "(s)\n";
						}
						notification += "\n";
						if(npc.getBabyCount()>0){
							Set<NPC> npcbabies = npcf.fetchNPCBabies(npc);
							babies.addAll(npcbabies);
						}
					}
				}
			}
			for(NPC baby: babies){
				if(!baby.getAlive().equals(AllChars.DEAD)){
					notification += baby.getDisplayName() + " - Diet Level " + baby.getDiet() + "\n";
					if(actual!=null){
						Set<AllocationItem> allocationItems = allocationItemFactory.fetchCharacterAllocationItems(actual, baby);
						
						for(AllocationItem ai : allocationItems){
							Asset currentAsset = assetFactory.fetchAsset(ai.getAsset().getId());
							notification += currentAsset.getName() + ": " + ai.getAmount() + " " + currentAsset.getMeasurement() + "(s)\n";
						}
						notification += "\n";
					}
				}
			}
			snf.updateSeasonNotifications(notification, pcs);
		}
	}
	
}
