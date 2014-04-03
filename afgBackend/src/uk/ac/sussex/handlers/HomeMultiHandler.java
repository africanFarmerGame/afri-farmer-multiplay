/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.handlers;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.utilities.GameHelper;
import uk.ac.sussex.utilities.Logger;
import uk.ac.sussex.utilities.UserHelper;

import com.smartfoxserver.v2.annotations.MultiHandler;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.extensions.SFSExtension;

@MultiHandler
public class HomeMultiHandler extends BaseClientRequestHandler {

	@Override
	public void handleClientRequest(User user, ISFSObject params) {
		String requestId = params.getUtfString(SFSExtension.MULTIHANDLER_REQUEST_ID);
		Integer hearthId = params.getInt("hearthId");
	    
	    try {
		    switch(HomeMultiEnum.toOption(requestId)) {
		     	case GET_MEMBER_DETAILS:
		     		Logger.Log(user.getName(), "Requested the hearth member details from HomeMultiHandler for hearth " + hearthId.toString());
		     		this.getHearthMemberDetails(hearthId, user);
		     		break;
		     	case GET_HEARTH_ASSETS:
		     		Logger.Log(user.getName(), "Requested the hearth asset details from HomeMultiHandler for hearth " + hearthId.toString());
		     		this.getHearthAssetDetails(hearthId, user);
		     		break;
		     	case GET_DIETS:
		     		Logger.Log(user.getName(), "Asked for the list of diets from HomeMultiHandler for hearth " + hearthId.toString());
	     			this.getHearthDiets(hearthId, user);
		     		break;
		     	case GET_DIETARY_REQS:
		     		Logger.Log(user.getName(), "Asked for the list of dietary requirements.");
		     		this.getDietaryRequirements(user);
		     		break;
		     	case GET_GAME_ASSETS:
		     		Logger.Log(user.getName(), "Asked for the list of game assets.");
		   			this.getGameAssets(user);
		     		break;
		     	case SAVE_DIET:
		     		Logger.Log(user.getName(), "Tried to save a diet.");
		     		ISFSObject diet = params.getSFSObject("Diet");
		     		this.saveDiet(user, hearthId, diet);
		     		break;
		     	case DELETE_DIET:
		     		Integer dietId = params.getInt("DietId");
		     		Logger.Log(user.getName(), "Tried to delete a diet id " + dietId);
		     		this.deleteDiet(user, dietId);
		     		break;
		     	case GET_ALLOCATIONS:
		     		Logger.Log(user.getName(), "Asked for a list of hearth allocations for hearthid " + hearthId.toString());
		     		this.getAllocations(user, hearthId);
		     		break;
		     	case SAVE_ALLOCATION:
		     		Logger.Log(user.getName(), "Attempted to save an allocation for hearthid " + hearthId.toString());
		     		ISFSObject allocation = params.getSFSObject("Allocation");
		     		this.saveAllocation(user, hearthId, allocation);
		     		break;
		     	case DELETE_ALLOCATION:
		     		Integer allocationId = params.getInt("AllocationId");
		     		Logger.Log(user.getName(), "Tried to delete an allocation id " + allocationId);
		     		this.deleteAllocation(user, allocationId);
		     		break;
		     	case SET_ACTIVE_ALLOCATION:
		     		Integer selectedId = params.getInt("AllocationId");
		     		Logger.Log(user.getName(), "Tried to set an active allocation " + selectedId + " for household " + hearthId);
		     		this.setSelectedAllocation(user, hearthId, selectedId);
		     		break;
		     	case GM_FETCH_FOOD_OVERVIEW:
		     		Logger.Log(user.getName(), "Tried to fetch the food overview.");
		     		this.fetchFoodOverview(user);
		     		break;
		    	default:
		    		Logger.Log(user.getName(), "Tried to ask for " + requestId + " from HomeMultiHandler");
		        	ISFSObject errObj = new SFSObject();
		        	errObj.putUtfString("message", "Unable to action request "+requestId);
		        	send("homeError", errObj, user);
		        	break;
		     }
	    } catch (Exception e) {
	    	ISFSObject errObj = SFSObject.newInstance();
	    	String message = "There has been a problem with request " + requestId + ": " +e.getMessage() ;
 			errObj.putUtfString("message", message);
 			Logger.ErrorLog("HomeMultiHandler.handleClientRequest(" + requestId + ")", message);
 			send(requestId + "_error", errObj, user);
	    }
	}
	
	private void getHearthMemberDetails(Integer hearthId, User user) throws Exception{
		
		SFSArray pcArray = SFSArray.newInstance();
		SFSArray npcArray = SFSArray.newInstance();
		SFSArray deadArray = SFSArray.newInstance();
		HearthFactory hf = new HearthFactory();
		Hearth hearth = hf.fetchHearth(hearthId);
		PlayerCharFactory pcf = new PlayerCharFactory();
		NPCFactory npcf = new NPCFactory();
		
		Set<PlayerChar> pcs = hearth.getCharacters();
		for (PlayerChar pc : pcs){
			PlayerChar fullpc = pcf.fetchPlayerChar(pc.getId());
			SFSObject pcObj = SFSObject.newInstance();
			pcObj = wrapPC(fullpc, hearthId);
			if(fullpc.getRole().getId().equals("WOMAN")){
				//See if she's got any babies. 
				Set<NPC> babies = npcf.fetchPCBabies(fullpc);
				for (NPC baby : babies){
					SFSObject npcObj = SFSObject.newInstance();
					npcObj = wrapNPC(baby, hearthId);
					if(baby.getAlive().equals(AllChars.DEAD)){
						deadArray.addSFSObject(npcObj);
					} else {
						npcArray.addSFSObject(npcObj);
					}
				}
			}
			if(pc.getAlive().equals(AllChars.DEAD)){
				deadArray.addSFSObject(pcObj);
			} else {
				pcArray.addSFSObject(pcObj);
			}
		}
		//And now add the hearth npcs. 
		Set<NPC> children = npcf.fetchHearthChildren(hearth);
		for (NPC child : children ) {
			SFSObject childObj = SFSObject.newInstance();
			childObj = wrapNPC(child, hearthId);
			if(child.isAdult() && child.getRole().getId().equals("WOMAN")){
				//See if she's got any babies. 
				Set<NPC> babies = npcf.fetchNPCBabies(child);
				for (NPC baby : babies){
					SFSObject npcObj = SFSObject.newInstance();
					npcObj = wrapNPC(baby, hearthId);
					if(baby.getAlive().equals(AllChars.DEAD)){
						deadArray.addSFSObject(npcObj);
					} else {
						npcArray.addSFSObject(npcObj);
					}
				}
			} 
			if(child.getAlive().equals(AllChars.DEAD)){
				deadArray.addSFSObject(childObj);
			} else {
				npcArray.addSFSObject(childObj);
			}
		}
		
		SFSObject dataObj = SFSObject.newInstance();
		dataObj.putSFSArray("PCList", pcArray);
		dataObj.putSFSArray("NPCList", npcArray);
		dataObj.putSFSArray("DeadList", deadArray);
		send("hearthMembersList", dataObj, user);
	}
	private void getHearthAssetDetails(Integer hearthId, User user) throws Exception {
		HearthFactory hf = new HearthFactory();
		Hearth hearth = hf.fetchHearth(hearthId);
		
		SFSArray dataArray = SFSArray.newInstance();
		//Need to add all of the hearth assets to the array. 
		
		/**AssetOwnerFactory aof = new AssetOwnerFactory();
		Set<AssetOwner> hearthAssets = aof.fetchHearthAssets(hearth);
		for (AssetOwner ao : hearthAssets){	
			SFSObject assetObj = SFSObject.newInstance();
			assetObj.putInt("Id", ao.getId()); //Do I really need this?
			assetObj.putDouble("Amount", ao.getAmount());
			assetObj.putInt("Asset", ao.getAsset().getId());
			dataArray.addSFSObject(assetObj);
		}*/
		
		AssetFactory assetFactory = new AssetFactory();
		Set<Asset> assets = assetFactory.fetchAssets();
		for(Asset asset: assets){
			if(hearth!=null){
				Double hearthAmount = asset.fetchAmountHearthOwn(hearth);
				if(hearthAmount!=null){
					SFSObject assetObj = SFSObject.newInstance();
					assetObj.putDouble("Amount", asset.fetchAmountHearthOwn(hearth));
					assetObj.putInt("Asset", asset.getId());
					dataArray.addSFSObject(assetObj);
				}
			}
		}
		
		SFSObject sendObj = SFSObject.newInstance();
		sendObj.putSFSArray("HearthAssets", dataArray);
		send("HearthAssetsList", sendObj, user);
	}
	private void getHearthDiets(Integer hearthId, User user) throws Exception {
		HearthFactory hf = new HearthFactory();
		Hearth hearth = hf.fetchHearth(hearthId);
		
		DietFactory df = new DietFactory();
		Set<Diet> diets = df.fetchHouseholdDiets(hearth);
		SFSArray dietArray = SFSArray.newInstance();
		if(diets.size() > 0){
			DietItemFactory dif = new DietItemFactory();
			
			for (Diet diet : diets){
				SFSObject dietObj = SFSObject.newInstance();
				dietObj.putInt("Id", diet.getId());
				dietObj.putUtfString("Name", diet.getName());
				dietObj.putInt("Target", diet.getTarget());
				Set<DietItem> items = dif.fetchDietItems(diet);
				SFSArray dietitems = SFSArray.newInstance();
				for (DietItem item: items){
					SFSObject dietItem = SFSObject.newInstance();
					dietItem.putInt("Id", item.getId());
					dietItem.putInt("Amount", item.getAmount());
					dietItem.putInt("AssetId", item.getAsset().getId());
					dietitems.addSFSObject(dietItem);
				}
				dietObj.putSFSArray("DietItems", dietitems);
				dietArray.addSFSObject(dietObj);
			}
		}
		SFSObject sendObj = SFSObject.newInstance();
		sendObj.putSFSArray("Diets", dietArray);
		send("DietsList", sendObj, user);
	}
	private void getDietaryRequirements(User user) {
		DietaryRequirementFactory drf = new DietaryRequirementFactory();
		HashMap<DietaryTypes, HashMap<DietaryLevels, DietaryRequirement>> dietaryReqs = drf.fetchAllDietaryRequirements();
		SFSArray drArray = SFSArray.newInstance();
		for (Map.Entry<DietaryTypes, HashMap<DietaryLevels, DietaryRequirement>> type : dietaryReqs.entrySet() ) {
			for (Map.Entry<DietaryLevels, DietaryRequirement> level : type.getValue().entrySet() ) {
				SFSObject dReqObj = SFSObject.newInstance();
				DietaryRequirement dReq = level.getValue();
				dReqObj.putInt("DietaryType", dReq.getDietaryType().getIntValue());
				dReqObj.putUtfString("DietaryLevel", dReq.getDietaryLevel().toString());
				dReqObj.putInt("Protein", dReq.getProtein());
				dReqObj.putInt("Carbohydrate", dReq.getCarbohydrate());
				dReqObj.putInt("Nutrients", dReq.getNutrients());
				drArray.addSFSObject(dReqObj);
			}
		}
		SFSObject dReqObjs = SFSObject.newInstance();
		dReqObjs.putSFSArray("DietaryRequirements", drArray);
		send("DietaryRequirements", dReqObjs, user);
	}
	private void getGameAssets(User user) throws Exception{
		AssetFactory af = new AssetFactory();
		Set<Asset> assets = null;
		try{
			assets = af.fetchAssets();
		} catch (Exception e){
			throw new Exception("There was a problem fetching the assets: " + e.getMessage());
		}
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
			obj.putUtfString("Notes", asset.getNotes());
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
					throw new Exception("There has been a problem with the food assets: " + e.getMessage());
				}
			} else if (asset instanceof AssetCrop){
				try {
					AssetCrop crop = (AssetCrop) asset;
					obj.putInt("EPYield", crop.getEPYield());
					obj.putInt("LPYield", crop.getLPYield());
					obj.putInt("OutputAsset", crop.getOutputAsset().getId());
					obj.putInt("Maturity", crop.getMaturity());
					cropAssetsArray.addSFSObject(obj);
				} catch (Exception e) {
					throw new Exception("There has been a problem fetching the crop assets: " + e.getMessage());
				}
			} else {
				assetsArray.addSFSObject(obj);
			}
		}
		SFSObject sendObj = SFSObject.newInstance();
		sendObj.putSFSArray("GameAssets", assetsArray);
		sendObj.putSFSArray("GameAssetsFood", foodAssetsArray);
		sendObj.putSFSArray("GameAssetsCrop", cropAssetsArray);
		send("GameAssetsListReceived", sendObj, user);
	}
	private void saveDiet(User user, Integer hearthId, ISFSObject dietObj) throws Exception {
		Integer dietId = dietObj.getInt("Id");
		HearthFactory hf = new HearthFactory();
		Hearth hearth = hf.fetchHearth(hearthId);
		Diet diet; 
		Set<DietItem> dietItems;
		if (dietId > -1){
			DietFactory df = new DietFactory();
			diet = df.fetchDiet(dietId);
			DietItemFactory dif = new DietItemFactory();
			dietItems = dif.fetchDietItems(diet);
		} else {
			diet = new Diet();
			dietItems = new HashSet<DietItem>();
		}
		diet.setHousehold(hearth);
		diet.setName(dietObj.getUtfString("Name"));
		diet.setTarget(dietObj.getInt("Target"));
		diet.save();
		//Next up is diet items.
		ISFSArray dietItemsObject = dietObj.getSFSArray("DietItems");
		Integer numberItems = dietItemsObject.size();
		for (Integer counter = 0; counter < numberItems; counter++){
			ISFSObject dietItemObj = dietItemsObject.getSFSObject(counter);
			Integer assetId = dietItemObj.getInt("AssetId");
			AssetFood assetfood = new AssetFood();
			assetfood.setId(assetId);
			DietItem dietItem = new DietItem();
			for (DietItem di: dietItems){
				if(di.getAsset().getId() == assetId){
					dietItem = di; 
					break;
				}
			}
			dietItem.setAmount(dietItemObj.getInt("Amount"));
			dietItem.setDiet(diet);
			dietItem.setAsset(assetfood);
			dietItem.save();
			dietItemObj.putInt("Id", dietItem.getId());
		}
		SFSObject sendObj = SFSObject.newInstance();
		sendObj.putUtfString("message", "Diet saved successfully");
		dietObj.putInt("Id", diet.getId());
		sendObj.putSFSObject("Diet", dietObj);
		send("save_diet_success", sendObj, user);
	}
	private void deleteDiet(User user, Integer dietID) throws Exception {
		DietFactory df = new DietFactory();
		Diet diet = df.fetchDiet(dietID);
		diet.setDeleted(1);
		diet.save();
		SFSObject sendObj = SFSObject.newInstance();
		sendObj.putUtfString("message", "Diet '" + diet.getName() + " was deleted by " + user.getName());
		sendObj.putInt("DietId", dietID);
		send("diet_deleted", sendObj, user);
	}
	private void getAllocations(User user, Integer hearthId) throws Exception {
		Game game = UserHelper.fetchUserGame(user);
		HearthFactory hf = new HearthFactory();
		Hearth hearth = hf.fetchHearth(hearthId);
		AllocationFactory af = new AllocationFactory();
		Set<Allocation> allocations = af.fetchHearthAllocations(hearth, game.getGameYear());
		
		SFSArray allocationArray = SFSArray.newInstance();
		
		for (Allocation allocation : allocations){
			SFSObject allocationObj = wrapAllocation(allocation);
			allocationArray.addSFSObject(allocationObj);
		}
		SFSObject sendObj = SFSObject.newInstance();
		sendObj.putSFSArray("Allocations", allocationArray);
		send("AllocationsList", sendObj, user);
	}
	private void saveAllocation(User user,Integer hearthId,ISFSObject allocationObj) throws Exception {
		Game currentGame = UserHelper.fetchUserGame(user);
		Integer allocationId = allocationObj.getInt("Id");
		HearthFactory hf = new HearthFactory();
		Hearth hearth = hf.fetchHearth(hearthId);
		
		AllocationFactory allocationFactory = new AllocationFactory(); 
		Allocation allocation = allocationFactory.createOrUpdateAllocation(allocationId, 
																		   allocationObj.getUtfString("Name"), 
																		   allocationObj.getInt("Selected"), 
																		   hearth, 
																		   currentGame, 
																		   0
																		   ); 
		Set<AllocationItem> allocationItems;
		if (allocationId > -1){
			AllocationItemFactory aif = new AllocationItemFactory();
			allocationItems = aif.fetchAllocationItems(allocation);
		} else {
			allocationItems = new HashSet<AllocationItem>();
		}
		
		ISFSArray aiObjs = allocationObj.getSFSArray("AllocationItems");
		Integer numberItems = aiObjs.size();
		for (Integer counter = 0; counter < numberItems; counter++){
			ISFSObject allocationItemObj = aiObjs.getSFSObject(counter);
			Integer assetId = allocationItemObj.getInt("Asset");
			Integer charId = allocationItemObj.getInt("Character");
			
			AllocationItem allocationItem = new AllocationItem();
			for (AllocationItem ai: allocationItems){
				if((ai.getAsset().getId().equals(assetId)) &&(ai.getCharacter().getId().equals(charId))){
					allocationItem = ai; 
					break;
				}
			}
			allocationItem.setAmount(allocationItemObj.getInt("Amount"));
			allocationItem.setAllocation(allocation);
			AssetFood afood = new AssetFood();
			afood.setId(assetId);
			allocationItem.setAsset(afood);
			AllChars achar = new AllChars();
			achar.setId(charId);
			allocationItem.setCharacter(achar);
			allocationItem.save();
			allocationItemObj.putInt("Id", allocationItem.getId());
			allocationItemObj.putInt("Allocation", allocation.getId());
		}
		SFSObject sendObj = SFSObject.newInstance();
		sendObj.putUtfString("message", "Allocation saved successfully");
		allocationObj.putInt("Id", allocation.getId());
		sendObj.putSFSObject("Allocation", allocationObj);
		send("save_allocation_success", sendObj, user);
		
		//Need to send to the rest of the online family. 
		List<User> hearthMembers = GameHelper.fetchOnlineHearthUsers(getApi(), hearth);
		SFSArray allocationArray = SFSArray.newInstance();
		allocationArray.addSFSObject(wrapAllocation(allocation));
		SFSObject familyObject = SFSObject.newInstance();
		familyObject.putSFSArray("Allocations", allocationArray);
		send("AllocationsUpdated", familyObject, hearthMembers);
		
		//And then let the GM know what's going on with the players. 
		if(allocation.getSelected().equals(1)){
			updateGMFoodDetail(hearth, currentGame, allocation);
		}
	}
	private void deleteAllocation(User user, Integer allocationId) throws Exception {
		AllocationFactory af = new AllocationFactory();
		Allocation a = af.fetchAllocation(allocationId);
		a.setDeleted(1);
		a.save();
		SFSObject sendObj = SFSObject.newInstance();
		sendObj.putUtfString("message", "Allocation '" + a.getName() + " was deleted by " + user.getName());
		sendObj.putInt("AllocationId", allocationId);
		send("allocation_deleted", sendObj, user);
	}
	private void setSelectedAllocation(User user, Integer hearthId, Integer allocationId) throws Exception {
		Game game = UserHelper.fetchUserGame(user);
		HearthFactory hf = new HearthFactory();
		Hearth hearth = null;
		try {
			hearth = hf.fetchHearth(hearthId);
		} catch (Exception e) {
			throw new Exception("Unable to fetch details of hearth " + hearthId + ": " + e.getMessage());
		}
		AllocationFactory af = new AllocationFactory();
		Set<Allocation> selectedAllocations = af.fetchSelectedAllocations(hearth);
		for (Allocation allocation : selectedAllocations){
			allocation.setSelected(0);
			allocation.save();
		}
		Allocation newSelection = af.fetchAllocation(allocationId);
		newSelection.setSelected(1);
		newSelection.save();
		
		SFSObject sendObj = SFSObject.newInstance();
		sendObj.putUtfString("message", "Allocation '" + newSelection.getName() + "' has been selected.");
		sendObj.putInt("AllocationId", allocationId);
		send("set_active_allocation_success", sendObj, user);
		updateGMFoodDetail(hearth, game, newSelection);
	}
	private void fetchFoodOverview(User user) throws Exception {
		Game game = UserHelper.fetchUserGame(user);
		HearthFactory hearthFactory = new HearthFactory();
		Set<Hearth> hearths = null;
		try{
			hearths = hearthFactory.fetchGameHearths(game);
		} catch(Exception e) {
			throw new Exception ("Unable to find hearths for game " + game.getGameName() + ": " + e.getMessage());
		}
		SFSArray foodDetailArray = SFSArray.newInstance();
		AllocationFactory allocFactory = new AllocationFactory();
		AssetFactory assetFactory = new AssetFactory();
		
		Set<AssetFood> foodAssets = null;
		try {
			foodAssets = assetFactory.fetchFoodAssets();
		} catch (Exception e){
			String message = e.getMessage();
			Logger.ErrorLog("HomeMultiHandler.fetchFoodOverview", "Problem fetching food assets: " + message);
			throw new Exception("There has been a problem calculating the food information: " + message);
		}
		Integer year = game.getGameYear();
		for(Hearth hearth: hearths){
			SFSObject foodDetail = SFSObject.newInstance();
			foodDetail.putInt("HearthId", hearth.getId());
			
			//For each hearth I need to get the selected diet allocation.
			Allocation chosenAlloc = null;
			try{
				chosenAlloc = allocFactory.fetchCurrentHearthAllocation(hearth, year);
			} catch(Exception e) {
				Logger.ErrorLog("HomeMultiHandler.fetchFoodOverview", "Couldn't find the current allocation for hearth " + hearth.getId());
			}
			if(chosenAlloc!=null){
				try {
					foodDetail = wrapFamilyDiets(hearth, chosenAlloc, foodDetail, foodAssets);
				} catch (Exception e) {
					Logger.ErrorLog("HomeMultiHandler.fetchFoodOverview", "Problem wrapping foodDetail for hearth " + hearth.getId() + ": " + e.getMessage());
				}
			}
			
			foodDetailArray.addSFSObject(foodDetail);
		}
		SFSObject sendObject = SFSObject.newInstance();
		sendObject.putSFSArray("gm_food_overview", foodDetailArray);
		send("gm_food_overview", sendObject, user);
	}
	private HealthHazard fetchCharacterHealthHazard(AllChars character) throws Exception {
		HealthHazardFactory hhf = new HealthHazardFactory();
		CharHealthHazard charHazard = hhf.fetchHealthHazardByCharacter(character);
		HealthHazard hazard = hhf.fetchHealthHazardById(charHazard.getHazard().getId());
		return hazard;
	}
	private SFSObject wrapNPC(NPC npc, Integer hearthId) {
		SFSObject npcObj = SFSObject.newInstance();
		npcObj.putInt("ID", npc.getId());
		if(npc.getName() == null) {
			npcObj.putNull("firstname");
		} else {
			npcObj.putUtfString("firstname", npc.getName());
		}
		npcObj.putUtfString("familyname", npc.getFamilyName());
		npcObj.putUtfString("Role", npc.getRole().getId());
		npcObj.putInt("AvatarBody", npc.getAvatarBody());
		npcObj.putInt("Age", npc.getAge());
		npcObj.putInt("HearthId", hearthId);
		 
		Integer npcAlive = npc.getAlive();
		npcObj.putInt("Alive", npcAlive);
		if(npc.isAdult()){
			if(npc.getRole().getId().equals("WOMAN")){
				npcObj.putInt("DietTarget", 1);
			} else {
				npcObj.putInt("DietTarget", 0);
			}
		} else if (npc.getAge()<=NPC.CHILD_AGE){
			npcObj.putInt("DietTarget", 3);
		} else {
			npcObj.putInt("DietTarget", 2);
		}
		if(npcAlive.equals(AllChars.DEAD)){
			npcObj.putNull("healthHazard");
		} else {
			npcObj.putUtfString("CurrentDiet", npc.getDiet());
			if(npcAlive.equals(AllChars.ILL)){
				HealthHazard hazard = null;
				try {
					hazard = fetchCharacterHealthHazard(npc);
				} catch (Exception e) {
					Logger.ErrorLog("HomeMultiHandler.wrapNPC", "Problem fetching health hazard for npc " + npc.getId() + ": " + e.getMessage());
				}
				if(hazard==null){
					npcObj.putNull("healthHazard");
				} else {
					npcObj.putUtfString("healthHazard", hazard.getName());
				}
			} else {
				npcObj.putNull("healthHazard");
			}
		}
		return npcObj;
	}
	private SFSObject wrapPC(PlayerChar pc, Integer hearthId){
		
		SFSObject pcObj = SFSObject.newInstance();
		
		pcObj.putInt("id", pc.getId());
		if(pc.getName() == null){
			pcObj.putNull("firstname");
		} else {
			pcObj.putUtfString("firstname", pc.getName());
		}
		pcObj.putUtfString("familyname", pc.getFamilyName());
		String role = pc.getRole().getId();
		pcObj.putUtfString("role", role);
		pcObj.putInt("avatarbody", pc.getAvatarBody());
		pcObj.putInt("hearthid", hearthId);
		Integer aliveValue = pc.getAlive();
		pcObj.putInt("alive", aliveValue);
		
		if(aliveValue.equals(AllChars.DEAD)){
			pcObj.putNull("healthHazard");
		} else {
			pcObj.putUtfString("CurrentDiet", pc.getDiet());
			if(aliveValue.equals(AllChars.ILL)){
				HealthHazard hazard = null;
				try {
					hazard = fetchCharacterHealthHazard(pc);
				} catch (Exception e) {
					Logger.ErrorLog("HomeMultiHandler.wrapPC", "Problem fetching health hazard for pc " + pc.getId() + ": " + e.getMessage());
				}
				if(hazard==null){
					pcObj.putNull("healthHazard");
				} else {
					pcObj.putUtfString("healthHazard", hazard.getName());
				}
			} else {
				pcObj.putNull("healthHazard");
			}
		}
		if(role.equals("WOMAN")){
			pcObj.putInt("DietTarget", 1);
		} else {
			pcObj.putInt("DietTarget", 0);
		}
		return pcObj;
	}
	private SFSObject wrapFamilyDiets(Hearth hearth, Allocation allocation, SFSObject object, Set<AssetFood> foodAssets) throws Exception{
		PlayerCharFactory pcf = new PlayerCharFactory();
		NPCFactory npcf = new NPCFactory();
		Integer aDiet = 0;
		Integer bDiet = 0;
		Integer cDiet = 0;
		Integer xDiet = 0;
		Boolean enough = true;
		
		Set<PlayerChar> pcs = pcf.fetchHearthPCs(hearth);
		Set<NPC> npcs = npcf.fetchHearthChildren(hearth);
		//Then I need to total the food, and the number of family members on each diet type.
		Set <NPC> babies = new HashSet<NPC>();
		//For each hearth member, starting with player chars
		for (PlayerChar pc: pcs){
			switch(allocation.calculateAllocationDietLevel(pc)){
				case A:
					aDiet++;
					break;
				case B:
					bDiet++;
					break;
				case C:
					cDiet++;
					break;
				default:
					xDiet++;
			}
			if(pc.getBabyCount()>0){
				Set<NPC> pcbabies = npcf.fetchPCBabies(pc);
				babies.addAll(pcbabies);
			}
		}
		for (NPC npc: npcs){
			switch(allocation.calculateAllocationDietLevel(npc)){
			case A:
				aDiet++;
				break;
			case B:
				bDiet++;
				break;
			case C:
				cDiet++;
				break;
			default:
				xDiet++;
			}
			if(npc.getBabyCount()>0){
				Set<NPC> npcbabies = npcf.fetchNPCBabies(npc);
				babies.addAll(npcbabies);
			}
		}
		for (NPC baby: babies){
			switch(allocation.calculateAllocationDietLevel(baby)){
			case A:
				aDiet++;
				break;
			case B:
				bDiet++;
				break;
			case C:
				cDiet++;
				break;
			default:
				xDiet++;
			}
		}
		
		//And work out if they have enough food for that.
		AssetOwnerFactory aofactory = new AssetOwnerFactory();
		Iterator<AssetFood> foodIterator = foodAssets.iterator();
		while(enough && foodIterator.hasNext()){
			AssetFood food = foodIterator.next();
			Integer amountRequired = allocation.calculateFoodTotal(food);
			AssetOwner ao = aofactory.fetchSpecificAsset(hearth, food);
			enough = (ao.getAmount()>=amountRequired);
		}
		object.putInt("ADiet", aDiet);
		object.putInt("BDiet", bDiet);
		object.putInt("CDiet", cDiet);
		object.putInt("XDiet", xDiet);
		object.putBool("Enough", enough);
		return object;
	}
	private void updateGMFoodDetail(Hearth household, Game game, Allocation allocation){
		User bankerUser = null;
		try {
			bankerUser = GameHelper.fetchBankerFromHome(getApi(), game);
		} catch (Exception e){
			Logger.Log("FarmMultiHandler.updateGMManagerTaskNumbers", "Problem fetching banker for game " + game.getGameName() + ": " + e.getMessage());
			return;
		}
		try {
			SFSObject detailObject = SFSObject.newInstance();
			detailObject.putInt("HearthId", household.getId());
			AssetFactory assetFactory = new AssetFactory();
			
			Set<AssetFood> foodAssets = null;
			foodAssets = assetFactory.fetchFoodAssets();
			
			detailObject = wrapFamilyDiets(household, allocation, detailObject, foodAssets);
			SFSObject sendObject = SFSObject.newInstance();
			sendObject.putSFSObject("gm_food_update", detailObject);
			send("gm_food_overview_updated", sendObject, bankerUser);
			
		} catch (Exception e) {
			Logger.ErrorLog("HomeMultiHandler.updateGMFoodDetail", "Unable to update GM food overview: " + e.getMessage());
		}
	}
	private SFSObject wrapAllocation(Allocation allocation) throws Exception {
		SFSObject allocationObj = SFSObject.newInstance();
		allocationObj.putInt("Id", allocation.getId());
		allocationObj.putUtfString("Name", allocation.getName());
		allocationObj.putInt("Hearth", allocation.getHousehold().getId());
		allocationObj.putInt("Selected", allocation.getSelected());

		AllocationItemFactory aif = new AllocationItemFactory();
		Set<AllocationItem> ais = aif.fetchAllocationItems(allocation);
		SFSArray aisArray = SFSArray.newInstance();
		for (AllocationItem ai: ais){
			SFSObject aiObj = SFSObject.newInstance();
			aiObj.putInt("Id", ai.getId());
			aiObj.putInt("Amount", ai.getAmount());
			aiObj.putInt("Character", ai.getCharacter().getId());
			aiObj.putInt("Asset", ai.getAsset().getId());
			aiObj.putInt("Allocation", allocation.getId());
			aisArray.addSFSObject(aiObj);
		}
		allocationObj.putSFSArray("AllocationItems", aisArray);
		return allocationObj;
	}
}
