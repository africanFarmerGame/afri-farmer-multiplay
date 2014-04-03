/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view {
	import uk.ac.sussex.serverhandlers.GameHandlers;
	import uk.ac.sussex.states.*;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import flash.events.Event;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.view.components.NavMenu;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	/**
	 * @author em97
	 */
	public class NavMenuMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "NavMenuMediator";
		private var isBanker:Boolean;
		
		public function NavMenuMediator(viewComponent : Object = null, isBanker:Boolean = false) {
			this.isBanker = isBanker;
			super(NAME, viewComponent);
		}
		override public function listNotificationInterests():Array {
			return [];
		}
		override public function handleNotification (note:INotification):void {
			switch(note.getName()){
			}
		}
		public function switchButtonHighlight(stateName:String):void {
			switch(stateName){
				case HomeGameState.NAME:
					navMenu.highlightButton(NavMenu.HOME_BUTTON);
					break;
				case MarketGameState.NAME:
					navMenu.highlightButton(NavMenu.MARKET_BUTTON);
					break;
				case FarmGameState.NAME:
					navMenu.highlightButton(NavMenu.FARM_BUTTON);
					break;
				case VillageGameState.NAME:
					navMenu.highlightButton(NavMenu.VILLAGE_BUTTON);
					break;
				case BankGameState.NAME:
					navMenu.highlightButton(NavMenu.BANK_BUTTON);
					break;
				default:
					navMenu.clearButtonHighlights();
			}
		}
		public function setButtonState(stateName:String, stateStatus:String):void{
			var buttonName:String = getButtonNameFromState(stateName);
			if(buttonName!=null&&buttonName!=""){
				navMenu.setButtonState(buttonName, stateStatus);
			}
		}
		/**
		* @param stateName String This is actually the state location name. 
		* @param disable True to disable or false.
		**/
		public function disableButton(stateName:String, disable:Boolean):void {
			var buttonName:String = getButtonNameFromState(stateName);
			navMenu.disableButton(buttonName, disable);
		}
		private function homeButtonSelected(e:Event):void {
			this.requestLocationMove(HomeGameState.LOCATION_NAME);
		}
		private function farmButtonSelected(e:Event):void {
			this.requestLocationMove(FarmGameState.LOCATION_NAME);
		}
		private function marketButtonSelected(e:Event):void {
			this.requestLocationMove(MarketGameState.LOCATION_NAME);
		}
		private function villageButtonSelected(e:Event):void {
			this.requestLocationMove(VillageGameState.LOCATION_NAME);
		}
		private function bankButtonSelected(e:Event):void{
			this.requestLocationMove(BankGameState.LOCATION_NAME);
		}
		private function requestLocationMove(location:String):void{
			var dataArray:Array = new Array();
			dataArray["location"] = location;
			
			sendNotification(GameHandlers.REQUEST_LOCATION_MOVE, dataArray);
		}
		/**
		private function infoButtonSelected(e:Event):void {
			sendNotification(ApplicationFacade.DISPLAY_GAME_INFO);
		}*/
		private function getButtonNameFromState(stateName:String):String {
			trace("NavMenuMediator sez: the stateName I'm looking for is " + stateName);
			switch(stateName){
				case HomeGameState.LOCATION_NAME:
					return NavMenu.HOME_BUTTON;
				case MarketGameState.LOCATION_NAME:
					return NavMenu.MARKET_BUTTON;
				case FarmGameState.LOCATION_NAME:
					return NavMenu.FARM_BUTTON;
				case VillageGameState.LOCATION_NAME:
					return NavMenu.VILLAGE_BUTTON;
				case BankGameState.LOCATION_NAME:
					return NavMenu.BANK_BUTTON;
			}
		}
		override public function onRegister():void
		{
			viewComponent = new NavMenu(this.isBanker);
			
			navMenu.addEventListener(NavMenu.BANK_BUTTON_PRESSED, bankButtonSelected);
			navMenu.addEventListener(NavMenu.VILLAGE_BUTTON_PRESSED, villageButtonSelected);
			navMenu.addEventListener(NavMenu.FARM_BUTTON_PRESSED, farmButtonSelected);
			navMenu.addEventListener(NavMenu.MARKET_BUTTON_PRESSED, marketButtonSelected);
			navMenu.addEventListener(NavMenu.HOME_BUTTON_PRESSED, homeButtonSelected);
			
			//navMenu.addEventListener(NavMenu.INFO_BUTTON_PRESSED, infoButtonSelected);
			
			navMenu.x = 245;
			
			sendNotification(ApplicationFacade.ADD_TO_CONTROLS, navMenu);
		}
		override public function onRemove():void
		{
			navMenu.removeEventListener(NavMenu.BANK_BUTTON_PRESSED, bankButtonSelected);
			navMenu.removeEventListener(NavMenu.VILLAGE_BUTTON_PRESSED, villageButtonSelected);
			navMenu.removeEventListener(NavMenu.FARM_BUTTON_PRESSED, farmButtonSelected);
			navMenu.removeEventListener(NavMenu.MARKET_BUTTON_PRESSED, marketButtonSelected);
			navMenu.removeEventListener(NavMenu.HOME_BUTTON_PRESSED, homeButtonSelected);
			
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, navMenu);
		}
		protected function get navMenu():NavMenu {
			return viewComponent as NavMenu;
		}
	}
}
