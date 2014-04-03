/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.states {

	import uk.ac.sussex.model.valueObjects.requestParams.*;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.*;
	import uk.ac.sussex.controller.*;
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import uk.ac.sussex.view.*;
	import org.puremvc.as3.multicore.interfaces.IFacade;

	/**
	 * @author em97
	 */
	public class DietGameState extends PlayerRoomState implements IGameState {
		public static const NAME:String = "DietGameState";
		private static const DISPLAY_TITLE:String = "Diet Creation";
		public function DietGameState(facade:IFacade){
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
			this.facade.removeCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED);
			this.facade.removeCommand(HomeHandlers.SAVE_DIET);
			this.facade.removeCommand(HomeHandlers.SAVE_DIET_SUCCESS);
			this.facade.removeCommand(HomeHandlers.DIET_LIST);
			this.facade.removeCommand(ApplicationFacade.INCOMING_ERROR_MESSAGE);
			this.facade.removeCommand(ApplicationFacade.INCOMING_MESSAGE);
			
			this.facade.removeMediator(LogoutButtonMediator.NAME);
			this.facade.removeMediator(ViewAreaMediator.NAME);
			this.facade.removeMediator(ViewTextDisplayMediator.NAME);
			this.facade.removeMediator(SubMenuMediator.NAME);
			this.facade.removeMediator(FoodAllocationSelectionMediator.NAME);
			this.facade.removeMediator(DietCreationMediator.NAME);
			this.facade.removeMediator(NutritionGraphMediator.NAME);
			this.facade.removeMediator(DietContentListMediator.NAME);
			this.facade.removeMediator(DietTargetLevelDisplayMediator.NAME);
			
			this.facade.removeProxy(DietListProxy.NAME);
			this.facade.removeProxy(HomeHandlers.GET_DIET_LIST + RequestProxy.NAME);
			this.facade.removeProxy(HomeHandlers.GET_DIET_LIST_ERROR + IncomingDataProxy.NAME);
			this.facade.removeProxy(HomeHandlers.DIET_LIST + IncomingDataProxy.NAME);
			this.facade.removeProxy(HomeHandlers.SAVE_DIET + RequestProxy.NAME);
			this.facade.removeProxy(HomeHandlers.SAVE_DIET_ERROR + IncomingDataProxy.NAME);
			this.facade.removeProxy(HomeHandlers.SAVE_DIET_SUCCESS + IncomingDataProxy.NAME);
			this.facade.removeProxy(HomeHandlers.DELETE_DIET + RequestProxy.NAME);
			this.facade.removeProxy(HomeHandlers.DELETE_DIET_ERROR + IncomingDataProxy.NAME);
			this.facade.removeProxy(SubMenuListProxy.NAME);
			
			super.cleanUpState();
		}
		override public function refresh(): void {
			super.refresh();
		}
		private function registerCommands():void {
			facade.registerCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED, SubMenuDietCommand);
			facade.registerCommand(HomeHandlers.DIET_LIST, DietListReceivedCommand);
			facade.registerCommand(HomeHandlers.SAVE_DIET, SaveDietCommand);
			facade.registerCommand(HomeHandlers.SAVE_DIET_SUCCESS, SaveDietSuccessCommand);
			this.facade.registerCommand(ApplicationFacade.INCOMING_MESSAGE, DisplayServerMessageCommand);
			this.facade.registerCommand(ApplicationFacade.INCOMING_ERROR_MESSAGE, DisplayServerErrorMessageCommand);
		}
		private function registerMediators():void {
			var submenuMediator:SubMenuMediator = new SubMenuMediator();
			facade.registerMediator(submenuMediator);
			
			facade.registerMediator(new DietCreationMediator());
			facade.registerMediator(new NutritionGraphMediator());
			facade.registerMediator(new DietContentListMediator());
			facade.registerMediator(new DietTargetLevelDisplayMediator());
			
			submenuMediator.moveToDefaultButton();
			
		}
		private function registerProxies():void {	
			
			var drp:DietaryRequirementsProxy = facade.retrieveProxy(DietaryRequirementsProxy.NAME) as DietaryRequirementsProxy;
			var galp:GameAssetListProxy = facade.retrieveProxy(GameAssetListProxy.NAME) as GameAssetListProxy;
			facade.registerProxy(new DietListProxy(drp, galp));
			
			var myChar:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;
			var serverRoomProxy:ServerRoomProxy = facade.retrieveProxy(ServerRoomProxy.NAME) as ServerRoomProxy;
			var roomId:String = serverRoomProxy.getRoomId();
			var hearthId:int = int(roomId);
			
			var dietRequest:RequestProxy = new RequestProxy(HomeHandlers.GET_DIET_LIST);
			dietRequest.addRequestParam(new DataParamInt(HomeHandlers.HEARTH_ID));
			dietRequest.setParamValue(HomeHandlers.HEARTH_ID, hearthId);
			facade.registerProxy(dietRequest);
			dietRequest.sendRequest();
			
			facade.registerProxy(new IncomingDataErrorProxy(HomeHandlers.GET_DIET_LIST_ERROR));
			
			var incomingDiets:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.DIET_LIST, HomeHandlers.DIET_LIST);
			incomingDiets.addDataParam(new DataParamArrayDiet("Diets"));
			facade.registerProxy(incomingDiets);
			
			var saveDietRequest:RequestProxy = new RequestProxy(HomeHandlers.SAVE_DIET);
			saveDietRequest.addRequestParam(new DataParamInt(HomeHandlers.HEARTH_ID));
			saveDietRequest.addRequestParam(new DataParamDiet("Diet"));
			saveDietRequest.setParamValue(HomeHandlers.HEARTH_ID, hearthId);
			facade.registerProxy(saveDietRequest);
			
			var saveDietErrorIncoming:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.SAVE_DIET_ERROR, ApplicationFacade.INCOMING_ERROR_MESSAGE);
			saveDietErrorIncoming.addDataParam(new DataParamString("message"));
			facade.registerProxy(saveDietErrorIncoming);
			
			var saveDietSuccessIncoming:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.SAVE_DIET_SUCCESS, HomeHandlers.SAVE_DIET_SUCCESS);
			saveDietSuccessIncoming.addDataParam(new DataParamDiet("Diet"));
			saveDietSuccessIncoming.addDataParam(new DataParamString("message"));
			facade.registerProxy(saveDietSuccessIncoming);
			
			var deleteDietRequest:RequestProxy = new RequestProxy(HomeHandlers.DELETE_DIET);
			deleteDietRequest.addRequestParam(new DataParamInt("DietId"));
			facade.registerProxy(deleteDietRequest);
			
			var deleteDietError:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.DELETE_DIET_ERROR, ApplicationFacade.INCOMING_ERROR_MESSAGE);
			deleteDietError.addDataParam(new DataParamString("message"));
			facade.registerProxy(deleteDietError);
			
			var subMenuProxy:SubMenuListProxy = new SubMenuListProxy();
			facade.registerProxy(subMenuProxy);
			subMenuProxy.addSubMenuItem(HomeHandlers.DIET_SUB_MENU_OVERVIEW);
			if(!myChar.isBanker()){
				subMenuProxy.addSubMenuItem(HomeHandlers.DIET_SUB_MENU_NEW);
				subMenuProxy.addSubMenuItem(HomeHandlers.DIET_SUB_MENU_EDIT);
				subMenuProxy.addSubMenuItem(HomeHandlers.DIET_SUB_MENU_DELETE);
			}
			subMenuProxy.addSubMenuItem(HomeHandlers.DIET_SUB_MENU_EXIT);
			subMenuProxy.setDefaultMenuItem(HomeHandlers.DIET_SUB_MENU_OVERVIEW);
		}
	}
}
