/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.states {
	import uk.ac.sussex.view.GameYearMediator;
	import uk.ac.sussex.view.GameLogoMediator;
	import uk.ac.sussex.view.LogoutButtonMediator;
	import flash.display.Sprite;
	import uk.ac.sussex.view.ViewAreaMediator;
	import uk.ac.sussex.view.ApplicationMediator;
	import uk.ac.sussex.view.ViewTextDisplayMediator;
	import uk.ac.sussex.controller.DisplayServerErrorMessageCommand;
	import uk.ac.sussex.controller.DisplayServerMessageCommand;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.RequestProxy;
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import uk.ac.sussex.serverhandlers.SeasonsHandlers;
	import uk.ac.sussex.serverhandlers.CommsHandlers;
	import uk.ac.sussex.states.IGameState;

	/**
	 * @author em97
	 */
	public class NavFreeGameState implements IGameState {
		protected var facade:IFacade;
		
		private var name:String;
		protected var roomDisplayTitle:String;
		
		public function NavFreeGameState(facade : IFacade, name:String, displayTitle:String) {
			this.facade = facade;
			this.name = name;
			this.roomDisplayTitle = displayTitle;
		}
		
		public function displayState() : void {
			trace("NavFreeGameState sez: This state has a display title of " + roomDisplayTitle);
			CommsHandlers.registerComponents(this.facade);
			SeasonsHandlers.registerComponents(this.facade);
			this.registerProxies();
			this.registerCommands();
			this.registerMediators();
		}

		public function cleanUpState() : void {
			CommsHandlers.removeComponents(facade);
			SeasonsHandlers.removeComponents(facade);
			this.removeMediators();
			this.removeCommands();
			this.removeProxies();
		}

		public function getName() : String {
			return this.name;
		}

		public function refresh() : void {
			//Get the season details again. 
			var seasonRequest:RequestProxy = facade.retrieveProxy(SeasonsHandlers.GET_CURRENT_SEASON + RequestProxy.NAME) as RequestProxy;
			if(seasonRequest!=null){
				seasonRequest.sendRequest();
			}
			var weatherRequest:RequestProxy = facade.retrieveProxy(SeasonsHandlers.GET_WEATHER + RequestProxy.NAME) as RequestProxy;			
			if(weatherRequest!= null){
				weatherRequest.sendRequest();
			}
		}
		protected function setDisplayTitle(newTitle:String):void {
			this.roomDisplayTitle = newTitle;
		}
		private function registerProxies():void {
			
		}
		private function removeProxies():void {
			
		}
		private function registerCommands():void {
			facade.registerCommand(ApplicationFacade.INCOMING_MESSAGE, DisplayServerMessageCommand);
			facade.registerCommand(ApplicationFacade.INCOMING_ERROR_MESSAGE, DisplayServerErrorMessageCommand);
		}
		private function removeCommands():void {
			facade.removeCommand(ApplicationFacade.INCOMING_MESSAGE);
			facade.removeCommand(ApplicationFacade.INCOMING_ERROR_MESSAGE);
		}
		private function registerMediators():void {
			var viewTextDisplayMediator:ViewTextDisplayMediator = new ViewTextDisplayMediator(new Sprite());
			this.facade.registerMediator(viewTextDisplayMediator);
			viewTextDisplayMediator.displayViewTitle(roomDisplayTitle);
			
			var appMediator:ApplicationMediator = facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;
			var viewAreaMediator:ViewAreaMediator = new ViewAreaMediator(new Sprite()) ;
			this.facade.registerMediator(viewAreaMediator);
			viewAreaMediator.setPosition(0, appMediator.getTopHeight());
			
			this.facade.registerMediator(new LogoutButtonMediator());
			this.facade.registerMediator(new GameLogoMediator());
			this.facade.registerMediator(new GameYearMediator());
		}
		private function removeMediators():void {
			facade.removeMediator(ViewTextDisplayMediator.NAME);
			facade.removeMediator(ViewAreaMediator.NAME);
			facade.removeMediator(LogoutButtonMediator.NAME);
			facade.removeMediator(GameLogoMediator.NAME);
			facade.removeMediator(GameYearMediator.NAME);
		}
	}
}
