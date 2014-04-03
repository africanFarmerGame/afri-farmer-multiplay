/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.handlers;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.AllChars;
import uk.ac.sussex.model.AllCharsFactory;
import uk.ac.sussex.model.Allocation;
import uk.ac.sussex.model.AllocationFactory;
import uk.ac.sussex.model.AllocationItem;
import uk.ac.sussex.model.AllocationItemFactory;
import uk.ac.sussex.model.Asset;
import uk.ac.sussex.model.AssetFactory;
import uk.ac.sussex.model.AssetOwner;
import uk.ac.sussex.model.AssetOwnerFactory;
import uk.ac.sussex.model.Bill;
import uk.ac.sussex.model.BillDeathDuty;
import uk.ac.sussex.model.BillFactory;
import uk.ac.sussex.model.DietaryLevels;
import uk.ac.sussex.model.Field;
import uk.ac.sussex.model.FieldFactory;
import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.HearthFactory;
import uk.ac.sussex.model.Message;
import uk.ac.sussex.model.NPC;
import uk.ac.sussex.model.NPCFactory;
import uk.ac.sussex.model.Player;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.model.Proposal;
import uk.ac.sussex.model.ProposalFactory;
import uk.ac.sussex.model.Role;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.tasks.TaskOption;
import uk.ac.sussex.utilities.GameHelper;
import uk.ac.sussex.utilities.Logger;
import uk.ac.sussex.utilities.UserHelper;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
import com.smartfoxserver.v2.entities.variables.UserVariable;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.extensions.SFSExtension;
import com.smartfoxserver.v2.annotations.MultiHandler;
import com.smartfoxserver.v2.api.ISFSApi;

@MultiHandler
public class VillageMultiHandler extends BaseClientRequestHandler {

	@Override
	public void handleClientRequest(User user, ISFSObject params) {
		String requestId = params.getUtfString(SFSExtension.MULTIHANDLER_REQUEST_ID);
	    try {
		    switch(VillageMultiEnum.toOption(requestId)) {
		    case GET_HEARTH_DETAILS: 
		    	Logger.Log(user.getName(), "Requested the hearth details from VillageMultiHandler");
	     		this.getHearthDetails(user);
		    	break;
		    case GET_VILLAGE_OVERVIEW:
		    	Logger.Log(user.getName(), "Asked for village overview details");
		    	this.getVillageOverview(user);
		    	 
		    	break;
		    case GET_HEARTH_ASSETS:
		    	Integer hearthId = params.getInt("hearthId");
		    	Logger.Log(user.getName(), "Asked for hearth assets for hearth " + hearthId.toString());
		    	this.getHearthAssets(user, hearthId);
		    	break;
		    case GET_GIVE_ASSETS:
		    	Logger.Log(user.getName(), "Asked for the list of assets they have to give away.");
		    	this.getGiveAssets(user);
		    	break;
		    case GIVE_ASSET:
		    	Logger.Log(user.getName(), "Attempted to give an asset");
		    	this.giveAsset(user, params);
		    	break;
		    case FETCH_HEARTHS_OVERVIEW:
		    	Logger.Log(user.getName(), "Requested manager's hearthOverview data");
	    		this.fetchHearthsOverview(user);
		    	break;
		    case FETCH_HEARTHLESS:
		    	Logger.Log(user.getName(), "Requested a list of the hearthless");
		    	this.fetchHearthless(user);
		    	break;
		    case FETCH_VILLAGE_MEMBERS:
		    	Logger.Log(user.getName(), "Requested the village member details");
		    	this.fetchVillageMembers(user);
		    	break;
		    case SUBMIT_PROPOSAL:
		    	Logger.Log(user.getName(), "Tried to propose");
		    	this.submitProposal(user, params);
		    	break;
		    case REQUEST_PROPOSALS:
		    	Logger.Log(user.getName(), "Requested the list of proposals");
		    	this.fetchProposalList(user);
		    	break;
		    case UPDATE_PROPOSAL:
		    	Logger.Log(user.getName(), "Wants to update a proposal");
		    	Integer propId = params.getInt("Id");
		    	Logger.Log(user.getName(), "Sent proposal " + propId + " to update.");
		    	this.updateProposal(params, user);
		    	break;
		    case FETCH_DEAD:
		    	Logger.Log(user.getName(), "Has requested the list of the dead.");
		    	this.fetchDead(user);
		    	break;
		    case RESURRECT:
		    	Logger.Log(user.getName(), "Is attempting a resurrection.");
		    	this.attemptResurrection(user, params);
		    	break;
		    default:
		    	Logger.Log(user.getName(), "Tried to ask for " + requestId + " from VillageMultiHandler");
		        ISFSObject errObj = new SFSObject();
		        errObj.putUtfString("message", "Unable to action request "+requestId);
		        send("villageError", errObj, user);
		        break;
		    }
	    } catch (Exception e) {
	    	String errorMsg = "Unable to process request " + requestId + ": " + e.getMessage();
   		 	Logger.ErrorLog("VillageMultiHandler.handleClientRequest("+ requestId + ")", errorMsg);
   		 
   		 	SFSObject errorObj = SFSObject.newInstance();
   		 	errorObj.putUtfString("message", errorMsg);
   		 	send(requestId + "_error", errorObj, user);
	    }
	}
	private void getHearthDetails(User user) throws Exception {
		//What data structure to send back?!
		HearthFactory hf = new HearthFactory();
		UserVariable pcObjVar = user.getVariable("pc");
		ISFSObject pcObj = pcObjVar.getSFSObjectValue();
		
		Integer pcId = pcObj.getInt("id");
		
		PlayerCharFactory pcf = new PlayerCharFactory();
		PlayerChar pc = pcf.fetchPlayerChar(pcId);
		
		Set<Hearth> hearths = hf.fetchGameHearths(pc.getGame());
		
		ISFSObject returnObj = new SFSObject();
		SFSArray returnData = new SFSArray();
		for(Hearth hearth : hearths) {
			SFSObject hearthObj = new SFSObject();
			hearthObj.putInt("ID", hearth.getId());
			hearthObj.putUtfString("HearthName", hearth.getName());
			hearthObj.putInt("HouseNumber", hearth.getHousenumber());
			returnData.addSFSObject(hearthObj);
		}
		returnObj.putSFSArray("HearthDetails", returnData);
		send("hearthslist", returnObj, user);
	}
	private void getVillageOverview(User user) throws Exception {
		
		Game game = UserHelper.fetchUserGame(user);
		
		SFSObject dataObj = SFSObject.newInstance();
		dataObj.putUtfString("VillageName", game.getVillageName());
		
		HearthFactory hf = new HearthFactory();
		Set<Hearth> hearths = hf.fetchGameHearths(game);
		dataObj.putInt("NumberHearths", hearths.size());
		//Number of adults should be different.
		int numAdults = 0;
		int numChildren = 0;
		for(Hearth hearth: hearths){
			numAdults += hearth.fetchNumberOfAdults();
			//numAdults += hearth.getCharacters().size(); This is included in the count from the hearth. 
			numChildren += hearth.fetchNumberOfChildren();
		}
		//Also need to add the hearthless
		PlayerCharFactory pcf = new PlayerCharFactory();
		Set<PlayerChar> hearthless = pcf.fetchHearthlessPCs(game);
		numAdults += hearthless.size();
		
		dataObj.putInt("NumberAdults", numAdults); //This should be more complicated.
		dataObj.putInt("NumberChildren", numChildren);
		
		send("villageoverview", dataObj, user);
	}
	private void getHearthAssets(User user, Integer hearthId) throws Exception {
		HearthFactory hf = new HearthFactory();
		Hearth hearth = hf.fetchHearth(hearthId);
		
		SFSObject dataObj = SFSObject.newInstance();
		dataObj.putUtfString("HearthName", hearth.getName());
		//TODO: Add more info about each adult and child. 
		dataObj.putInt("NumberAdults", hearth.fetchNumberOfAdults());
		dataObj.putInt("NumberChildren", hearth.fetchNumberOfChildren());
		dataObj.putDouble("SocialStatus", hearth.getSocialStatus());
		FieldFactory ff = new FieldFactory();
		List<Field> hearthFields = ff.getHearthFields(hearth);
		dataObj.putInt("NumberFields", hearthFields.size());
		
		SFSArray hearthHeads = SFSArray.newInstance();
		Set<PlayerChar> characters = hearth.getCharacters();
		for (PlayerChar character : characters){
			if(character.getPlayer()!= null){
				hearthHeads.addUtfString(character.getDisplayName());
			}
		}
		dataObj.putSFSArray("HearthHeads", hearthHeads);
		
		
		send("hearthassets", dataObj, user);
	}
	private void getGiveAssets(User user) throws Exception{
		AssetFactory assetFactory = new AssetFactory();
		PlayerChar pc = UserHelper.fetchUserPC(user);
		Hearth hearth = pc.getHearth();
		HearthFactory hf = new HearthFactory();
		if(hearth!=null){
			hearth = hf.fetchHearth(hearth.getId());
		}
		
		Set<Asset> assets = assetFactory.fetchAssets();
		SFSArray pcAssetsArray = SFSArray.newInstance();
		SFSArray hearthAssetsArray = SFSArray.newInstance();
		for(Asset asset: assets){
			Double playerAmount = asset.fetchAmountPlayerOwns(pc);
			if(playerAmount != null){
				
				SFSObject pcAsset = translatePrivateAssets(asset.fetchAmountPlayerOwns(pc), asset.getId(), "P", null);
				pcAssetsArray.addSFSObject(pcAsset);
			}
			if(hearth!=null){
				Double hearthAmount = asset.fetchAmountHearthOwn(hearth);
				if(hearthAmount!=null){
					List<TaskOption> sellOptions = asset.fetchHearthSellOptions(hearth);
					SFSObject hearthAsset = translatePrivateAssets(asset.fetchAmountHearthOwn(hearth), asset.getId(), "H", sellOptions);
					hearthAssetsArray.addSFSObject(hearthAsset);
				}
			}
		}
		SFSObject sendObject = SFSObject.newInstance();
		sendObject.putSFSArray("PCAssetDetails", pcAssetsArray);
		sendObject.putSFSArray("hearthAssetDetails", hearthAssetsArray);
		send("get_give_assets_success", sendObject, user);
	}
	private void giveAsset(User user, ISFSObject params) throws Exception {
		Integer assetId = params.getInt("GiveAssetId");
		Integer recipientId = params.getInt("GiveHearth");
		Double quantity = params.getDouble("GiveAssetAmount");
		Double actualQuantity = params.getDouble("GiveAssetAmount");
		Integer optionId = params.getInt("GiveAssetOption");
		
		PlayerChar pc = UserHelper.fetchUserPC(user);
		
		HearthFactory hf = new HearthFactory();
		AssetFactory af = new AssetFactory();
		Asset giveAsset = null;
		try {
			giveAsset = af.fetchAsset(assetId);
		} catch (Exception e) {
			throw new Exception ("Unable to find asset " + assetId + ": " + e.getMessage());
		}
		Hearth recipientHearth = null; 
		try {
			recipientHearth = hf.fetchHearth(recipientId);
		} catch (Exception e) {
			throw new Exception ("Unable to find hearth " + recipientId + ": " + e.getMessage());
		}
		
		String successMessage = null;
		if(!pc.getRole().getId().equals(Role.BANKER)){
			Hearth giveHearth = pc.getHearth();
			if(giveHearth!=null){
				giveHearth = hf.fetchHearth(giveHearth.getId());
			//AssetOwner giveAssetOwner = aof.fetchSpecificAsset(giveHearth, giveAsset);
			
			//Double giveAssetOwnerAmount = giveAssetOwner.getAmount();
				if(optionId==null||optionId==0){
					Logger.Log(user.getName(), "Trying to give " + quantity.toString() + " of asset " + giveAsset.getName() + " to Hearth " + recipientId) ;
					try {
						actualQuantity = giveAsset.giveAssetAmount(giveHearth, recipientHearth, quantity);
					} catch(Exception e){
						throw new Exception("Unable to complete giving. " + e.getMessage());
					}
					if(actualQuantity.equals(quantity)){
						successMessage = "Congratuations";
						successMessage += "\nYou have given " + actualQuantity.toString() + " " + giveAsset.getMeasurement() + "(s) of " + giveAsset.getName() + " from your hearth to Hearth " + recipientHearth.getName();
					} else {
						successMessage = "Not Quite";
						successMessage += "\nYou tried to give " + quantity.toString() + " " + giveAsset.getMeasurement() + "(s) of " + giveAsset.getName() + " from your hearth to Hearth " + recipientHearth.getName();
						successMessage += "\nSadly, you didn't have enough.";
						successMessage += "\nYou have given " + actualQuantity.toString() + " " + giveAsset.getMeasurement() + "(s) of " + giveAsset.getName();
					}
					//Need to send the updated asset amounts for the give hearth.
					List<User> giveFamily = GameHelper.fetchOnlineHearthUsers(getApi(), giveHearth);
					SFSArray giveFamilyAssetsArray = SFSArray.newInstance();
					giveFamilyAssetsArray.addSFSObject(translatePrivateAssets(giveAsset.fetchAmountHearthOwn(giveHearth), giveAsset.getId(), "H", giveAsset.fetchHearthSellOptions(giveHearth)));
					
					SFSObject giveFamilyAssets = SFSObject.newInstance();
					giveFamilyAssets.putSFSArray("HearthAssets", giveFamilyAssetsArray);
					send("HearthAssetsUpdated", giveFamilyAssets, giveFamily);
					
				} else {
					Logger.Log(user.getName(), "Trying to give option " + optionId.toString() + " of asset " + giveAsset.getName() + " to Hearth " + recipientId) ;
					Boolean success  = false;
					try {
						success = giveAsset.giveSpecificAsset(giveHearth, recipientHearth, optionId);
					} catch (Exception e) {
						throw new Exception("Unable to complete giving. " + e.getMessage());
					}
					if(success){
						successMessage = "Congratulations";
						successMessage += "\nYou transferred 1 " + giveAsset.getMeasurement() + " of " + giveAsset.getName() + " from your hearth to Hearth " + recipientHearth.getName() + ".";
					} else {
						successMessage = "Sorry";
						successMessage += "\n You were not able to transfer the " + giveAsset.getName() + " to Hearth " + recipientHearth.getName() + " at this time.";
					}
				}
			}
		} else {
			Logger.Log(user.getName(), "Banker is trying to give " + quantity.toString() + " of asset " + giveAsset.getName() + " to Hearth " + recipientId) ;
			try {
				actualQuantity = giveAsset.giveAssetAmountFromBanker(recipientHearth, quantity);
			} catch (Exception e) {
				throw new Exception("Problem transfering the assets. " + e.getMessage());
			}
			successMessage = "You managed to give " + actualQuantity.toString() + " " + giveAsset.getMeasurement() + "(s) of " + giveAsset.getName() + " to Hearth " + recipientHearth.getName();
		}
		
		SFSObject messageObj = SFSObject.newInstance();
		
		messageObj.putUtfString("message", successMessage);
		send("give_asset_success", messageObj, user);
		
		//Need to send the updated asset amounts for the recipient hearth.
		if(!pc.getRole().getId().equals(Role.BANKER)){
			List<User> recipientFamily = GameHelper.fetchOnlineHearthUsers(getApi(), recipientHearth);
			SFSArray recipientFamilyAssetsArray = SFSArray.newInstance();
			recipientFamilyAssetsArray.addSFSObject(translatePrivateAssets(giveAsset.fetchAmountHearthOwn(recipientHearth), giveAsset.getId(), "H", giveAsset.fetchHearthSellOptions(recipientHearth)));
			
			SFSObject recipientFamilyAssets = SFSObject.newInstance();
			recipientFamilyAssets.putSFSArray("HearthAssets", recipientFamilyAssetsArray);
			send("HearthAssetsUpdated", recipientFamilyAssets, recipientFamily);
		}
		
	}
	private void fetchHearthsOverview(User user) throws Exception {
		Game game = UserHelper.fetchUserGame(user);
		HearthFactory hf = new HearthFactory();
		Set<Hearth> hearths = hf.fetchGameHearths(game);
		SFSArray hearthDetails = SFSArray.newInstance();
		for (Hearth hearth: hearths) {
			SFSObject hearthObj = translateHearth(hearth);
			hearthDetails.addSFSObject(hearthObj);
		}
		SFSObject sendObj = SFSObject.newInstance();
		sendObj.putSFSArray("HearthDetails", hearthDetails);
		send("HearthsOverview", sendObj, user);
	}
	private void fetchHearthless(User user) throws Exception {
		Game game = UserHelper.fetchUserGame(user);
		PlayerCharFactory pcf = new PlayerCharFactory();
		Set<PlayerChar> pcs = pcf.fetchHearthlessPCs(game);
		SFSArray hearthless = SFSArray.newInstance();
		for(PlayerChar pc: pcs){
			SFSObject pcObject = translatePlayerChar(pc);
			hearthless.addSFSObject(pcObject);
		}
		SFSObject sendObj = SFSObject.newInstance();
		sendObj.putSFSArray("Hearthless", hearthless);
		send("HearthlessPlayers", sendObj, user);
	}
	private void fetchVillageMembers(User user) throws Exception {
		//This needs to get all of the members of the village that can be moved between households. 
		//A list of households helps to make it more navigable. 
		Game game = UserHelper.fetchUserGame(user);
		Set<Hearth> hearths = game.fetchHearths();
		PlayerCharFactory pcf = new PlayerCharFactory();
		Set<PlayerChar> players = pcf.fetchAll(game);
		NPCFactory npcf = new NPCFactory();
		Set<NPC> nonPlayers = new HashSet<NPC>();
		SFSArray hearthObjects = SFSArray.newInstance();
		for (Hearth hearth: hearths){
			SFSObject hearthObj = translateHearth(hearth);
			hearthObjects.addSFSObject(hearthObj);
			nonPlayers.addAll(npcf.fetchHearthChildren(hearth));
		}
		SFSArray playerObjects = SFSArray.newInstance();
		for (PlayerChar pc: players){
			if(!pc.getAlive().equals(AllChars.DEAD)&&!pc.getRole().getId().equals(Role.BANKER)){
				SFSObject pcObj = translatePlayerChar(pc);
				playerObjects.addSFSObject(pcObj);
			}
		}
		SFSArray npcObjects = SFSArray.newInstance();
		for (NPC npc: nonPlayers){
			if(!npc.getAlive().equals(AllChars.DEAD)){
				SFSObject npcObject = SFSObject.newInstance();
				npcObject.putInt("ID", npc.getId());
				npcObject.putUtfString("familyname", npc.getFamilyName());
				npcObject.putUtfString("firstname", npc.getName());
				npcObject.putUtfString("Role", npc.getRole().getId());
				npcObject.putInt("AvatarBody", npc.getAvatarBody());
				npcObject.putInt("HearthId", npc.getHearth().getId());
				npcObject.putInt("Age", npc.getAge());
				npcObjects.addSFSObject(npcObject);
			}
		}
		SFSObject sendObject = SFSObject.newInstance();
		sendObject.putSFSArray("Hearths", hearthObjects);
		sendObject.putSFSArray("PlayerChars", playerObjects);
		sendObject.putSFSArray("NPCs", npcObjects);
		send("VillageMembers", sendObject, user);
	}
	private void submitProposal(User user, ISFSObject params) throws Exception{
		Integer proposerId = params.getInt("Proposer");
		Integer proposerHearthId = params.getInt("ProposerHearth");
		Integer targetId = params.getInt("Target");
		Integer targetHearthId = params.getInt("TargetHearth");
		
		HearthFactory hf = new HearthFactory();
		Hearth proposerHearth = null;
		Hearth targetHearth = null;
		if(proposerHearthId>0){
			try {
				proposerHearth = hf.fetchHearth(proposerHearthId);
			} catch (Exception e) {
				throw new Exception ("Unable to fetch proposer's household " + proposerHearthId + ": " + e.getMessage());
			}
		}
		try {
			targetHearth = hf.fetchHearth(targetHearthId);
		} catch (Exception e) {
			throw new Exception ("Unable to fetch target household " + targetHearthId + ": " + e.getMessage());
		}
		
		PlayerCharFactory pcf = new PlayerCharFactory();
		PlayerChar proposer = null;
		try{
			proposer = pcf.fetchPlayerChar(proposerId);
		} catch (Exception e){
			throw new Exception ("Unable to find the proposer " + proposerId + ": " + e.getMessage());
		}
		AllCharsFactory acf = new AllCharsFactory();
		AllChars target = null;
		try {
			target = acf.fetchAllChar(targetId);
		} catch (Exception e) {
			throw new Exception ("Unable to find the target " + targetId + ": " + e.getMessage());
		}
		Proposal proposal = new Proposal();
		proposal.setProposer(proposer);
		proposal.setProposerHearth(proposerHearth);
		proposal.setTarget(target);
		proposal.setTargetHearth(targetHearth);
		proposal.setCurrentHearth(target.getHearth());
		proposal.save();
		Logger.Log(user.getName(), "Generated proposal id " + proposal.getId());
		
		//Need to send the proposal back to the user and the other household in the view. Will need to do this a couple of times.
		sendToInterestedParties(proposal, true);
	} 
	private void fetchProposalList(User user) throws Exception {
		ProposalFactory pf = new ProposalFactory();
		List<Proposal> incomingProps = null;
		List<Proposal> outgoingProps = null;
		
		PlayerChar pc = UserHelper.fetchUserPC(user);
		Hearth pcHome = pc.getHearth();
		if(pcHome == null){
			//We're dealing with the personal proposal list.
			Logger.Log(user.getName(), "Retrieving proposal list for individual " + pc.getId());
			try {
				incomingProps = pf.fetchIncomingPersonProposals(pc);
			} catch (Exception e) {
				throw new Exception ("Problem fetching incoming proposals for pc " + pc.getId() );
			}
			try {
				outgoingProps = pf.fetchOutgoingPersonProposals(pc);
			} catch(Exception e) {
				throw new Exception ("Problem fetching outgoing proposals for player char " + pc.getId());
			}
		} else {
			//We're dealing with the hearth's list.
			Logger.Log(user.getName(), "Retrieving proposal list for hearth " + pc.getHearth().getId());
			try{
				incomingProps = pf.fetchIncomingHearthProposals(pcHome);
			} catch (Exception e) {
				throw new Exception ("Problem fetching incoming hearth proposals for hearth " + pcHome.getId());
			}
			try {
				outgoingProps= pf.fetchOutgoingHearthProposals(pcHome);
			} catch (Exception e) {
				throw new Exception ("Problem fetching outgoing hearth proposals for hearth " + pcHome.getId());
			}
		}
		if(incomingProps!=null){
			incomingProps.addAll(outgoingProps);
		} else {
			incomingProps = outgoingProps;
		}
		SFSArray proposalArray = SFSArray.newInstance();
		for (Proposal prop : incomingProps){
			SFSObject propObj = this.translateProposal(prop);
			proposalArray.addSFSObject(propObj);
		}
		SFSObject sendObj = SFSObject.newInstance();
		sendObj.putSFSArray("Proposals", proposalArray);
		send("ProposalList", sendObj, user);
	}
	private void updateProposal(ISFSObject propObj, User user) throws Exception {
		//The only things I can think that can change are the status or the delete.
		Game game = UserHelper.fetchUserGame(user);
		Integer propId = propObj.getInt("Id");
		Integer status = propObj.getInt("Status");
		Integer deleted = propObj.getInt("Deleted" );
		ProposalFactory propFactory = new ProposalFactory();
		Proposal currentProp = null;
		try {
			currentProp = propFactory.fetchProposal(propId);
		} catch (Exception e) {
			throw new Exception ("Problem fetching proposal with id " + propId + ": " + e.getMessage());
		}
		if(!deleted.equals(currentProp.getDeleted())){
			//Go ahead and delete, but we can't actually get here yet so I will ignore it.
			currentProp.setDeleted(deleted);
		}
		//If the proposal is anything but pending we can't update it. 
		if((currentProp.getStatus()==Proposal.PENDING) && !status.equals(currentProp.getStatus())){
			//We need to do some potentially serious stuff here, but only if it's an accept.
			if(status.equals(Proposal.ACCEPTED)){
				this.acceptProposal(currentProp, game);
				Logger.Log(user.getName(), "Accepted the proposal id " + propId);
			} else {
				Logger.Log(user.getName(), "Did not accept the proposal id " + propId);
			}
			currentProp.setStatus(status);
		}
		currentProp.save();
		sendToInterestedParties(currentProp, false);
		
	}
	private void sendToInterestedParties(Proposal proposal, Boolean andMessage) throws Exception {
		//Who might be interested?!
		Integer propHearthId;
		if(proposal.getProposerHearth()!=null){
			propHearthId = proposal.getProposerHearth().getId();
		} else {
			propHearthId = 0;
		}
		Integer targetHearthId = proposal.getTargetHearth().getId();
		HearthFactory hf = new HearthFactory();
		PlayerCharFactory pcf = new PlayerCharFactory();
		Set<PlayerChar> pcs;
		if(propHearthId.equals(0)){
			pcs = new HashSet<PlayerChar>();
			PlayerChar proposer = pcf.fetchPlayerChar(proposal.getProposer().getId());
			pcs.add(proposer);
		} else {
			Hearth proposerHearth = hf.fetchHearth(propHearthId);
			pcs = proposerHearth.getCharacters();
		}
		Set<PlayerChar> targets;
		if(propHearthId.equals(targetHearthId)){
			if(proposal.getCurrentHearth()!=null){
				Hearth currentHearth = hf.fetchHearth(proposal.getCurrentHearth().getId());
				targets = currentHearth.getCharacters();
			} else {
				
				PlayerChar target = pcf.fetchPlayerChar(proposal.getTarget().getId());
				targets = new HashSet<PlayerChar>();
				targets.add(target);
			}
		} else {
			Hearth targetHearth = hf.fetchHearth(targetHearthId);
			targets = targetHearth.getCharacters();
		}
		SFSObject propObj = this.translateProposal(proposal);
		
		ISFSApi isfsApi = this.getApi();
		List<User> users = new ArrayList<User>();
		for (PlayerChar pc : pcs) {
			Player possible = pc.getPlayer();
			if(possible!=null){
				User possUser = isfsApi.getUserByName(possible.getLoginName());
				if(possUser!=null){
					users.add(possUser);
				}
			}
		}
		for (PlayerChar pc: targets){
			Player possible = pc.getPlayer();
			User possUser = null;
			if(possible!=null){
				possUser = isfsApi.getUserByName(possible.getLoginName());
				if(possUser!=null){
					users.add(possUser);
				}
			}
			try{
				createAndSendProposalMessage(pc, possUser);
			} catch (Exception e) {
				Logger.ErrorLog("VillageMultiHandler.sendToInterestedParties", "Problem sending proposal message to pc " + pc.getId() + ": " + e.getMessage());
			}
		}
		SFSObject sendObj = SFSObject.newInstance();
		sendObj.putSFSObject("Proposal", propObj);
		send("ProposalUpdate", sendObj, users);
	}
	private void acceptProposal(Proposal prop, Game game) throws Exception {
		HearthFactory hf = new HearthFactory();
		AllCharsFactory acf = new AllCharsFactory();
		ProposalFactory propFactory = new ProposalFactory();
		AssetOwnerFactory aof = new AssetOwnerFactory();
		FieldFactory ff = new FieldFactory();
		
		//First up, let's get the target, and the target hearth.
		AllChars target = acf.fetchAllChar(prop.getTarget().getId());
		Hearth targetHearth = hf.fetchHearth(prop.getTargetHearth().getId());
		
		//First let's cancel any other proposals for this person. 
		List<Proposal> proposals = propFactory.fetchIncomingPersonProposals(target);
		for (Proposal proposal: proposals){
			proposal.setStatus(Proposal.DECLINED);
			proposal.save();
			sendToInterestedParties(proposal, false);
		}
		
		//Then we need to transfer any stuff owned by this individual.
		try{
			Set<AssetOwner> individualItems = aof.fetchPCAssets(target);
			Set<AssetOwner> hearthItems = aof.fetchHearthAssets(targetHearth);
			for(AssetOwner individualItem: individualItems){
				Integer assetId = individualItem.getAsset().getId();
				Boolean notFound = true;
				Iterator<AssetOwner> hearthItemIterator = hearthItems.iterator();
				while(notFound && hearthItemIterator.hasNext()){
					AssetOwner hearthItem = hearthItemIterator.next();
					if(hearthItem.getAsset().getId().equals(assetId)){
						notFound = false;
						hearthItem.setAmount(hearthItem.getAmount() + individualItem.getAmount());
						individualItem.setAmount(0.0);
						hearthItem.save();
						individualItem.save();
					}
				}
			}
		} catch (Exception e) {
			throw new Exception ("Problem transferring goods: " + e.getMessage());
		}
		try{
			List<Field> individualFields = ff.getPCFields(target);
			for(Field field : individualFields){
				field.setOwner(null);
				field.setHearth(targetHearth);
				field.save();
			}
		} catch (Exception e) {
			throw new Exception ("Problem transfering fields: " + e.getMessage());
		}
		//And finally log which hearth they are moving between.
		String leftHearthString;
		Hearth leftHearth = target.getHearth();
		if(leftHearth==null){
			leftHearthString = "none";
		} else {
			leftHearthString = target.getHearth().getId().toString();
		}
		target.setHearth(targetHearth);
		target.save();
		Logger.Log(target.getId().toString(), "Character " + target.getId() + " has left hearth " + leftHearthString + " for hearth " + targetHearth.getId() );
		SFSArray targetAllocationsObj = addPersonToHearthAllocations(targetHearth, target, game.getGameYear());
		
		//Now we need to update the hearth members for both the current and target hearth.
		//Definitely need to do the target hearth.
		updateHearthMembers(targetHearth, target, targetAllocationsObj);
		
		//If the current hearth is not null, need to do that too. 
		if(prop.getCurrentHearth()!=null){
			Hearth currentHearth = hf.fetchHearth(prop.getCurrentHearth().getId());
			SFSArray currentAllocationsObj = removePersonFromHearthAllocations(currentHearth, target, game.getGameYear());
			updateHearthMembers(currentHearth, target, currentAllocationsObj);
		}
		
		//And IF it's a playerchar, then I need to send that down too. 
		if(target instanceof PlayerChar){
			PlayerChar targetPC = (PlayerChar) target;
			Player targetPlayer = targetPC.getPlayer();
			if(targetPlayer!=null){
				ISFSApi isfsApi = this.getApi();;
				User possUser = isfsApi.getUserByName(targetPlayer.getLoginName());
				if(possUser!=null){
					SFSUserVariable pcUserVar = UserHelper.fetchUserVarPC(targetPC);
					
					List<UserVariable> currentUserVars = possUser.getVariables();
					currentUserVars.add(pcUserVar);
					getApi().setUserVariables(possUser, currentUserVars, true, false);
				}
			}
		}
		
	}
	private SFSObject translateProposal(Proposal prop) throws Exception {
		AllCharsFactory acf = new AllCharsFactory();
		HearthFactory hf = new HearthFactory();
		SFSObject propObj = SFSObject.newInstance();
		Integer propId = prop.getProposer().getId();
		AllChars proposer = acf.fetchAllChar(propId);
		propObj.putInt("ProposerId", propId);
		propObj.putUtfString("ProposerName", proposer.getDisplayName());
		Integer targetId = prop.getTarget().getId();
		AllChars target = acf.fetchAllChar(targetId);
		propObj.putInt("TargetId", targetId);
		propObj.putUtfString("TargetName", target.getDisplayName());
		if(prop.getProposerHearth()!=null){
			propObj.putInt("ProposerHearthId", prop.getProposerHearth().getId());
		} else {
			propObj.putNull("ProposerHearthId");
		}
		if(prop.getCurrentHearth()!=null){
			Hearth currentHearth = hf.fetchHearth(prop.getCurrentHearth().getId());
			propObj.putInt("CurrentHearthId", currentHearth.getId());
			propObj.putUtfString("CurrentHearthName", currentHearth.getName());
		} else {
			propObj.putNull("CurrentHearthId");
			propObj.putNull("CurrentHearthName");
		}
		
		Hearth targetHearth = hf.fetchHearth(prop.getTargetHearth().getId());
		propObj.putInt("TargetHearthId", targetHearth.getId());
		propObj.putUtfString("TargetHearthName", targetHearth.getName());
		propObj.putInt("Id", prop.getId());
		propObj.putInt("Status", prop.getStatus());
		propObj.putInt("Deleted", prop.getDeleted());
		return propObj;
	}
	private void updateHearthMembers(Hearth hearth, AllChars target, SFSArray allocations) throws Exception{
		try {
			ISFSApi isfsApi = this.getApi();
			List<User> hearthUsers = GameHelper.fetchOnlineHearthUsers(isfsApi, hearth);
			SFSObject sendObj = SFSObject.newInstance();
			sendObj.putInt("CharId", target.getId());
			sendObj.putInt("HearthId", target.getHearth().getId());
			SFSObject sendAllocationsObj = SFSObject.newInstance();
			sendAllocationsObj.putSFSArray("Allocations", allocations);
			send("HearthMemberHearthChange", sendObj, hearthUsers);
			send("AllocationsUpdated", sendAllocationsObj, hearthUsers);
		} catch (Exception e) {
			Logger.ErrorLog("VillageMultiHandler.updateHearthMembers", "Unable to update the members of hearth " + hearth.getId() + ": " + e.getMessage());
			throw new Exception("Problem updating hearth membership. Please log out and log in again to fix.");
		}
	}
	private void fetchDead(User user) throws Exception {
		Game game = null;
		try {
			game = UserHelper.fetchUserGame(user);
		} catch (Exception e) {
			String message = "Unable to find the game for user " + user.getName() + ": " + e.getMessage();
			throw new Exception(message);
		} 
		PlayerCharFactory pcf = new PlayerCharFactory();
		Set<PlayerChar> players;
		try {
			players = pcf.fetchAll(game);
		} catch (Exception e) {
			String message = "Unable to fetch players for game " + game.getGameName() + ": " + e.getMessage();
			throw new Exception(message);
		}
		
		SFSArray deadArray = SFSArray.newInstance();
		for (PlayerChar pc: players){
			if(pc.getAlive().equals(AllChars.DEAD)){
				SFSObject pcObj = translatePlayerChar(pc);
				deadArray.addSFSObject(pcObj);
			}
		}
		SFSObject sendObject = SFSObject.newInstance();
		sendObject.putSFSArray("Dead", deadArray);
		send("dead_fetched", sendObject, user);
	}
	private void attemptResurrection(User user, ISFSObject params) throws Exception{
		Integer charId = params.getInt("CharId");
		if(charId==null||charId==0){
			throw new Exception("The character id submitted for resurrection was not valid: " + charId.toString());
		}
		Logger.Log(user.getName(), "Is attempting to resurrect character " + charId.toString());
		AllCharsFactory acf = new AllCharsFactory();
		AllChars character = acf.fetchAllChar(charId);
		character.setAlive(AllChars.ALIVE);
		character.setDiet(DietaryLevels.C);	//Needs setting for completeness.
		character.save();
		Logger.Log(user.getName(), "Successfully resurrected character " + charId + " (" + character.getDisplayName() + ")");
		
		//Now I need to deal with the death duty. 
		BillFactory bf = new BillFactory();
		List<Bill> deathDuties = bf.fetchUnpaidCharacterBill(BillDeathDuty.NAME, character);
		for (Bill deathDuty: deathDuties){
			deathDuty.payBill();
			Logger.Log(user.getName(), "As part of resurrection paid bill " + deathDuty.getId());
		}
		
		//And add them back into all current diet allocations.
		Game game = UserHelper.fetchUserGame(user);
		HearthFactory hf = new HearthFactory();
		Hearth hearth = hf.fetchHearth(character.getHearth().getId());
		SFSArray householdAllocations = addPersonToHearthAllocations(hearth, character, game.getGameYear());
		
		//Might need to send all this out to the family.
		List<User> family = GameHelper.fetchOnlineHearthUsers(getApi(), hearth);
		
		SFSObject allocSendObj = SFSObject.newInstance();
		
		allocSendObj.putSFSArray("Allocations", householdAllocations);
		send("AllocationsUpdated", allocSendObj, family);
		
		//Need to send this to the gm too.
		family.add(user);
		
		SFSObject resurrectionObj = SFSObject.newInstance();
		resurrectionObj.putUtfString("Message", "Character " + character.getDisplayName() + " has been successfully resurrected.");
		resurrectionObj.putInt("CharId", character.getId());
		send("FamilyMemberResurrected", resurrectionObj, family);
	}
	
	/**
	 * translatePrivateAssets returns a consistently wrapped asset object to send to the front end.
	 * @param amount Double The amount of the asset the person/hearth holds.
	 * @param assetId Integer Id of the asset.
	 * @param owner String Either H or P depending on whether it is hearth owned or player owned. 
	 * @param sellOptions List<TaskOption> is null if the player just sells an amount. 
	 * @return SFSObject wrapped asset.
	 */
	private SFSObject translatePrivateAssets(Double amount, Integer assetId, String owner, List<TaskOption> sellOptions){
		SFSObject output = SFSObject.newInstance();
		//output.putInt("Id", ao.getId());
		output.putDouble("Amount", amount);
		output.putInt("Asset", assetId);
		output.putUtfString("Owner", owner);
		if(sellOptions==null){
			output.putNull("SellOptions");
		} else {
			SFSArray optionArray = SFSArray.newInstance();
			for (TaskOption to: sellOptions){
				SFSObject option = translateTaskOptionToSFSObject(to);
				optionArray.addSFSObject(option);
			}
			output.putSFSArray("SellOptions", optionArray);
		}
		return output;
	}
	private SFSObject translateHearth(Hearth hearth){
		SFSObject hearthObj = SFSObject.newInstance();
		hearthObj.putInt("ID", hearth.getId());
		hearthObj.putUtfString("HearthName", hearth.getName());
		hearthObj.putInt("HearthFields", hearth.fetchFieldCount());
		hearthObj.putInt("HearthAdults", hearth.fetchNumberOfAdults());
		hearthObj.putInt("HearthChildren", hearth.fetchNumberOfChildren());
		hearthObj.putInt("HouseNumber", hearth.getHousenumber());
		return hearthObj;
	}
	private SFSObject translatePlayerChar(PlayerChar pc){
		SFSObject pcObject = SFSObject.newInstance();
		pcObject.putInt("id", pc.getId());
		pcObject.putUtfString("firstname", pc.getName());
		pcObject.putUtfString("familyname", pc.getFamilyName());
		pcObject.putUtfString("role", pc.getRole().getId());
		pcObject.putBool("online", isOnline(pc));
		if(pc.getHearth() == null){
			pcObject.putNull("hearthid");	//This should be true for the homeless
		} else {
			pcObject.putInt("hearthid", pc.getHearth().getId());
		}
		pcObject.putInt("avatarbody", pc.getAvatarBody());
		pcObject.putInt("fields", pc.getFieldCount());
		return pcObject;
	}
	private Boolean isOnline(PlayerChar pc) {
		Player player = pc.getPlayer();
		if(player!=null){
			User onlineUser = this.getApi().getUserByName(player.getLoginName());
			return(onlineUser!=null);
		}
		return false;
	}
	private void createAndSendProposalMessage(PlayerChar pc, User user) throws Exception{
		Message message = new Message();
		message.setBody("You have been sent a new proposal. Head to the village to see if you wish to accept.");
		message.setSubject("New proposal");
		message.setRecipient(pc);
		message.save();
		if(user!=null){
			//And send them the message alerting them to the new proposal.
			SFSObject sfsMessage = SFSObject.newInstance();
			sfsMessage.putInt("Id", message.getId());
			sfsMessage.putInt("Recipient", message.getRecipient().getId());
			sfsMessage.putUtfString("Subject", message.getSubject());
			sfsMessage.putUtfString("Body", message.getBody());
			sfsMessage.putInt("Deleted", message.getDeleted());
			sfsMessage.putInt("Unread", message.getUnread());
			sfsMessage.putLong("Timestamp", message.getTimestamp());
			SFSObject sendObj = SFSObject.newInstance();
			sendObj.putSFSObject("Message", sfsMessage);
			send("IncomingSystemMessage", sfsMessage, user);
		}
	}
	private SFSArray addPersonToHearthAllocations(Hearth hearth, AllChars character, Integer year) throws Exception{
		SFSArray allocationArrayObj = SFSArray.newInstance();
		AllocationFactory allocationFactory = new AllocationFactory();
		AllocationItemFactory allocItemFactory = new AllocationItemFactory();
		Set<Allocation> targetAllocations = allocationFactory.fetchHearthAllocations(hearth, year);
		for (Allocation targetAlloc: targetAllocations){
			if(character.isAdult()){
				allocItemFactory.createAdultAllocationItems(character, targetAlloc);
			} else {
				allocItemFactory.createChildAllocationItems(character, targetAlloc);
			}
			SFSObject allocationObj = wrapAllocation(targetAlloc, allocItemFactory);
			allocationArrayObj.addSFSObject(allocationObj);
		}
		return allocationArrayObj;
	}
	private SFSArray removePersonFromHearthAllocations(Hearth hearth, AllChars character, Integer year) throws Exception {
		SFSArray allocationArrayObj = SFSArray.newInstance();
		AllocationFactory allocationFactory = new AllocationFactory();
		AllocationItemFactory allocItemFactory = new AllocationItemFactory();
		Set<Allocation> targetAllocations = allocationFactory.fetchHearthAllocations(hearth, year);
		for (Allocation targetAlloc: targetAllocations){
			allocItemFactory.removeCharAllocationItems(character, targetAlloc);
			SFSObject allocationObj = wrapAllocation(targetAlloc, allocItemFactory);
			allocationArrayObj.addSFSObject(allocationObj);
		}
		return allocationArrayObj;
	}
	private SFSObject wrapAllocation(Allocation allocation, AllocationItemFactory allocItemFactory) throws Exception{
		SFSObject allocationObj = SFSObject.newInstance();
		allocationObj.putInt("Id", allocation.getId());
		allocationObj.putUtfString("Name", allocation.getName());
		allocationObj.putInt("Hearth", allocation.getHousehold().getId());
		allocationObj.putInt("Selected", allocation.getSelected());
		//Send the allocation
		Set<AllocationItem> ais = allocItemFactory.fetchAllocationItems(allocation);
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
	private SFSObject translateTaskOptionToSFSObject(TaskOption to) {
		SFSObject toObj = SFSObject.newInstance();
		toObj.putInt("Value", to.getValue());
		toObj.putUtfString("Name", to.getName());
		toObj.putUtfString("Type", to.getType());
		toObj.putInt("Status", to.getStatus());
		switch (to.getStatus()){
			case TaskOption.VALID:
				toObj.putNull("Notes");
				break;
			case TaskOption.INVALID:
				toObj.putUtfString("Notes", to.getNotes());
				break;
		}
		return toObj;
	}
}
