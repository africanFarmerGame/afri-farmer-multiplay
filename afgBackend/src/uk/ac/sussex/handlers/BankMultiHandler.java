/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.handlers;

import java.util.Iterator;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.utilities.GameHelper;
import uk.ac.sussex.utilities.Logger;
import uk.ac.sussex.utilities.UserHelper;

import com.smartfoxserver.v2.annotations.MultiHandler;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.extensions.SFSExtension;

@MultiHandler
public class BankMultiHandler extends BaseClientRequestHandler {

	@Override
	public void handleClientRequest(User user, ISFSObject params) {

		String requestId = params.getUtfString(SFSExtension.MULTIHANDLER_REQUEST_ID);
		try {
			switch(BankMultiEnum.toOption(requestId)) {
				case GET_HEARTH_FINES:
					Integer hearthId = params.getInt("hearthId");
					Logger.Log(user.getName(), "Requested the hearth fines for hearth " + hearthId);
					sendHearthFines(user, hearthId);
					break;
				case PAY_FINE:
					Integer fineId = params.getInt("FineId");
					Logger.Log(user.getName(), "Attempted to pay fine " + fineId);
					payFine(user, fineId);
					break;
				case FETCH_FINANCIAL_DETAIL:
					Integer hearthId1 = params.getInt("hearthId");
					Logger.Log(user.getName(), "Trying to get the detail for hearth " + hearthId1);
					this.fetchFinancialDetails(user, hearthId1);
					break;
				case FETCH_MANAGER_FINES:
					Logger.Log(user.getName(), "Asked for the manager's bills detail");
					this.fetchManagerFines(user);
					break;
				case FETCH_MANAGER_OVERVIEW:
					Logger.Log(user.getName(), "Wanted the manager's overview of the household assets.");
					this.fetchManagerOverview(user);
					break;
				default:
					Logger.Log(user.getName(), "Tried to ask for " + requestId + " from FarmMultiHandler");
		        	ISFSObject errObj = new SFSObject();
		        	errObj.putUtfString("message", "Unable to action request "+requestId);
		        	send("bankError", errObj, user);
		        	break;
			}
		} catch (Exception e) {
			ISFSObject errObj = SFSObject.newInstance();
	    	String message = "There has been a problem with request " + requestId + ": " +e.getMessage() ;
 			errObj.putUtfString("message", message);
 			Logger.ErrorLog("BankMultiHandler.handleClientRequest(" + requestId + ")", message);
 			send(requestId + "_error", errObj, user);
		}
	}
	private void sendHearthFines(User user, Integer hearthId) throws Exception {
		HearthFactory hf = new HearthFactory();
		Hearth hearth = hf.fetchHearth(hearthId);
		
		BillFactory finesFactory = new BillFactory();
		List<Bill> fines = finesFactory.fetchHearthFines(hearth);
		
		SFSArray finesArray = SFSArray.newInstance();
		for(Bill fine: fines){
			SFSObject fineObj = wrapFine(fine);
			finesArray.addSFSObject(fineObj);
		}
		SFSObject sendObject = SFSObject.newInstance();
		sendObject.putSFSArray("Fines", finesArray);
		send("get_hearth_fines_success", sendObject, user);
	}
	private void payFine(User user,Integer fineId) throws Exception{
		BillFactory finesFactory = new BillFactory();
		Bill fine = finesFactory.fetchFine(fineId);
		
		SFSObject sendObj = SFSObject.newInstance();
		String returnMessage = "";
		
		if (fine.getPaid().equals(Bill.BEEN_PAID)){
			returnMessage += "This charge has already been paid.";
			sendObj.putUtfString("message", returnMessage);
			send("pay_fine_success", sendObj, user);
		} else {
			Asset cash = fetchCash();
			Hearth hearth = fine.getPayee();
			AssetOwner cashOwner = fetchAssetOwner(hearth, cash);
			
			Double cashAmount = cashOwner.getAmount();
			Double earlyRate = fine.getEarlyRate();
			
			returnMessage += "You are trying to pay a charge of " + fine.getEarlyRate().intValue() + " " + cash.getMeasurement() + "s \n";
			returnMessage += "You currently have " + cashAmount.intValue() + " " + cash.getMeasurement() + "s \n";
			if(cashAmount>=earlyRate){
				//All is well. 
				cashOwner.setAmount(cashAmount - earlyRate);
				cashOwner.save();
				fine.payBill();
				returnMessage += "The fine has been successfully paid.";
				sendObj.putUtfString("message", returnMessage);
				send("pay_fine_success", sendObj, user);
				
				//Need to send fine to all the people in this room, 
				SFSObject fineObj = wrapFine(fine);
				SFSObject sendFine = SFSObject.newInstance();
				sendFine.putSFSObject("Fine", fineObj);
				
				//And an asset update. 
				SFSObject cashObj = translatePrivateAssets(cashOwner);
				List<User> family = GameHelper.fetchOnlineHearthUsers(this.getApi(), hearth);
				SFSArray familyAssetsArray = SFSArray.newInstance();
				familyAssetsArray.addSFSObject(cashObj);
				SFSObject familyAssets = SFSObject.newInstance();
				familyAssets.putSFSArray("HearthAssets", familyAssetsArray);
				send("HearthAssetsUpdated", familyAssets, family);
				send("FineUpdated", sendFine, family);
				updateGMBillsOverview(user, hearth, fineObj);
			} else {
				//We can't pay this fine right now. 
				returnMessage += "You don't have enough cash to pay that fine. Have you tried selling some assets?";
				sendObj.putUtfString("message", returnMessage);
				send("pay_fine_error", sendObj, user);
			}
		}
	}
	private void fetchFinancialDetails(User user, Integer hearthId) throws Exception {
		HearthFactory hf = new HearthFactory();
		Hearth hearth = hf.fetchHearth(hearthId);
		
		BillFactory billFactory = new BillFactory();
		List<Bill> outstandingBills = billFactory.AllOutstandingHearthFines(hearth);
		SFSObject details = SFSObject.newInstance();
		details.putInt("OutstandingBills", outstandingBills.size());
		
		send("FinancialDetails", details, user);
		
	}
	private void fetchManagerFines(User user) throws Exception {
		Game game = UserHelper.fetchUserGame(user);
		BillFactory billFactory = new BillFactory();
		List<Bill> allFines = billFactory.fetchAllGameHearthFines(game);
		SFSArray billArray = SFSArray.newInstance();
		for(Bill bill: allFines){
			billArray.addSFSObject(wrapFine(bill));
		}
		SFSObject sendObject = SFSObject.newInstance();
		sendObject.putSFSArray("Fines", billArray);
		send("AllBills",sendObject, user);
	}
	private void fetchManagerOverview(User user) throws Exception {
		PlayerChar banker = UserHelper.fetchUserPC(user);
		if(!banker.getRole().getId().equals(Role.BANKER)){
			throw new Exception("Insufficient privileges for viewing this information.");
		}
		Game game = UserHelper.fetchUserGame(user);
		
		HearthFactory hf = new HearthFactory();
		AssetOwnerFactory aoFactory = new AssetOwnerFactory();
		MarketAssetFactory maFactory = new MarketAssetFactory();
		BillFactory billFactory = new BillFactory();
		Set<MarketAsset> marketAssets = null;
		try {
			marketAssets = maFactory.fetchMarketAssets(game);
		} catch (Exception e) {
			Logger.ErrorLog("BankMultiHandler.fetchManagerOverview", "Problem getting the market assets for game " + game.getGameName() + ": " + e.getMessage());
			throw new Exception("Unable to access the market data to calculate household worth.");
		}
		
		Set<Hearth> hearths = hf.fetchGameHearths(game);
		SFSArray hearthDetails = SFSArray.newInstance();
		
		for(Hearth hearth : hearths){
			SFSObject hearthDetail = SFSObject.newInstance();
			hearthDetail.putInt("HearthId", hearth.getId());
			hearthDetail.putUtfString("HearthName", hearth.getName());
			try{
				Integer billsPending = billFactory.countHouseholdUnpaidBills(hearth);
				hearthDetail.putInt("PendingBills", billsPending);
			} catch (Exception e) {
				Logger.ErrorLog("BankMultiHandler.fetchManagerOverview", "Problem counting unpaid bills for hearth " + hearth.getId() + ": " + e.getMessage());
				hearthDetail.putInt("PendingBills", 0);
			}
			try{
				Double assetValue = 0.0;
				Double cashValue = 0.0;
				Set<AssetOwner> hearthAssets = aoFactory.fetchHearthAssets(hearth);
				for(AssetOwner hearthAsset: hearthAssets){
					Integer assetId = hearthAsset.getAsset().getId();
					//This is a list of non-cash assets.
					if(!assetId.equals(Asset.CASH)){
						Iterator<MarketAsset> maIterator = marketAssets.iterator();
						Boolean notFound = true;
						MarketAsset ma = null;
						while(maIterator.hasNext()&&notFound){
							ma = maIterator.next();
							if(ma.getAsset().getId().equals(assetId)){
								notFound = false;
							}
						}
						if(!notFound){
							assetValue += ma.getBuyPrice() * hearthAsset.getAmount();
						}
					} else {
						cashValue += hearthAsset.getAmount();
					}
				}
				hearthDetail.putDouble("HearthCash", cashValue);
				hearthDetail.putDouble("HearthAssets", assetValue);
				
			} catch (Exception e) {
				Logger.ErrorLog("BankMultiHandler.fetchManagerOverview", "Problem calculating cash value for hearth " + hearth.getId() + "'s assets: " + e.getMessage());
				hearthDetail.putDouble("HearthCash", 0);
				hearthDetail.putDouble("HearthAssets", 0);
			}
			hearthDetails.addSFSObject(hearthDetail);
		}
		SFSObject sendObj = SFSObject.newInstance();
		sendObj.putSFSArray("HearthOverviewDetails", hearthDetails);
		send("gm_manager_overview", sendObj, user);
	}
	private SFSObject translatePrivateAssets(AssetOwner ao){
		SFSObject output = SFSObject.newInstance();
		output.putInt("Id", ao.getId());
		output.putDouble("Amount", ao.getAmount());
		output.putInt("Asset", ao.getAsset().getId());
		if(ao.getOwner()!=null){
			output.putUtfString("Owner", "P");
		} else {
			output.putUtfString("Owner", "H");
		}
		return output;
	}
	private SFSObject wrapFine(Bill fine) {
		SFSObject fineObj = SFSObject.newInstance();
		fineObj.putInt("Id", fine.getId());
		fineObj.putInt("Payee", fine.getPayee().getId());
		fineObj.putUtfString("Description", fine.getDescription());
		fineObj.putDouble("EarlyRate", fine.getEarlyRate());
		fineObj.putDouble("LateRate", fine.getLateRate());
		fineObj.putInt("Season", fine.getSeason().getId());
		fineObj.putInt("Paid", fine.getPaid());
		return fineObj;
	}
	private Asset fetchCash() throws Exception {
		AssetFactory af = new AssetFactory();
		Asset cash = af.fetchAsset(8);
		return cash;
	}
	private AssetOwner fetchAssetOwner(Hearth hearth, Asset asset) throws Exception {
		AssetOwnerFactory aof = new AssetOwnerFactory();
		AssetOwner cashOwner = aof.fetchSpecificAsset(hearth, asset);
		return cashOwner;
	}
	private void updateGMBillsOverview(User user, Hearth hearth, SFSObject fineObj){
		Game game = null;
		try{
			game = UserHelper.fetchUserGame(user);
		} catch (Exception e) {
			Logger.ErrorLog("BankMultiHandler.updateGMBillsOverview", "Problem fetching game for user " + user.getName() + ": " + e.getMessage());
			return;
		}
		User banker = GameHelper.fetchBankerFromBank(getApi(), game);
		if(banker==null){
			//The banker isn't in the bank and doesn't care. 
			return;
		}
		//We have two things that they might be interested in. The actual fines, and the number unpaid.
		BillFactory billFactory = new BillFactory();
		AssetOwnerFactory aoFactory = new AssetOwnerFactory();
		AssetFactory assetFactory = new AssetFactory();
		try{
			Asset cash = assetFactory.fetchAsset(Asset.CASH);
			Integer unpaidFines = billFactory.countHouseholdUnpaidBills(hearth);
			AssetOwner cashOwner = aoFactory.fetchSpecificAsset(hearth, cash);
			SFSObject unpaidObj = SFSObject.newInstance();
			unpaidObj.putInt("HearthId", hearth.getId());
			unpaidObj.putDouble("HearthCash", cashOwner.getAmount());
			unpaidObj.putInt("PendingFines", unpaidFines);
			send("GMUnpaidBillsUpdated", unpaidObj, banker);
		} catch (Exception e) {
			Logger.ErrorLog("BankMultiHandler.updateGMBillsOverview", "Problem counting unpaid fines: " + e.getMessage());
		}
		send("GMUpdatedBill", fineObj, banker);
	}
}
