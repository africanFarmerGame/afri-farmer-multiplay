/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.states {
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import flash.display.Sprite;
	import uk.ac.sussex.view.FormMediator;
	import uk.ac.sussex.view.InStockAssetListMediator;
	import uk.ac.sussex.serverhandlers.ManagerHandlers;
	import uk.ac.sussex.controller.*;
	import uk.ac.sussex.view.HearthMediator;
	import uk.ac.sussex.view.SubMenuMediator;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.valueObjects.requestParams.*;
	import uk.ac.sussex.model.*;
	import uk.ac.sussex.serverhandlers.VillageHandlers;
	import org.puremvc.as3.multicore.interfaces.IFacade;

	/**
	 * @author em97
	 */
	public class VillageManagerGameState extends ManagerRoomState implements IGameState {
		public static const NAME:String = "VillageManagerGameState";
		public static const LOCATION_NAME:String = "VILLAGE";
		
		public function VillageManagerGameState(facade : IFacade) {
			super(facade, NAME);
		}
		override public function displayState():void{
			trace("You've reached the Village Manager Game State");
			super.displayState();
			ManagerHandlers.registerComponents(facade);
			//add commands
			registerCommands();
			//add proxies
			registerProxies();
			//add mediators
			registerMediators();
		}
		override public function cleanUpState():void{			
			//remove mediators
			removeMediators();
			//remove commands
			removeCommands();
			//remove proxies
			removeProxies();
			ManagerHandlers.removeComponents(facade);
			super.cleanUpState();
		}
		private function registerCommands():void{
			facade.registerCommand(VillageHandlers.HEARTH_LIST, HearthsStoreCommand);
			facade.registerCommand(HearthListProxy.HEARTH_ADDED, HearthsAddCommand);
			facade.registerCommand(VillageHandlers.VILLAGE_DETAILS, VillageDisplayOverviewCommand);
			facade.registerCommand(HearthMediator.HEARTH_SELECTED, HearthIconSelectedCommand);
			facade.registerCommand(VillageHandlers.HEARTH_ASSETS, VillageHearthAssetsReceivedCommand);
			facade.registerCommand(HearthMediator.HEARTH_DESELECTED, ResetInfoTextCommand);
			facade.registerCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED, SubMenuVillageManagerCommand);
			facade.registerCommand(VillageHandlers.GIVE_SUBMIT, SubmitGiveFormCommand);
			facade.registerCommand(VillageHandlers.GIVE_CANCEL, CancelGiveFormCommand);
			facade.registerCommand(InStockAssetListMediator.STOCK_ITEM_SELECTED, VillageManagerStockItemSelectCommand);
			facade.registerCommand(VillageHandlers.RES_FORM_CANCELLED, CancelGiveFormCommand);
			facade.registerCommand(VillageHandlers.DEAD_FETCHED, GMDeadReceivedCommand);
			facade.registerCommand(VillageHandlers.RES_HEARTH_UPDATED, ResHearthUpdatedCommand);
			facade.registerCommand(VillageHandlers.RES_FORM_SUBMITTED, ResFormSubmitCommand);
			facade.registerCommand(HomeHandlers.MEMBER_RESURRECTED, GMResurrectionCompleteCommand);
		}
		private function removeCommands():void{
			facade.removeCommand(VillageHandlers.HEARTH_LIST);
			facade.removeCommand(HearthListProxy.HEARTH_ADDED);
			facade.removeCommand(VillageHandlers.VILLAGE_DETAILS);
			facade.removeCommand(HearthMediator.HEARTH_SELECTED);
			facade.removeCommand(VillageHandlers.HEARTH_ASSETS);
			facade.removeCommand(HearthMediator.HEARTH_DESELECTED);
			facade.removeCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED);
			facade.removeCommand(VillageHandlers.GIVE_SUBMIT);
			facade.removeCommand(VillageHandlers.GIVE_CANCEL);
			facade.removeCommand(InStockAssetListMediator.STOCK_ITEM_SELECTED);
			facade.removeCommand(VillageHandlers.RES_FORM_CANCELLED);
			facade.removeCommand(VillageHandlers.DEAD_FETCHED);
			facade.removeCommand(VillageHandlers.RES_HEARTH_UPDATED);
			facade.removeCommand(VillageHandlers.RES_FORM_SUBMITTED);
			facade.removeCommand(HomeHandlers.MEMBER_RESURRECTED);
		}
		private function registerProxies():void {
			facade.registerProxy(new HearthListProxy());
      		facade.registerProxy(new IncomingDataErrorProxy(VillageHandlers.VILLAGE_ERROR));
			
			var hearthsRequest:RequestProxy = new RequestProxy(VillageHandlers.GET_HEARTH_DETAILS);
			facade.registerProxy(hearthsRequest);
			hearthsRequest.sendRequest();
			
			var hearthsIncoming:IncomingDataProxy = new IncomingDataProxy(VillageHandlers.HEARTH_LIST, VillageHandlers.HEARTH_LIST);
			hearthsIncoming.addDataParam(new DataParamArrayHearth("HearthDetails"));
			facade.registerProxy(hearthsIncoming);
			
			var hearthsError:IncomingDataProxy = new IncomingDataErrorProxy(VillageHandlers.GET_HEARTH_DETAILS_ERROR);
			facade.registerProxy(hearthsError);
			
			facade.registerProxy(new VillageOverviewProxy());
			
			var villageOverviewRequest:RequestProxy = new RequestProxy (VillageHandlers.GET_VILLAGE_DETAILS);
			facade.registerProxy(villageOverviewRequest);
			villageOverviewRequest.sendRequest();
			
			var villageDetails:IncomingDataProxy = new IncomingDataProxy(VillageHandlers.VILLAGE_DETAILS, VillageHandlers.VILLAGE_DETAILS);
			villageDetails.addDataParam(new DataParamString("VillageName"));
			villageDetails.addDataParam(new DataParamInt("NumberHearths"));
			villageDetails.addDataParam(new DataParamInt("NumberAdults"));
			villageDetails.addDataParam(new DataParamInt("NumberChildren"));
			facade.registerProxy(villageDetails);
			
			var hearthAssetsRequest:RequestProxy = new RequestProxy (VillageHandlers.GET_HEARTH_ASSETS);
			hearthAssetsRequest.addRequestParam(new DataParamInt("hearthId"));
			facade.registerProxy(hearthAssetsRequest);
			
			var hearthAssetsReceived:IncomingDataProxy = new IncomingDataProxy(VillageHandlers.HEARTH_ASSETS, VillageHandlers.HEARTH_ASSETS);
			hearthAssetsReceived.addDataParam(new DataParamString("HearthName"));
			hearthAssetsReceived.addDataParam(new DataParamInt("NumberAdults"));
			hearthAssetsReceived.addDataParam(new DataParamInt("NumberChildren"));
			hearthAssetsReceived.addDataParam(new DataParamNumber("SocialStatus"));
			hearthAssetsReceived.addDataParam(new DataParamInt("NumberFields"));
			facade.registerProxy(hearthAssetsReceived);
			
			var giveFormProxy:FormProxy = new FormProxy(VillageHandlers.GIVE_FORM);
			facade.registerProxy(giveFormProxy);
      		giveFormProxy.addDropDown(VillageHandlers.GIVE_HEARTH, "Recipient");
			giveFormProxy.addDisplayText(VillageHandlers.GIVE_ASSET, "Goods");
      		giveFormProxy.addBackendData(VillageHandlers.GIVE_ASSET_ID);
      		giveFormProxy.addTextField(VillageHandlers.GIVE_ASSET_AMOUNT, "Amount");
      		giveFormProxy.addBackendData(VillageHandlers.GIVE_ASSET_OPTIONS, "Options");
			giveFormProxy.addButton("Give", VillageHandlers.GIVE_SUBMIT);
      		giveFormProxy.addButton("Cancel", VillageHandlers.GIVE_CANCEL);
			giveFormProxy.showHideFields([VillageHandlers.GIVE_ASSET_OPTIONS], []);
      		
			var giveAssetRequest:RequestProxy = new RequestProxy(VillageHandlers.GIVE_REQUEST);
			giveAssetRequest.addRequestParam(new DataParamInt(VillageHandlers.GIVE_HEARTH));
			giveAssetRequest.addRequestParam(new DataParamInt(VillageHandlers.GIVE_ASSET_ID));
			giveAssetRequest.addRequestParam(new DataParamNumber(VillageHandlers.GIVE_ASSET_AMOUNT));
			facade.registerProxy(giveAssetRequest);
			
			var giveAssetSuccess:IncomingDataProxy = new IncomingDataProxy(VillageHandlers.GIVE_REQUEST_SUCCESS, ApplicationFacade.INCOMING_MESSAGE);
			giveAssetSuccess.addDataParam(new DataParamString("message"));
			facade.registerProxy(giveAssetSuccess);
			
			facade.registerProxy(new IncomingDataErrorProxy(VillageHandlers.GIVE_REQUEST_ERROR));
			
			var subMenuProxy:SubMenuListProxy = new SubMenuListProxy();
			facade.registerProxy (subMenuProxy);
			subMenuProxy.addSubMenuItem(VillageHandlers.SUB_MENU_OVERVIEW);
			subMenuProxy.addSubMenuItem(VillageHandlers.SUB_MENU_GIVE);
			subMenuProxy.addSubMenuItem(VillageHandlers.SUB_MENU_RESURRECT);
			subMenuProxy.setDefaultMenuItem(VillageHandlers.SUB_MENU_OVERVIEW);
			
			var resForm:FormProxy = new FormProxy(VillageHandlers.RES_FORM);
			facade.registerProxy(resForm);
			resForm.addDropDown(VillageHandlers.RES_FORM_HEARTH, "Household:", null, null, false, VillageHandlers.RES_HEARTH_UPDATED);
			resForm.addDropDown(VillageHandlers.RES_FORM_DEAD, "Character:");
			resForm.addButton(VillageHandlers.RES_FORM_SUBMIT, VillageHandlers.RES_FORM_SUBMITTED);
			resForm.addButton(VillageHandlers.RES_FORM_CANCEL, VillageHandlers.RES_FORM_CANCELLED);
			
			var fetchDead:RequestProxy = new RequestProxy(VillageHandlers.FETCH_DEAD);
			facade.registerProxy(fetchDead);
			fetchDead.sendRequest();
			
			facade.registerProxy(new IncomingDataErrorProxy(VillageHandlers.FETCH_DEAD_ERROR));
			
			var incomingDead:IncomingDataProxy = new IncomingDataProxy(VillageHandlers.DEAD_FETCHED, VillageHandlers.DEAD_FETCHED);
			incomingDead.addDataParam(new DataParamArrayAnyChar("Dead"));
			facade.registerProxy(incomingDead);
			
			var hearthMembersListProxy:HearthMembersListProxy = facade.retrieveProxy(HearthMembersListProxy.NAME) as HearthMembersListProxy;
			if(hearthMembersListProxy!=null){
				trace("VillageManagerGameState sez: Surprise! We have a hearthMembersListProxy already.");
			} else {
				trace("VillageManagerGameState sez: No surprise. We don't have a hearthMembersListProxy.");
				//We don't have a hearthMembersListProxy at this point. No biggy. We can add one. 
				hearthMembersListProxy = new HearthMembersListProxy();
				facade.registerProxy(hearthMembersListProxy);
			}
			
			var resurrectRequest:RequestProxy = new RequestProxy(VillageHandlers.RES_REQUEST);
			resurrectRequest.addRequestParam(new DataParamInt(VillageHandlers.RES_REQUEST_ID));
			facade.registerProxy(resurrectRequest);
			
			facade.registerProxy(new IncomingDataErrorProxy(VillageHandlers.RES_REQUEST_ERROR));
			
			var resurrectionSuccess:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.MEMBER_RESURRECTED, HomeHandlers.MEMBER_RESURRECTED);
			resurrectionSuccess.addDataParam(new DataParamString("Message"));
			resurrectionSuccess.addDataParam(new DataParamInt("CharId"));
			facade.registerProxy(resurrectionSuccess);
		}
		private function removeProxies():void {
			trace("VillageManagerGameState sez: I am removeing the proxies");
			facade.removeProxy(VillageHandlers.GET_HEARTH_DETAILS + RequestProxy.NAME);
			facade.removeProxy(VillageHandlers.GET_VILLAGE_DETAILS + RequestProxy.NAME);
			facade.removeProxy(VillageHandlers.HEARTH_LIST + IncomingDataProxy.NAME);
			facade.removeProxy(VillageHandlers.GET_HEARTH_DETAILS_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(HearthListProxy.NAME);
			facade.removeProxy(VillageHandlers.VILLAGE_DETAILS + IncomingDataProxy.NAME);
			facade.removeProxy(VillageHandlers.GET_HEARTH_ASSETS + RequestProxy.NAME);
			facade.removeProxy(VillageHandlers.HEARTH_ASSETS + IncomingDataProxy.NAME);
			facade.removeProxy(VillageOverviewProxy.NAME);
			facade.removeProxy(VillageHandlers.VILLAGE_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(VillageHandlers.GIVE_FORM);
			facade.removeProxy(VillageHandlers.GIVE_REQUEST + RequestProxy.NAME);
			facade.removeProxy(VillageHandlers.GIVE_REQUEST_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(VillageHandlers.GIVE_REQUEST_SUCCESS + IncomingDataProxy.NAME);
			facade.removeProxy(SubMenuListProxy.NAME);
			facade.removeProxy(VillageHandlers.RES_FORM);
			facade.removeProxy(VillageHandlers.FETCH_DEAD + RequestProxy.NAME);
			facade.removeProxy(VillageHandlers.FETCH_DEAD_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(VillageHandlers.DEAD_FETCHED + IncomingDataProxy.NAME);
			facade.removeProxy(HearthMembersListProxy.NAME); //Because this is manager only territory, and there really shouldn't be one elsewhere.
			facade.removeProxy(VillageHandlers.RES_REQUEST + RequestProxy.NAME);
			facade.removeProxy(VillageHandlers.RES_REQUEST_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(HomeHandlers.MEMBER_RESURRECTED + IncomingDataProxy.NAME);
		}
		private function registerMediators():void {
			facade.registerMediator(new InStockAssetListMediator());
			
      		var giveFormMediator:FormMediator = new FormMediator(VillageHandlers.GIVE_FORM, new Sprite());
      		facade.registerMediator(giveFormMediator);
      		giveFormMediator.setLabelWidth(70);
			
			var resFormMediator:FormMediator = new FormMediator(VillageHandlers.RES_FORM, new Sprite());
			facade.registerMediator(resFormMediator);
			
      		var submenuMediator:SubMenuMediator = new SubMenuMediator();
			facade.registerMediator(submenuMediator);
			
      		submenuMediator.moveToDefaultButton();  
		}
		private function removeMediators():void {
			var hearthListProxy:HearthListProxy = facade.retrieveProxy(HearthListProxy.NAME) as HearthListProxy;
			var hearthlist:Array = hearthListProxy.getHearthIds();
			
			for each (var hearthId:int in hearthlist){
				facade.removeMediator(HearthMediator.NAME + hearthId);
			}
			facade.removeMediator(VillageHandlers.GIVE_FORM);
			facade.removeMediator(VillageHandlers.RES_FORM);
			facade.removeMediator(SubMenuMediator.NAME);
		}
	}
}
