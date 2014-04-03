/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.serverhandlers {
	import uk.ac.sussex.controller.HearthsStoreCommand;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArrayHearth;
	import uk.ac.sussex.model.HearthListProxy;
	import uk.ac.sussex.model.IncomingDataProxy;
	import uk.ac.sussex.model.IncomingDataErrorProxy;
	import uk.ac.sussex.model.RequestProxy;
	import org.puremvc.as3.multicore.interfaces.IFacade;
	/**
	 * @author em97
	 */
	public class ManagerHandlers {
		
		public static const GM_FETCH_HEARTHS_OVERVIEW:String = "village.fetch_hearths_overview";
		public static const GM_FETCH_HEARTHS_OVERVIEW_ERROR:String = "fetch_hearths_overview_error";
		public static const GM_HEARTHS_OVERVIEW_INCOMING:String = "HearthsOverview";
		public static const GM_GAME_ERROR:String = "gameError";
		
		public static function registerComponents(facade:IFacade):void {
			registerProxies(facade);
			registerCommands(facade);
			registerMediators(facade);
		}
		public static function removeComponents(facade:IFacade):void {
			removeMediators(facade);
			removeCommands(facade);
			removeProxies(facade);
		}
		private static function registerProxies(facade:IFacade) :void {
			var fetchHearths:RequestProxy = new RequestProxy(GM_FETCH_HEARTHS_OVERVIEW);
			facade.registerProxy(fetchHearths);
			fetchHearths.sendRequest();
			facade.registerProxy(new IncomingDataErrorProxy(GM_FETCH_HEARTHS_OVERVIEW_ERROR));
			facade.registerProxy(new IncomingDataErrorProxy(VillageHandlers.VILLAGE_ERROR));
			facade.registerProxy(new HearthListProxy());
			
			var hearthsFetched:IncomingDataProxy = new IncomingDataProxy(GM_HEARTHS_OVERVIEW_INCOMING, GM_HEARTHS_OVERVIEW_INCOMING);
			hearthsFetched.addDataParam(new DataParamArrayHearth("HearthDetails"));
			facade.registerProxy(hearthsFetched);
			
			facade.registerProxy(new IncomingDataErrorProxy(GM_GAME_ERROR));
		}
		private static function removeProxies(facade:IFacade):void {
			facade.removeProxy(GM_FETCH_HEARTHS_OVERVIEW + RequestProxy.NAME);
			facade.removeProxy(GM_FETCH_HEARTHS_OVERVIEW_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(VillageHandlers.VILLAGE_ERROR + IncomingDataProxy.NAME);	
			facade.removeProxy(HearthListProxy.NAME);
			facade.removeProxy(GM_HEARTHS_OVERVIEW_INCOMING + IncomingDataProxy.NAME);
			facade.removeProxy(GM_GAME_ERROR + IncomingDataProxy.NAME);
		}
		private static function registerCommands(facade:IFacade):void {
			facade.registerCommand(GM_HEARTHS_OVERVIEW_INCOMING, HearthsStoreCommand);
		}
		private static function removeCommands(facade:IFacade):void {
			facade.removeCommand(GM_HEARTHS_OVERVIEW_INCOMING);
		}
		private static function registerMediators(facade:IFacade):void {
			
		}
		private static function removeMediators(facade:IFacade):void {
			
		}
	}
}
