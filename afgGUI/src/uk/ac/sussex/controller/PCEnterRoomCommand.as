/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.AnyChar;
	import uk.ac.sussex.serverhandlers.CommsHandlers;
	import org.puremvc.as3.multicore.interfaces.*;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import uk.ac.sussex.model.PCListProxy;
	import uk.ac.sussex.model.valueObjects.PlayerChar;

	/**
	 * @author em97
	 */
	public class PCEnterRoomCommand extends SimpleCommand {
		override public function execute(note:INotification):void{
				//Add the playerchar to the talkList. 
				var pc:PlayerChar = note.getBody() as PlayerChar;
				pc.setOnlineStatus(true);
				if(pc.getRole() != AnyChar.BANKER){
					var talkList:PCListProxy = facade.retrieveProxy(CommsHandlers.DIR_TALK_LIST) as PCListProxy;
					if(talkList == null){
						talkList = new PCListProxy(CommsHandlers.DIR_TALK_LIST);
						facade.registerProxy(talkList);
					}
					talkList.addPC(pc);
				}
		}			
	}
}
