/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.serverhandlers.CommsHandlers;
	import org.puremvc.as3.multicore.interfaces.*;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import uk.ac.sussex.model.PCListProxy;
	import uk.ac.sussex.model.valueObjects.PlayerChar;
	import uk.ac.sussex.model.PlayerCharProxy;
	import uk.ac.sussex.general.ApplicationFacade;

	/**
	 * @author em97
	 */
	public class PCExitRoomCommand extends SimpleCommand {
		override public function execute(note:INotification):void{
			trace ("PCExitRoomCommand sez: A PC has left the room, prepare to update the list.");
			var pc:PlayerChar = note.getBody() as PlayerChar; 
			var mypc:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;
			//If this is a notification that my pc left the room, we'll already be dealing with the talk list elsewhere.
			if(pc.getId()!= mypc.getPlayerId()){
				var talkList:PCListProxy = facade.retrieveProxy(CommsHandlers.DIR_TALK_LIST) as PCListProxy;
				if(talkList == null){
					talkList = new PCListProxy(CommsHandlers.DIR_TALK_LIST);
					facade.registerProxy(talkList);
				}
				talkList.removePC(pc);
			}
		}
	}
}
