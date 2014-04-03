/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.states {
	import uk.ac.sussex.model.SubMenuListProxy;
	import uk.ac.sussex.controller.SubMenuBankCommand;
	import uk.ac.sussex.serverhandlers.BankHandlers;
	import uk.ac.sussex.view.*;
	import org.puremvc.as3.multicore.interfaces.IFacade;

	/**
	 * @author em97
	 */
	public class BankGameState extends PlayerRoomState implements IGameState {
		public static const NAME:String = "BankGameState";
		public static const LOCATION_NAME:String = "BANK";
		
		public function BankGameState(facade : IFacade) {
			super(facade, NAME);
		}
		override public function displayState():void{
			super.displayState();
			trace("You've reached the Bank Game State");
			this.registerProxies();
			this.registerCommands();
			this.registerMediators();
		}
		override public function cleanUpState():void{
			this.removeCommands();
			this.removeMediators();
			this.removeProxies();
			super.cleanUpState();
		}
		private function registerProxies():void{
			var subMenuProxy:SubMenuListProxy = new SubMenuListProxy();
			facade.registerProxy(subMenuProxy);
			subMenuProxy.addSubMenuItem(BankHandlers.BANK_SUB_MENU_OVERVIEW);
			subMenuProxy.addSubMenuItem(BankHandlers.BANK_SUB_MENU_FINES);
			subMenuProxy.setDefaultMenuItem(BankHandlers.BANK_SUB_MENU_OVERVIEW);
		}
		private function removeProxies():void {
			
		}
		private function registerCommands():void {
			facade.registerCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED, SubMenuBankCommand);
		}
		private function removeCommands():void {
			facade.removeCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED);
		}
		private function registerMediators():void {
			var submenuMediator:SubMenuMediator = new SubMenuMediator();
			facade.registerMediator(submenuMediator);
		
			submenuMediator.moveToDefaultButton();
		}
		private function removeMediators():void {
			facade.removeMediator(SubMenuMediator.NAME);
		}
	}
}
