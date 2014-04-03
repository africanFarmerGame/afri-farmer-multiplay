/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.states {
	
	import uk.ac.sussex.model.SubMenuListProxy;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamString;
	import uk.ac.sussex.model.FormProxy;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.PlayerCharProxy;
	import uk.ac.sussex.controller.*;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArrayFines;
	import uk.ac.sussex.model.IncomingDataProxy;
	import uk.ac.sussex.model.IncomingDataErrorProxy;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamInt;
	import uk.ac.sussex.model.FinesProxy;
	import uk.ac.sussex.serverhandlers.BankHandlers;
	import flash.display.Sprite;
	import uk.ac.sussex.view.*;
	import uk.ac.sussex.model.RequestProxy;
	import org.puremvc.as3.multicore.interfaces.IFacade;

	/**
	 * @author em97
	 */
	public class FinesGameState extends PlayerRoomState implements IGameState {
		
		public static const NAME:String = "FinesGameState";
		private static const DISPLAY_TITLE:String = "Bills";
	
		public function FinesGameState(facade : IFacade) {
			super(facade, NAME, DISPLAY_TITLE);
			//super(facade, NAME);
		}
		
		override public function displayState() : void {
			trace("FinesGameState sez: My display title should be " + roomDisplayTitle);
			super.displayState();
			this.registerProxies();
			this.registerCommands();
			this.registerMediators();
		}
		override public function cleanUpState() : void {
			this.removeMediators();
			this.removeCommands();
			this.removeProxies();
			super.cleanUpState();
		}
		override public function refresh():void {
			super.refresh();
		}
		private function registerProxies():void{
			var myChar:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;
			var hearthId:int = myChar.getPCHearthId();
			
			facade.registerProxy(new FinesProxy());
			
			var finesRequest:RequestProxy = new RequestProxy(BankHandlers.FINES_REQUEST);
			finesRequest.addRequestParam(new DataParamInt("hearthId"));
			finesRequest.setParamValue("hearthId", hearthId);
			facade.registerProxy(finesRequest);
			finesRequest.sendRequest();
			
			facade.registerProxy(new IncomingDataErrorProxy(BankHandlers.BANK_ERROR));
			facade.registerProxy(new IncomingDataErrorProxy(BankHandlers.FINES_REQUEST_ERROR));
			var incomingFines:IncomingDataProxy = new IncomingDataProxy(BankHandlers.FINES_REQUEST_SUCCESS, BankHandlers.FINES_REQUEST_SUCCESS);
			incomingFines.addDataParam(new DataParamArrayFines("Fines"));
			facade.registerProxy(incomingFines);
			
			var payFinesFormProxy:FormProxy = new FormProxy(BankHandlers.FINES_PAY_FORM);
			facade.registerProxy(payFinesFormProxy);
			payFinesFormProxy.addDisplayText(BankHandlers.FINES_DESCRIPTION, "Description");
			payFinesFormProxy.addDisplayText(BankHandlers.FINES_RATE, "Pay Rate");
			payFinesFormProxy.addBackendData(BankHandlers.FINES_ID);
			payFinesFormProxy.addButton("Pay Bill", BankHandlers.FINES_FORM_SUBMIT);
			payFinesFormProxy.addButton("Cancel", BankHandlers.FINES_FORM_CANCEL);
			
			var payFinesRequest:RequestProxy = new RequestProxy(BankHandlers.FINES_PAY);
			payFinesRequest.addRequestParam(new DataParamInt("FineId"));
			facade.registerProxy(payFinesRequest);
			facade.registerProxy(new IncomingDataErrorProxy(BankHandlers.FINES_PAY_ERROR));
			
			var payFinesSuccess:IncomingDataProxy = new IncomingDataProxy(BankHandlers.FINES_PAY_SUCCESS, ApplicationFacade.INCOMING_MESSAGE);
			payFinesSuccess.addDataParam(new DataParamString("message"));
			
			facade.registerProxy(payFinesSuccess);
			
			var subMenuProxy:SubMenuListProxy = new SubMenuListProxy();
			facade.registerProxy(subMenuProxy);
			subMenuProxy.addSubMenuItem(BankHandlers.FINES_SUB_MENU_LIST);
			subMenuProxy.addSubMenuItem(BankHandlers.FINES_SUB_MENU_PAY);
			subMenuProxy.addSubMenuItem(BankHandlers.FINES_SUB_MENU_EXIT);
			subMenuProxy.setDefaultMenuItem(BankHandlers.FINES_SUB_MENU_LIST);
		}
		private function removeProxies():void {
			facade.removeProxy(FinesProxy.NAME);
			facade.removeProxy(BankHandlers.FINES_REQUEST + RequestProxy.NAME);
			facade.removeProxy(BankHandlers.BANK_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(BankHandlers.FINES_REQUEST_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(BankHandlers.FINES_REQUEST_SUCCESS + IncomingDataProxy.NAME);
			facade.removeProxy(BankHandlers.FINES_PAY_FORM);
			facade.removeProxy(BankHandlers.FINES_PAY + RequestProxy.NAME);
			facade.removeProxy(BankHandlers.FINES_PAY_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(BankHandlers.FINES_PAY_SUCCESS + IncomingDataProxy.NAME);
			facade.removeProxy(SubMenuListProxy.NAME);
		}
		private function registerCommands():void {
			facade.registerCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED, SubMenuFinesCommand);
			facade.registerCommand(BankHandlers.FINES_REQUEST_SUCCESS, ReceiveFinesCommand);
			facade.registerCommand(BankHandlers.FINES_FORM_CANCEL, CancelPayFineFormCommand);
			facade.registerCommand(BankHandlers.FINES_FORM_SUBMIT, SubmitPayFineFormCommand);
		}
		private function removeCommands():void {
			facade.removeCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED);
			facade.removeCommand(BankHandlers.FINES_REQUEST_SUCCESS);
			facade.removeCommand(BankHandlers.FINES_FORM_CANCEL);
			facade.removeCommand(BankHandlers.FINES_FORM_SUBMIT);
		}
		private function registerMediators():void {
			var submenuMediator:SubMenuMediator = new SubMenuMediator();
			facade.registerMediator(submenuMediator);
			
			facade.registerMediator(new FinesListMediator());
			
			var payFormMediator:FormMediator = new FormMediator(BankHandlers.FINES_PAY_FORM, new Sprite());
			facade.registerMediator(payFormMediator);
			payFormMediator.setLabelWidth(100);
			
			
			submenuMediator.moveToDefaultButton();
		}
		private function removeMediators():void {
			facade.removeMediator(SubMenuMediator.NAME);
			facade.removeMediator(FinesListMediator.NAME);
			facade.removeMediator(BankHandlers.FINES_PAY_FORM);
		}
	}
}
