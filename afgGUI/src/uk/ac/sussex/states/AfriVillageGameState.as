/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.states {
	import flash.display.Sprite;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.serverhandlers.MarketHandlers;
	import uk.ac.sussex.controller.*;
	import uk.ac.sussex.model.valueObjects.requestParams.*;
	import uk.ac.sussex.serverhandlers.VillageHandlers;
	import uk.ac.sussex.model.*;
	import uk.ac.sussex.view.*;
	import uk.ac.sussex.states.InGameState;

	import org.puremvc.as3.multicore.interfaces.IFacade;

	/**
	 * @author em97
	 */
	public class AfriVillageGameState extends InGameState {
		public static const NAME:String = "VillageGameState"; //This needs to match the core state name that this replaces. 
		public static const LOCATION_NAME:String = "VILLAGE";
		
		public function AfriVillageGameState(facade : IFacade) {
			super(facade, NAME);
		}
		override public function displayState():void{
			super.displayState();
			trace("VillageGameState sez: You've reached the Village Game State");
			//add proxies
			registerProxies();
			
			//add commands
			registerCommands();
			
			//add mediators
			registerMediators();
		}
		override public function cleanUpState():void{
			var hearthListProxy:HearthListProxy = facade.retrieveProxy(HearthListProxy.NAME) as HearthListProxy;
			var hearthlist:Array = hearthListProxy.getHearthIds();
			//remove proxies
			removeProxies();
			
			//remove mediators
			for each (var hearthId:int in hearthlist){
				facade.removeMediator(HearthMediator.NAME + hearthId);
			}
			facade.removeMediator(SubMenuMediator.NAME);
			facade.removeMediator(VillageHandlers.GIVE_FORM);
			facade.removeMediator(InStockAssetListMediator.NAME);
			facade.removeMediator(HearthlessListMediator.NAME);
			
			//remove commands
			facade.removeCommand(VillageHandlers.HEARTH_LIST);
			facade.removeCommand(HearthListProxy.HEARTH_ADDED);
			facade.removeCommand(VillageHandlers.VILLAGE_DETAILS);
			facade.removeCommand(HearthMediator.HEARTH_SELECTED);
			facade.removeCommand(VillageHandlers.HEARTH_ASSETS);
			facade.removeCommand(HearthMediator.HEARTH_DESELECTED);
			facade.removeCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED);
			facade.removeCommand(InStockAssetListMediator.STOCK_ITEM_SELECTED);
			facade.removeCommand(VillageHandlers.GIVE_SUBMIT);
			facade.removeCommand(VillageHandlers.GIVE_CANCEL);
			
			super.cleanUpState();
		}
		override public function getName():String{
			return NAME;
		}
		override public function refresh():void {
			super.refresh();
		  	var villageOverviewRequest:RequestProxy = facade.retrieveProxy(VillageHandlers.GET_VILLAGE_DETAILS + RequestProxy.NAME) as RequestProxy;
		  	if(villageOverviewRequest!=null){
		   		villageOverviewRequest.sendRequest();
		  	}
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
			
			var hearthLessRequest:RequestProxy = new RequestProxy(VillageHandlers.FETCH_HEARTHLESS);
			facade.registerProxy(hearthLessRequest);
			hearthLessRequest.sendRequest();
			
			var hearthlessReceived:IncomingDataProxy = new IncomingDataProxy(VillageHandlers.HEARTHLESS_RECEIVED, VillageHandlers.HEARTHLESS_RECEIVED);
			hearthlessReceived.addDataParam(new DataParamArrayPlayerChar(VillageHandlers.HEARTHLESS_ARRAY));
			facade.registerProxy(hearthlessReceived);
			
			facade.registerProxy(new IncomingDataErrorProxy(VillageHandlers.FETCH_HEARTHLESS_ERROR));
			
			facade.registerProxy(new PCListProxy(VillageHandlers.HEARTHLESS_LIST));
			
			var hearthAssetsRequest:RequestProxy = new RequestProxy (VillageHandlers.GET_HEARTH_ASSETS);
			hearthAssetsRequest.addRequestParam(new DataParamInt("hearthId"));
			facade.registerProxy(hearthAssetsRequest);
			
			var hearthAssetsReceived:IncomingDataProxy = new IncomingDataProxy(VillageHandlers.HEARTH_ASSETS, VillageHandlers.HEARTH_ASSETS);
			hearthAssetsReceived.addDataParam(new DataParamString("HearthName"));
			hearthAssetsReceived.addDataParam(new DataParamInt("NumberAdults"));
			hearthAssetsReceived.addDataParam(new DataParamInt("NumberChildren"));
			hearthAssetsReceived.addDataParam(new DataParamNumber("SocialStatus"));
			hearthAssetsReceived.addDataParam(new DataParamInt("NumberFields"));
			hearthAssetsReceived.addDataParam(new DataParamArrayString("HearthHeads"));
			facade.registerProxy(hearthAssetsReceived);
			
			var giveFormProxy:FormProxy = new FormProxy(VillageHandlers.GIVE_FORM);
			facade.registerProxy(giveFormProxy);
      		giveFormProxy.addDropDown(VillageHandlers.GIVE_HEARTH, "Recipient");
			giveFormProxy.addDisplayText(VillageHandlers.GIVE_ASSET, "Goods");
      		giveFormProxy.addBackendData(VillageHandlers.GIVE_ASSET_ID);
      		giveFormProxy.addTextField(VillageHandlers.GIVE_ASSET_AMOUNT, "Amount");
      		giveFormProxy.addButton("Give", VillageHandlers.GIVE_SUBMIT);
      		giveFormProxy.addButton("Cancel", VillageHandlers.GIVE_CANCEL);
      
      		var getMyAssetsList:RequestProxy = new RequestProxy(VillageHandlers.GET_GIVE_ASSETS);
      		facade.registerProxy(getMyAssetsList);
      		getMyAssetsList.sendRequest();
      
      		var paIncomingDataProxy:IncomingDataProxy = new IncomingDataProxy(VillageHandlers.GET_GIVE_ASSETS_SUCCESS, VillageHandlers.GET_GIVE_ASSETS_SUCCESS);
			paIncomingDataProxy.addDataParam(new DataParamArrayHearthAsset(MarketHandlers.PC_ASSET_DETAILS));
			paIncomingDataProxy.addDataParam(new DataParamArrayHearthAsset(MarketHandlers.HEARTH_ASSET_DETAILS));
			this.facade.registerProxy(paIncomingDataProxy);
			
      		facade.registerProxy(new IncomingDataErrorProxy(VillageHandlers.GET_GIVE_ASSETS_ERROR));
			
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
			facade.registerProxy(subMenuProxy);
			subMenuProxy.addSubMenuItem(VillageHandlers.SUB_MENU_OVERVIEW);
			subMenuProxy.addSubMenuItem(VillageHandlers.SUB_MENU_GIVE);
			subMenuProxy.addSubMenuItem(VillageHandlers.SUB_MENU_JOIN);
      		subMenuProxy.setDefaultMenuItem(VillageHandlers.SUB_MENU_OVERVIEW);  
			
    	}
		private function removeProxies():void {
			facade.removeProxy(VillageHandlers.GET_HEARTH_DETAILS + RequestProxy.NAME);
			facade.removeProxy(VillageHandlers.GET_VILLAGE_DETAILS + RequestProxy.NAME);
			facade.removeProxy(VillageHandlers.HEARTH_LIST + IncomingDataProxy.NAME);
			facade.removeProxy(VillageHandlers.GET_HEARTH_DETAILS_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(HearthListProxy.NAME);
			facade.removeProxy(VillageHandlers.VILLAGE_DETAILS + IncomingDataProxy.NAME);
			facade.removeProxy(VillageHandlers.GET_HEARTH_ASSETS + RequestProxy.NAME);
			facade.removeProxy(VillageHandlers.HEARTH_ASSETS + IncomingDataProxy.NAME);
			facade.removeProxy(VillageOverviewProxy.NAME);
			facade.removeProxy(VillageHandlers.GIVE_FORM);
			facade.removeProxy(VillageHandlers.VILLAGE_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(VillageHandlers.GET_GIVE_ASSETS + RequestProxy.NAME);
			facade.removeProxy(VillageHandlers.GET_GIVE_ASSETS_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(VillageHandlers.GET_GIVE_ASSETS_SUCCESS + IncomingDataProxy.NAME);
			facade.removeProxy(VillageHandlers.GIVE_REQUEST + RequestProxy.NAME);
			facade.removeProxy(VillageHandlers.GIVE_REQUEST_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(VillageHandlers.GIVE_REQUEST_SUCCESS + IncomingDataProxy.NAME);
			facade.removeProxy(VillageHandlers.FETCH_HEARTHLESS + RequestProxy.NAME);
			facade.removeProxy(VillageHandlers.HEARTHLESS_RECEIVED + IncomingDataProxy.NAME);
			facade.removeProxy(VillageHandlers.FETCH_HEARTHLESS_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(VillageHandlers.HEARTH_LIST);
			facade.removeProxy(SubMenuListProxy.NAME);
		}
    	private function registerMediators():void {
			
      		facade.registerMediator(new InStockAssetListMediator());
			
      		var giveFormMediator:FormMediator = new FormMediator(VillageHandlers.GIVE_FORM, new Sprite());
      		facade.registerMediator(giveFormMediator);
      		giveFormMediator.setLabelWidth(70);
 
 			facade.registerMediator(new HearthlessListMediator());
			
      		var submenuMediator:SubMenuMediator = new SubMenuMediator();
			facade.registerMediator(submenuMediator);
			submenuMediator.moveToDefaultButton();  
      
   		}
   		private function registerCommands():void {
      		facade.registerCommand(VillageHandlers.HEARTH_LIST, HearthsStoreCommand);
			facade.registerCommand(HearthListProxy.HEARTH_ADDED, HearthsAddCommand);
			facade.registerCommand(VillageHandlers.VILLAGE_DETAILS, VillageDisplayOverviewCommand);
			facade.registerCommand(HearthMediator.HEARTH_SELECTED, AfriHearthIconSelectedCommand);
			facade.registerCommand(VillageHandlers.HEARTH_ASSETS, AfriVillageHearthAssetsReceivedCommand);
			facade.registerCommand(HearthMediator.HEARTH_DESELECTED, ResetInfoTextCommand);
			facade.registerCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED, SubMenuAfriVillageCommand);
      		facade.registerCommand(InStockAssetListMediator.STOCK_ITEM_SELECTED, VillageStockItemSelectedCommand);
			facade.registerCommand(VillageHandlers.GET_GIVE_ASSETS_SUCCESS, VillagePlayerAssetDetailsReceivedCommand);
			facade.registerCommand(VillageHandlers.GIVE_SUBMIT, SubmitGiveFormCommand);
			facade.registerCommand(VillageHandlers.GIVE_CANCEL, CancelGiveFormCommand);
			facade.registerCommand(VillageHandlers.HEARTHLESS_RECEIVED, HearthlessReceivedCommand);
    	}
	}
}
