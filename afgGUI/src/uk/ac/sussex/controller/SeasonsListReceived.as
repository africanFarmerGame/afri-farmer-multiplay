/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.IncomingDataProxy;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.serverhandlers.SeasonsHandlers;
	import uk.ac.sussex.model.SeasonsListProxy;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SeasonsListReceived extends SimpleCommand {
		override public function execute( note:INotification ):void {
			trace("SeasonsListReceived sez: We done received some seasons.");
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var seasons:Array = incomingData.getParamValue("AllSeasons") as Array;
			
			var seasonsListProxy:SeasonsListProxy = facade.retrieveProxy(SeasonsListProxy.NAME) as SeasonsListProxy;
			if(seasonsListProxy == null){
				seasonsListProxy = new SeasonsListProxy();
				facade.registerProxy(seasonsListProxy);
			}
			seasonsListProxy.addManySeasons(seasons);
			
			facade.removeProxy(SeasonsHandlers.GET_SEASONS + RequestProxy.NAME);
			facade.removeProxy(SeasonsHandlers.SEASONS_LIST + IncomingDataProxy.NAME);
			facade.removeCommand(SeasonsHandlers.SEASONS_LIST);
		}
	}
}
