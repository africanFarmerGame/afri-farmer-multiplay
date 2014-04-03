/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.states {
	import uk.ac.sussex.model.valueObjects.HearthAsset;
	import uk.ac.sussex.serverhandlers.MarketHandlers;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.valueObjects.requestParams.*;
	import uk.ac.sussex.model.*;
	import uk.ac.sussex.controller.*;
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import uk.ac.sussex.view.*;
	import org.puremvc.as3.multicore.interfaces.IFacade;

	/**
	 * @author em97
	 */
	public class FoodGameState extends PlayerRoomState implements IGameState {
		public static const NAME:String = "FoodGameState";
		private static const DISPLAY_TITLE:String = "Food and Nutrition";
		public function FoodGameState(facade:IFacade){
			//this.facade = facade;
			super(facade, NAME, DISPLAY_TITLE);
		}
		
		override public function displayState() : void {
			super.displayState();
			this.registerProxies();
			this.registerCommands();
			this.registerMediators();
		}

		override public function cleanUpState() : void {	
			this.facade.removeMediator(SubMenuMediator.NAME);
			this.facade.removeMediator(FoodViewMediator.NAME);
			this.facade.removeMediator(NutritionGraphMediator.NAME);
			this.facade.removeMediator(DietTargetLevelDisplayMediator.NAME);
			this.facade.removeMediator(DietContentListMediator.NAME);
			
			this.facade.removeCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED);
			this.facade.removeCommand(HomeHandlers.DIETARY_REQUIREMENTS);
			this.facade.removeCommand(HomeHandlers.ALLOCATIONS_LIST);
			this.facade.removeCommand(HomeHandlers.DIET_LIST);
			this.facade.removeCommand(ApplicationFacade.INCOMING_MESSAGE);
			this.facade.removeCommand(ApplicationFacade.INCOMING_ERROR_MESSAGE);
			this.facade.removeCommand(HomeHandlers.SET_SELECTED_ALLOCATION);
			this.facade.removeCommand(HomeHandlers.SET_SELECTED_ALLOCATION_SUCCESS);
			this.facade.removeCommand(HomeHandlers.HEARTH_ASSETS_LIST);
			this.facade.removeCommand(MarketHandlers.HEARTH_ASSETS_UPDATED);
			facade.removeCommand(HomeHandlers.ALLOCATION_UPDATED);
			
			this.facade.removeProxy(HomeHandlers.GET_ALLOCATIONS + RequestProxy.NAME);
			this.facade.removeProxy(HomeHandlers.GET_ALLOCATIONS_ERROR + IncomingDataProxy.NAME);
			this.facade.removeProxy(HomeHandlers.GET_DIET_LIST + RequestProxy.NAME);
			this.facade.removeProxy(HomeHandlers.GET_DIET_LIST_ERROR + IncomingDataProxy.NAME);
			this.facade.removeProxy(AllocationListProxy.NAME);
			this.facade.removeProxy(DietListProxy.NAME);
			this.facade.removeProxy(HomeHandlers.SET_SELECTED_ALLOCATION + RequestProxy.NAME);
			this.facade.removeProxy(HomeHandlers.SET_SELECTED_ALLOCATION_ERROR + IncomingDataProxy.NAME);
			this.facade.removeProxy(HomeHandlers.SET_SELECTED_ALLOCATION_SUCCESS + IncomingDataProxy.NAME);
			this.facade.removeProxy(HearthAsset.OWNER_HEARTH + HearthAssetListProxy.NAME);
			facade.removeProxy(MarketHandlers.HEARTH_ASSETS_UPDATED + IncomingDataProxy.NAME);
			facade.removeProxy(HomeHandlers.ALLOCATION_UPDATED + IncomingDataProxy.NAME);
			facade.removeProxy(SubMenuListProxy.NAME);
			
			super.cleanUpState();
		}

		override public function refresh() :void {
			super.refresh();
		}
		private function registerCommands():void {
			facade.registerCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED, SubMenuFoodCommand);
			facade.registerCommand(HomeHandlers.DIETARY_REQUIREMENTS, DietaryRequirementsReceivedCommand);
			facade.registerCommand(ApplicationFacade.INCOMING_MESSAGE, DisplayServerMessageCommand);
			facade.registerCommand(ApplicationFacade.INCOMING_ERROR_MESSAGE, DisplayServerErrorMessageCommand);
			facade.registerCommand(HomeHandlers.DIET_LIST, DietListReceivedCommand);
			facade.registerCommand(HomeHandlers.ALLOCATIONS_LIST, AllocationListReceivedCommand);
			facade.registerCommand(HomeHandlers.SET_SELECTED_ALLOCATION, SaveSelectedAllocationCommand);
			facade.registerCommand(HomeHandlers.SET_SELECTED_ALLOCATION_SUCCESS, SetSelectedAllocationSuccessCommand);
			facade.registerCommand(HomeHandlers.HEARTH_ASSETS_LIST, HomeHearthAssetsReceivedCommand);
      		facade.registerCommand(MarketHandlers.HEARTH_ASSETS_UPDATED, HearthAssetsUpdatedCommand);
			facade.registerCommand(HomeHandlers.ALLOCATION_UPDATED, AllocationUpdateReceivedCommand);
		}
		private function registerMediators():void {
			
			var submenuMediator:SubMenuMediator = new SubMenuMediator();
			facade.registerMediator(submenuMediator);	
			
			facade.registerMediator(new FoodViewMediator());
			facade.registerMediator(new NutritionGraphMediator());
			facade.registerMediator(new DietTargetLevelDisplayMediator());
			facade.registerMediator(new DietContentListMediator());
			facade.sendNotification(HomeHandlers.DISPLAY_DIET, null); //This will clear the diet stuff off the screen to start with.
			
			submenuMediator.moveToDefaultButton();
			
		}
		
		private function registerProxies():void {
				
			var dietaryReqsProxy:DietaryRequirementsProxy = facade.retrieveProxy(DietaryRequirementsProxy.NAME) as DietaryRequirementsProxy;
			if(dietaryReqsProxy == null){
				dietaryReqsProxy = new DietaryRequirementsProxy();
				facade.registerProxy(dietaryReqsProxy);
				var dietaryRequests:RequestProxy = new RequestProxy(HomeHandlers.GET_DIETARY_REQS);
				facade.registerProxy(dietaryRequests);
				var dietaryReqsIncoming:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.DIETARY_REQUIREMENTS, HomeHandlers.DIETARY_REQUIREMENTS);
				dietaryReqsIncoming.addDataParam(new DataParamArrayDietaryRequirement(HomeHandlers.DIETARY_REQUIREMENTS));
				facade.registerProxy(dietaryReqsIncoming);
				dietaryRequests.sendRequest();
			}
			
			var hearthMembersProxy:HearthMembersListProxy = facade.retrieveProxy(HearthMembersListProxy.NAME) as HearthMembersListProxy;
			var gameAssetsLP:GameAssetListProxy = facade.retrieveProxy(GameAssetListProxy.NAME) as GameAssetListProxy;
			facade.registerProxy(new AllocationListProxy(hearthMembersProxy, gameAssetsLP));
			facade.registerProxy(new DietListProxy(dietaryReqsProxy, gameAssetsLP));
			
			var myChar:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;
			var serverRoomProxy:ServerRoomProxy = facade.retrieveProxy(ServerRoomProxy.NAME) as ServerRoomProxy;
			var roomId:String = serverRoomProxy.getRoomId();
			var hearthId:int = int(roomId);
			
			var getAllocations:RequestProxy = new RequestProxy(HomeHandlers.GET_ALLOCATIONS);
			getAllocations.addRequestParam(new DataParamInt("hearthId"));
			getAllocations.setParamValue("hearthId", hearthId);
			facade.registerProxy(getAllocations);
			getAllocations.sendRequest();
			
			var allocationsError:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.GET_ALLOCATIONS_ERROR, ApplicationFacade.INCOMING_ERROR_MESSAGE);
			allocationsError.addDataParam(new DataParamString("message"));
			facade.registerProxy(allocationsError);
			
			var allocationsReceived:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.ALLOCATIONS_LIST, HomeHandlers.ALLOCATIONS_LIST);
			allocationsReceived.addDataParam(new DataParamArrayAllocation("Allocations"));
			facade.registerProxy(allocationsReceived);
			
			var dietRequest:RequestProxy = new RequestProxy(HomeHandlers.GET_DIET_LIST);
			dietRequest.addRequestParam(new DataParamInt(HomeHandlers.HEARTH_ID));
			dietRequest.setParamValue(HomeHandlers.HEARTH_ID, hearthId);
			facade.registerProxy(dietRequest);
			dietRequest.sendRequest();
			
			var incomingDiets:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.DIET_LIST, HomeHandlers.DIET_LIST);
			incomingDiets.addDataParam(new DataParamArrayDiet("Diets"));
			facade.registerProxy(incomingDiets);
			
			var incomingDietsError:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.GET_DIET_LIST_ERROR, ApplicationFacade.INCOMING_ERROR_MESSAGE);
			incomingDietsError.addDataParam(new DataParamString("message"));
			facade.registerProxy(incomingDietsError);
			
			var setSelectedRequest:RequestProxy = new RequestProxy(HomeHandlers.SET_SELECTED_ALLOCATION);
			setSelectedRequest.addRequestParam(new DataParamInt(HomeHandlers.HEARTH_ID));
			setSelectedRequest.addRequestParam(new DataParamInt("AllocationId"));
			facade.registerProxy(setSelectedRequest);
			
			var setSelectedSuccess:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.SET_SELECTED_ALLOCATION_SUCCESS, HomeHandlers.SET_SELECTED_ALLOCATION_SUCCESS);
			setSelectedSuccess.addDataParam(new DataParamString("message"));
			setSelectedSuccess.addDataParam(new DataParamInt("AllocationId"));
			facade.registerProxy(setSelectedSuccess);
			
			var setSelectedError:IncomingDataErrorProxy = new IncomingDataErrorProxy(HomeHandlers.SET_SELECTED_ALLOCATION_ERROR);
			facade.registerProxy(setSelectedError);
			
			var hearthAssetsRequest:RequestProxy = new RequestProxy(HomeHandlers.GET_HEARTH_ASSETS);
			hearthAssetsRequest.addRequestParam(new DataParamInt("hearthId"));
			facade.registerProxy(hearthAssetsRequest);
			hearthAssetsRequest.setParamValue("hearthId", hearthId);
			hearthAssetsRequest.sendRequest();
			
			var incomingHearthAssets:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.HEARTH_ASSETS_LIST, HomeHandlers.HEARTH_ASSETS_LIST);
			incomingHearthAssets.addDataParam(new DataParamArrayHearthAsset("HearthAssets"));
			facade.registerProxy(incomingHearthAssets);
			
			//This comes into play if someone else in the family is buying and selling stuff at the market. 
			var hearthAssetUpdate:IncomingDataProxy = new IncomingDataProxy(MarketHandlers.HEARTH_ASSETS_UPDATED, MarketHandlers.HEARTH_ASSETS_UPDATED);
			hearthAssetUpdate.addDataParam(new DataParamArrayHearthAsset("HearthAssets"));
			facade.registerProxy(hearthAssetUpdate);
			
			var incomingAllocUpdate:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.ALLOCATION_UPDATED, HomeHandlers.ALLOCATION_UPDATED);
			incomingAllocUpdate.addDataParam(new DataParamArrayAllocation("Allocations"));
			facade.registerProxy(incomingAllocUpdate);
			
			var subMenuProxy:SubMenuListProxy = new SubMenuListProxy();
			facade.registerProxy(subMenuProxy);
			subMenuProxy.addSubMenuItem(HomeHandlers.FOOD_SUB_MENU_OVERVIEW);
			subMenuProxy.addSubMenuItem(HomeHandlers.FOOD_SUB_MENU_DIET);
			subMenuProxy.addSubMenuItem(HomeHandlers.FOOD_SUB_MENU_ALLOCATION);
			if(!myChar.isBanker()){
				subMenuProxy.addSubMenuItem(HomeHandlers.FOOD_SUB_MENU_SELECT);
			}
			subMenuProxy.addSubMenuItem(HomeHandlers.FOOD_SUB_MENU_EXIT);
			subMenuProxy.setDefaultMenuItem(HomeHandlers.FOOD_SUB_MENU_OVERVIEW);
		}
	}
}
