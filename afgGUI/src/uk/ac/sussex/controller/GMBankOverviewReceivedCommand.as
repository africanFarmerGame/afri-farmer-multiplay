/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.serverhandlers.BankHandlers;
	import uk.ac.sussex.model.HearthsFinancialStatusProxy;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class GMBankOverviewReceivedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("GMBankOverviewReceivedCommand sez: Awakened... to store financial details");
			
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var fsProxy:HearthsFinancialStatusProxy = facade.retrieveProxy(HearthsFinancialStatusProxy.NAME) as HearthsFinancialStatusProxy;
			if(fsProxy == null){
				throw new Error("The HearthsFinancialStatusProxy is null.");
			}
			var fsArray:Array = incomingData.getParamValue(BankHandlers.GM_OVERVIEW_HEARTH_DETAILS) as Array;
			if(fsArray==null){
				throw new Error("The incoming data array was null.");
			}
			fsProxy.addHouseholdStatuses(fsArray);
		}
	}
}
