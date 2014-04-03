/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.states {
	import uk.ac.sussex.model.SubMenuListProxy;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.valueObjects.HearthAsset;
	import uk.ac.sussex.model.HearthAssetListProxy;
	import uk.ac.sussex.model.PlayerCharProxy;
	import uk.ac.sussex.view.FieldsMediator;
	import uk.ac.sussex.model.FieldListProxy;
	import uk.ac.sussex.controller.FieldsStoreCommand;
	import uk.ac.sussex.model.IncomingDataProxy;
	import uk.ac.sussex.model.valueObjects.requestParams.*;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.model.ServerRoomProxy;
	import uk.ac.sussex.controller.SubMenuFarmCommand;
	import uk.ac.sussex.controller.HomeHearthAssetsReceivedCommand;
	import uk.ac.sussex.serverhandlers.FarmHandlers;
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import uk.ac.sussex.view.SubMenuMediator;
	import org.puremvc.as3.multicore.interfaces.IFacade;

	/**
	 * @author em97
	 */
	public class FarmGameState extends PlayerRoomState implements IGameState {
		public static const NAME:String = "FarmGameState";
		public static const LOCATION_NAME:String = "FARM";
		public function FarmGameState(facade : IFacade) {
			super(facade, NAME);
		}
		override public function displayState():void{
			super.displayState();
			trace("FarmGameState sez: Welcome! You've reached the Farm Game State");
			
			//add proxies
			this.registerProxies();
			
			//add commands
			this.registerCommands();
			
			//add mediators
			var submenuMediator:SubMenuMediator = new SubMenuMediator();
			facade.registerMediator(submenuMediator);
			
			facade.registerMediator(new FieldsMediator());
			
			//This is a cop out, but the button needs to be set after the command to deal with the button has been registered. 
			submenuMediator.moveToDefaultButton();
		}
		override public function cleanUpState():void{
			//remove proxies
			this.removeProxies();
			
			//remove mediators
			facade.removeMediator(SubMenuMediator.NAME);
			facade.removeMediator(FieldsMediator.NAME);
			//remove commands
			facade.removeCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED);
			facade.removeCommand(FarmHandlers.FIELD_DETAILS_RECIEVED);
			
			super.cleanUpState();
		}
		override public function getName():String{
			return NAME;
		}
		override public function refresh():void {
			super.refresh();
			var myChar:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;
			
			var fieldDetails:RequestProxy = facade.retrieveProxy(FarmHandlers.GET_FIELD_DETAILS + RequestProxy.NAME) as RequestProxy;
			var detailType:String = setFieldDetailRequestVars(fieldDetails, myChar);
			fieldDetails.sendRequest();
			if(detailType=="H"){
				var hearthAssetsProxy:RequestProxy = facade.retrieveProxy(HomeHandlers.GET_HEARTH_ASSETS + RequestProxy.NAME) as RequestProxy;
				hearthAssetsProxy.setParamValue("hearthId", fetchHearthId(myChar));
				hearthAssetsProxy.sendRequest();
			}
		}
		private function registerProxies():void {
			var myChar:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;
			
			facade.registerProxy(new FieldListProxy());
			
			var incomingFieldData:IncomingDataProxy = new IncomingDataProxy(FarmHandlers.FIELD_DETAILS_RECIEVED, FarmHandlers.FIELD_DETAILS_RECIEVED);
			incomingFieldData.addDataParam(new DataParamArrayField("FieldDetails"));
			facade.registerProxy(incomingFieldData);
						
			var fieldDetailsRequest:RequestProxy = new RequestProxy(FarmHandlers.GET_FIELD_DETAILS);
			fieldDetailsRequest.addRequestParam(new DataParamInt("hearthId"));
			fieldDetailsRequest.addRequestParam(new DataParamString("fieldOwner"));
			facade.registerProxy(fieldDetailsRequest);
			
			var detailType:String = setFieldDetailRequestVars(fieldDetailsRequest, myChar);
			
			fieldDetailsRequest.sendRequest();
			
			var fieldDetailsError:IncomingDataProxy = new IncomingDataProxy(FarmHandlers.FIELD_DETAILS_ERROR, ApplicationFacade.INCOMING_ERROR_MESSAGE);
			fieldDetailsError.addDataParam(new DataParamString("message"));
			facade.registerProxy(fieldDetailsError);
			
			var hearthAssetsRequest:RequestProxy = new RequestProxy(HomeHandlers.GET_HEARTH_ASSETS);
			hearthAssetsRequest.addRequestParam(new DataParamInt("hearthId"));
			facade.registerProxy(hearthAssetsRequest);
			hearthAssetsRequest.setParamValue("hearthId", fetchHearthId(myChar));
			hearthAssetsRequest.sendRequest();
			
			var incomingHearthAssets:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.HEARTH_ASSETS_LIST, HomeHandlers.HEARTH_ASSETS_LIST);
			incomingHearthAssets.addDataParam(new DataParamArrayHearthAsset("HearthAssets"));
			facade.registerProxy(incomingHearthAssets);
			
			var subMenuProxy:SubMenuListProxy  = new SubMenuListProxy();
			facade.registerProxy(subMenuProxy);
			subMenuProxy.addSubMenuItem(FarmHandlers.SUB_MENU_SUMMARY);
			if(detailType!="P") {subMenuProxy.addSubMenuItem(FarmHandlers.SUB_MENU_TASKS);}
			subMenuProxy.addSubMenuItem(FarmHandlers.SUB_MENU_STOCKS);
			subMenuProxy.setDefaultMenuItem(FarmHandlers.SUB_MENU_SUMMARY);
			
		}
		private function removeProxies():void {
			facade.removeProxy(FarmHandlers.GET_FIELD_DETAILS + RequestProxy.NAME);
			facade.removeProxy(FarmHandlers.FIELD_DETAILS_RECIEVED + IncomingDataProxy.NAME);
			facade.removeProxy(FarmHandlers.FIELD_DETAILS_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(FieldListProxy.NAME);
			facade.removeProxy(HearthAsset.OWNER_HEARTH + HearthAssetListProxy.NAME);
			facade.removeProxy(HearthAsset.OWNER_PC + HearthAssetListProxy.NAME);
			facade.removeProxy(HomeHandlers.GET_HEARTH_ASSETS + RequestProxy.NAME);
			facade.removeProxy(HomeHandlers.HEARTH_ASSETS_LIST + IncomingDataProxy.NAME);
		}
		private function registerCommands():void {
			facade.registerCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED, SubMenuFarmCommand);
			facade.registerCommand(FarmHandlers.FIELD_DETAILS_RECIEVED, FieldsStoreCommand);
			facade.registerCommand(HomeHandlers.HEARTH_ASSETS_LIST, HomeHearthAssetsReceivedCommand);			
		}
		private function setFieldDetailRequestVars(fieldDetailsRequest:RequestProxy, myChar:PlayerCharProxy):String{
			var detailId:int = fetchHearthId(myChar);
			
			var detailType:String;
			var hasHearth:Boolean = (myChar.getPCHearthId()>0);
			if(hasHearth){
				//detailId = myChar.getPCHearthId();
				detailType = "H";
			} else {
				if(myChar.isBanker()){
					//var serverRoomProxy:ServerRoomProxy = facade.retrieveProxy(ServerRoomProxy.NAME) as ServerRoomProxy;
					//var roomId:String = serverRoomProxy.getRoomId();
					//detailId = int(roomId);
					detailType = "H";
				} else {
					//detailId = myChar.getPlayerId();
					detailType = "P";
				}
			}
			fieldDetailsRequest.setParamValue("hearthId", detailId);
			fieldDetailsRequest.setParamValue("fieldOwner", detailType);
			
			return detailType;
		}
		private function fetchHearthId(myChar:PlayerCharProxy):int{
			var detailId:int = 0;
			var hasHearth:Boolean = (myChar.getPCHearthId()>0);
			if(hasHearth){
				detailId = myChar.getPCHearthId();
			} else {
				if(myChar.isBanker()){
					var serverRoomProxy:ServerRoomProxy = facade.retrieveProxy(ServerRoomProxy.NAME) as ServerRoomProxy;
					var roomId:String = serverRoomProxy.getRoomId();
					detailId = int(roomId);
				} else {
					detailId = myChar.getPlayerId();
				}
			}
			return detailId;
		}
	}
}
