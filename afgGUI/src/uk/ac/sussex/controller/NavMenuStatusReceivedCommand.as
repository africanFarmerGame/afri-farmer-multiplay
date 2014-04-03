/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.view.components.NavMenu;
	import uk.ac.sussex.view.NavMenuMediator;
	import uk.ac.sussex.model.valueObjects.ViewStatus;
	import uk.ac.sussex.serverhandlers.RoomHandlers;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class NavMenuStatusReceivedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("NavMenuStatusReceived sez: all fired up");
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var viewStatusArray:Array = incomingData.getParamValue(RoomHandlers.VIEW_DETAILS) as Array;
			var nmm:NavMenuMediator = facade.retrieveMediator(NavMenuMediator.NAME) as NavMenuMediator;
			for each (var vs:ViewStatus in viewStatusArray){
				var stateStatus:String;
				switch (vs.getStatus()){
					case 0:
						stateStatus = NavMenu.BUTTON_STATE_GREEN;
						break;
					case 1:
						stateStatus = NavMenu.BUTTON_STATE_AMBER;
						break;
					case 2: 
						stateStatus = NavMenu.BUTTON_STATE_RED;
						break;
					default:
						stateStatus = NavMenu.BUTTON_STATE_GREEN;
				}
				nmm.setButtonState(vs.getViewName(), stateStatus);
			}
		}
	}
}
