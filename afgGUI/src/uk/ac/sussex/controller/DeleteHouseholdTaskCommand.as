/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.serverhandlers.FarmHandlers;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class DeleteHouseholdTaskCommand extends SimpleCommand {
		
		override public function execute(note:INotification):void {
			trace("DeleteHouseholdTaskCommand sez: I has been fired.");
			var selectedId:String = note.getBody() as String;
			trace("DeleteHouseholdTaskCommand sez: The id selected is " + selectedId);
			var deleteProxy:RequestProxy = facade.retrieveProxy(FarmHandlers.DELETE_HOUSEHOLD_TASK + RequestProxy.NAME) as RequestProxy;
			if(deleteProxy != null && selectedId != null){
				var selectedintId:int = int(selectedId);
				deleteProxy.setParamValue(FarmHandlers.TASK_ID, selectedintId);
				deleteProxy.sendRequest();
			}
		}
	}
}
