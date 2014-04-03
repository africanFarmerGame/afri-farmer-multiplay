package uk.ac.sussex.states {
	import uk.ac.sussex.model.valueObjects.HearthAsset;
	import uk.ac.sussex.serverhandlers.MarketHandlers;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.valueObjects.requestParams.*;
	import uk.ac.sussex.controller.*;
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import uk.ac.sussex.model.*;
	import uk.ac.sussex.view.*;
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import uk.ac.sussex.states.IGameState;

	/**
	 * @author em97
	 */
	public class AllocationGameState extends PlayerRoomState implements IGameState {
		public static const NAME:String = "AllocationGameState";
		private static const DISPLAY_TITLE:String = "Food Allocation";
		
		public function AllocationGameState(facade:IFacade){
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
			//remove commands
			facade.removeCommand(ApplicationFacade.INCOMING_ERROR_MESSAGE);
			facade.removeCommand(ApplicationFacade.INCOMING_MESSAGE);
			facade.removeCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED);
			facade.removeCommand(HomeHandlers.DIET_LIST);
			facade.removeCommand(HomeHandlers.ALLOCATIONS_LIST);
			facade.removeCommand(HomeHandlers.SAVE_ALLOCATION);
			facade.removeCommand(HomeHandlers.SAVE_ALLOCATION_SUCCESS);
			facade.removeCommand(HomeHandlers.HEARTH_ASSETS_LIST);
			facade.removeCommand(MarketHandlers.HEARTH_ASSETS_UPDATED);
			facade.removeCommand(HomeHandlers.ALLOCATION_UPDATED);
			//remove mediators
			facade.removeMediator(SubMenuMediator.NAME);
			facade.removeMediator(AllocationCreationMediator.NAME);
			//remove proxies
			facade.removeProxy(HomeHandlers.ALLOCATIONS_LIST + IncomingDataProxy.NAME);
			facade.removeProxy(HomeHandlers.GET_ALLOCATIONS + RequestProxy.NAME);
			facade.removeProxy(HomeHandlers.GET_ALLOCATIONS_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(HomeHandlers.GET_DIET_LIST + RequestProxy.NAME);
			facade.removeProxy(HomeHandlers.GET_DIET_LIST_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(HomeHandlers.DIET_LIST + IncomingDataProxy.NAME);
			facade.removeProxy(AllocationListProxy.NAME);
			facade.removeProxy(DietListProxy.NAME);
			facade.removeProxy(HomeHandlers.SAVE_ALLOCATION + RequestProxy.NAME);
			facade.removeProxy(HomeHandlers.SAVE_ALLOCATION_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(HomeHandlers.SAVE_ALLOCATION_SUCCESS + IncomingDataProxy.NAME);
			facade.removeProxy(HearthAsset.OWNER_HEARTH + HearthAssetListProxy.NAME);
			facade.removeProxy(MarketHandlers.HEARTH_ASSETS_UPDATED + IncomingDataProxy.NAME);
			facade.removeProxy(SubMenuListProxy.NAME);
			facade.removeProxy(HomeHandlers.ALLOCATION_UPDATED + IncomingDataProxy.NAME);
			super.cleanUpState();
		}
		override public function refresh():void {
			super.refresh();
		}
		private function registerProxies():void {
			var hearthMembersProxy:HearthMembersListProxy = facade.retrieveProxy(HearthMembersListProxy.NAME) as HearthMembersListProxy;
			var gameAssetsLP:GameAssetListProxy = facade.retrieveProxy(GameAssetListProxy.NAME) as GameAssetListProxy;
			facade.registerProxy(new AllocationListProxy(hearthMembersProxy, gameAssetsLP));
			var drp:DietaryRequirementsProxy = facade.retrieveProxy(DietaryRequirementsProxy.NAME) as DietaryRequirementsProxy;
			facade.registerProxy(new DietListProxy(drp, gameAssetsLP));
			
			var allocationsError:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.GET_ALLOCATIONS_ERROR, ApplicationFacade.INCOMING_ERROR_MESSAGE);
			allocationsError.addDataParam(new DataParamString("message"));
			facade.registerProxy(allocationsError);
			
			var allocationsReceived:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.ALLOCATIONS_LIST, HomeHandlers.ALLOCATIONS_LIST);
			allocationsReceived.addDataParam(new DataParamArrayAllocation("Allocations"));
			facade.registerProxy(allocationsReceived);
			
			var myChar:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;
			var serverRoomProxy:ServerRoomProxy = facade.retrieveProxy(ServerRoomProxy.NAME) as ServerRoomProxy;
			var roomId:String = serverRoomProxy.getRoomId();
			var hearthId:int = int(roomId);	
			
			var getAllocations:RequestProxy = new RequestProxy(HomeHandlers.GET_ALLOCATIONS);
			getAllocations.addRequestParam(new DataParamInt("hearthId"));
			getAllocations.setParamValue("hearthId", hearthId);
			facade.registerProxy(getAllocations);
			getAllocations.sendRequest();
			
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
			
			var saveAllocationRequest:RequestProxy = new RequestProxy(HomeHandlers.SAVE_ALLOCATION);
			saveAllocationRequest.addRequestParam(new DataParamAllocation("Allocation"));
			saveAllocationRequest.addRequestParam(new DataParamInt("hearthId"));
			saveAllocationRequest.setParamValue("hearthId", hearthId);
			facade.registerProxy(saveAllocationRequest);
			
			var saveAllocationSuccess:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.SAVE_ALLOCATION_SUCCESS, HomeHandlers.SAVE_ALLOCATION_SUCCESS);
			saveAllocationSuccess.addDataParam(new DataParamAllocation("Allocation"));
			facade.registerProxy(saveAllocationSuccess);
			
			var saveAllocationError:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.SAVE_ALLOCATION_ERROR, ApplicationFacade.INCOMING_ERROR_MESSAGE);
			saveAllocationError.addDataParam(new DataParamString("message"));
			facade.registerProxy(saveAllocationError);
			
			var deleteAllocationRequest:RequestProxy = new RequestProxy(HomeHandlers.DELETE_ALLOCATION);
			deleteAllocationRequest.addRequestParam(new DataParamInt("AllocationId"));
			facade.registerProxy(deleteAllocationRequest);
			
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
			subMenuProxy.addSubMenuItem(HomeHandlers.ALLOC_SUB_MENU_OVERVIEW);
			if(!myChar.isBanker()){
				subMenuProxy.addSubMenuItem(HomeHandlers.ALLOC_SUB_MENU_NEW);
				subMenuProxy.addSubMenuItem(HomeHandlers.ALLOC_SUB_MENU_EDIT);
				subMenuProxy.addSubMenuItem(HomeHandlers.ALLOC_SUB_MENU_DELETE);
			}
			subMenuProxy.addSubMenuItem(HomeHandlers.ALLOC_SUB_MENU_EXIT);
			subMenuProxy.setDefaultMenuItem(HomeHandlers.ALLOC_SUB_MENU_OVERVIEW);
			
		}
		private function registerCommands():void {
			facade.registerCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED, SubMenuAllocationCommand);
			facade.registerCommand(HomeHandlers.DIET_LIST, DietListReceivedCommand);
			facade.registerCommand(HomeHandlers.ALLOCATIONS_LIST, AllocationListReceivedCommand);
			facade.registerCommand(HomeHandlers.SAVE_ALLOCATION, SaveAllocationCommand);
			facade.registerCommand(HomeHandlers.SAVE_ALLOCATION_SUCCESS, SaveAllocationSuccessCommand);
			this.facade.registerCommand(ApplicationFacade.INCOMING_MESSAGE, DisplayServerMessageCommand);
			this.facade.registerCommand(ApplicationFacade.INCOMING_ERROR_MESSAGE, DisplayServerErrorMessageCommand);
			facade.registerCommand(AllocationListProxy.CURRENT_ALLOCATION_CONTENTS_CHANGED, CurrentAllocationContentsChangedCommand);
			facade.registerCommand(HomeHandlers.HEARTH_ASSETS_LIST, HomeHearthAssetsReceivedCommand);
      		facade.registerCommand(MarketHandlers.HEARTH_ASSETS_UPDATED, HearthAssetsUpdatedCommand);
			facade.registerCommand(HomeHandlers.ALLOCATION_UPDATED, AllocationUpdateReceivedCommand);
		}
		private function registerMediators():void {	
			var submenuMediator:SubMenuMediator = new SubMenuMediator();
			facade.registerMediator(submenuMediator);
			
			facade.registerMediator(new AllocationCreationMediator());
			submenuMediator.moveToDefaultButton();
		}
	}
}
