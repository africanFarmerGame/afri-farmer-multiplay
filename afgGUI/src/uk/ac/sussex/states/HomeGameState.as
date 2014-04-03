/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.states {
	import uk.ac.sussex.model.SubMenuListProxy;
	import uk.ac.sussex.model.valueObjects.HearthAsset;
	import uk.ac.sussex.model.HearthAssetListProxy;
	import uk.ac.sussex.model.PlayerCharProxy;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.view.HearthMemberListMediator;
	import uk.ac.sussex.model.valueObjects.requestParams.*;
	import uk.ac.sussex.controller.*;
	import uk.ac.sussex.view.SubMenuMediator;
	import uk.ac.sussex.model.ServerRoomProxy;
	import uk.ac.sussex.model.IncomingDataProxy;
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import uk.ac.sussex.serverhandlers.MarketHandlers;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.model.HearthMembersListProxy;
	import org.puremvc.as3.multicore.interfaces.IFacade;

	/**
	 * @author em97
	 */
	public class HomeGameState extends PlayerRoomState implements IGameState {
		public static const NAME:String = "HomeGameState";
		public static const LOCATION_NAME:String = "HOME";
		
		private var showSubMenu:Boolean;
		
		public function HomeGameState(facade : IFacade) {
			super(facade, NAME);
		}
		override public function displayState():void{
			super.displayState();
			trace("HomeGameState sez: You've reached the Home Game State");
			//add proxies
			var hmListProxy:HearthMembersListProxy = facade.retrieveProxy(HearthMembersListProxy.NAME) as HearthMembersListProxy;
			if(hmListProxy == null){
				hmListProxy = new HearthMembersListProxy();
				facade.registerProxy(hmListProxy);
			}
			
			var hearthMemberChangedHearth:IncomingDataProxy = facade.retrieveProxy(HomeHandlers.HEARTH_MEMBER_HEARTH_CHANGED + IncomingDataProxy.NAME) as IncomingDataProxy;
			if(hearthMemberChangedHearth==null){
				hearthMemberChangedHearth = new IncomingDataProxy(HomeHandlers.HEARTH_MEMBER_HEARTH_CHANGED, HomeHandlers.HEARTH_MEMBER_HEARTH_CHANGED);
				hearthMemberChangedHearth.addDataParam(new DataParamInt(HomeHandlers.HMHC_CHAR));
				hearthMemberChangedHearth.addDataParam(new DataParamInt(HomeHandlers.HMHC_HEARTH));
				facade.registerProxy(hearthMemberChangedHearth);
				
				facade.registerCommand(HomeHandlers.HEARTH_MEMBER_HEARTH_CHANGED, HearthMemberChangedHearthCommand);
			}
			
			var memberResurrected:IncomingDataProxy = facade.retrieveProxy(HomeHandlers.MEMBER_RESURRECTED + IncomingDataProxy.NAME) as IncomingDataProxy;
			if(memberResurrected==null){
				memberResurrected = new IncomingDataProxy(HomeHandlers.MEMBER_RESURRECTED, HomeHandlers.MEMBER_RESURRECTED);
				memberResurrected.addDataParam(new DataParamString("Message"));
				memberResurrected.addDataParam(new DataParamInt("CharId"));
				facade.registerProxy(memberResurrected);
			}
			
			var incomingHearthMembers:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.HEARTH_MEMBERS_LIST, HomeHandlers.HEARTH_MEMBERS_LIST);
			incomingHearthMembers.addDataParam(new DataParamArrayPlayerChar("PCList"));
			incomingHearthMembers.addDataParam(new DataParamArrayHearthMember("NPCList"));
			incomingHearthMembers.addDataParam(new DataParamArrayAnyChar("DeadList"));
			facade.registerProxy(incomingHearthMembers);
			
			var incomingError:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.GET_MEMBER_DETAILS_ERROR, ApplicationFacade.INCOMING_ERROR_MESSAGE);
			incomingError.addDataParam(new DataParamString("message"));
			facade.registerProxy(incomingError);
			
			//Add and send the request for the home members.
			var srp:ServerRoomProxy = facade.retrieveProxy(ServerRoomProxy.NAME) as ServerRoomProxy;
			var hearthId:String;
			hearthId = srp.getRoomId();
			
			var hearthMembersRequest:RequestProxy = new RequestProxy(HomeHandlers.GET_MEMBER_DETAILS);
			hearthMembersRequest.addRequestParam(new DataParamInt("hearthId"));

			var myChar:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;
			showSubMenu = (myChar==null);
			if(!showSubMenu){
				showSubMenu = myChar.isBanker()||(myChar.getPCHearthId() == hearthId);
			}
			
			hearthMembersRequest.setParamValue(HomeHandlers.HEARTH_ID, hearthId);
			facade.registerProxy(hearthMembersRequest);
			hearthMembersRequest.sendRequest();
			
			var hearthAssetsRequest:RequestProxy = new RequestProxy(HomeHandlers.GET_HEARTH_ASSETS);
			hearthAssetsRequest.addRequestParam(new DataParamInt("hearthId"));
			facade.registerProxy(hearthAssetsRequest);
			hearthAssetsRequest.setParamValue("hearthId", hearthId);
			hearthAssetsRequest.sendRequest();
			
			var incomingHearthAssets:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.HEARTH_ASSETS_LIST, HomeHandlers.HEARTH_ASSETS_LIST);
			incomingHearthAssets.addDataParam(new DataParamArrayHearthAsset("HearthAssets"));
			facade.registerProxy(incomingHearthAssets);
			
			//add mediators
			if(showSubMenu){
				var subMenuProxy:SubMenuListProxy = new SubMenuListProxy();
				facade.registerProxy(subMenuProxy);
				subMenuProxy.addSubMenuItem(HomeHandlers.SUB_MENU_OVERVIEW);
				subMenuProxy.addSubMenuItem(HomeHandlers.SUB_MENU_DIET);
				subMenuProxy.addSubMenuItem(HomeHandlers.SUB_MENU_WORK);
				subMenuProxy.addSubMenuItem(HomeHandlers.SUB_MENU_ASSETS);
				subMenuProxy.setDefaultMenuItem(HomeHandlers.SUB_MENU_OVERVIEW);
				var submenuMediator:SubMenuMediator = new SubMenuMediator();
				facade.registerMediator(submenuMediator);
			}			
			var intHearthId:int = int(hearthId);
			facade.registerMediator(new HearthMemberListMediator(intHearthId));
			
			//add commands
			facade.registerCommand(HomeHandlers.HEARTH_MEMBERS_LIST, HearthMembersStoreCommand);
			facade.registerCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED, SubMenuHomeCommand);
			facade.registerCommand(HomeHandlers.HEARTH_ASSETS_LIST, HomeHearthAssetsReceivedCommand);
			facade.registerCommand(HomeHandlers.MEMBER_RESURRECTED, HearthMemberResurrectedCommand);
			
			//This is a cop out, but the button needs to be set after the command to deal with the button has been registered.
			if(showSubMenu){ 	
				submenuMediator.moveToDefaultButton();
			}
		}
		override public function cleanUpState():void{
			
			//remove proxies
			facade.removeProxy(HomeHandlers.GET_MEMBER_DETAILS + RequestProxy.NAME);
			facade.removeProxy(HomeHandlers.HEARTH_MEMBERS_LIST + IncomingDataProxy.NAME);
			facade.removeProxy(HomeHandlers.GET_MEMBER_DETAILS_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(HomeHandlers.GET_HEARTH_ASSETS + RequestProxy.NAME);
			facade.removeProxy(HomeHandlers.HEARTH_ASSETS_LIST + IncomingDataProxy.NAME);
			facade.removeProxy(HearthAsset.OWNER_HEARTH + HearthAssetListProxy.NAME);
			facade.removeProxy(HearthAsset.OWNER_PC + HearthAssetListProxy.NAME);
			
			//remove mediators
			if(showSubMenu){
				facade.removeMediator(SubMenuMediator.NAME);
			}
			facade.removeMediator(HearthMemberListMediator.NAME);
			
			//remove commands
			facade.removeCommand(HomeHandlers.HEARTH_MEMBERS_LIST);
			facade.removeCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED);
			facade.removeCommand(HomeHandlers.HEARTH_ASSETS_LIST);
			facade.removeCommand(MarketHandlers.HEARTH_ASSETS_UPDATED);
      
			super.cleanUpState();
		}
		override public function refresh():void {
			super.refresh();
			
			var srp:ServerRoomProxy = facade.retrieveProxy(ServerRoomProxy.NAME) as ServerRoomProxy;
			var hearthId:String;
			hearthId = srp.getRoomId();
			
			facade.removeMediator(HearthMemberListMediator.NAME);
			facade.removeProxy(HearthMembersListProxy.NAME);
			facade.registerProxy(new HearthMembersListProxy()); //This isn't pretty, but it's the easiest way to clear and refresh the cache.
			facade.registerMediator(new HearthMemberListMediator(int(hearthId))); 
			
			
			var homeMembersRequest:RequestProxy = facade.retrieveProxy(HomeHandlers.GET_MEMBER_DETAILS + RequestProxy.NAME) as RequestProxy;
			homeMembersRequest.setParamValue(HomeHandlers.HEARTH_ID, hearthId);
			homeMembersRequest.sendRequest();
			
			var hearthAssetsRequest:RequestProxy = facade.retrieveProxy(HomeHandlers.GET_HEARTH_ASSETS + RequestProxy.NAME) as RequestProxy;
			hearthAssetsRequest.addRequestParam(new DataParamInt("hearthId"));
			hearthAssetsRequest.setParamValue("hearthId", hearthId);
			hearthAssetsRequest.sendRequest();
			
			
		}
	}
}
