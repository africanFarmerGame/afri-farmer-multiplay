/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.states.FinesGameState;
	import uk.ac.sussex.serverhandlers.BankHandlers;
	import uk.ac.sussex.general.ApplicationFacade;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SubMenuBankCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("SubMenuBankCommand sez: I have been fired");
			var subMenuItem:String = note.getBody() as String;
			switch(subMenuItem){
				case BankHandlers.BANK_SUB_MENU_OVERVIEW:
					sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, "Overview:");
					break;
				case BankHandlers.BANK_SUB_MENU_FINES:
					sendNotification(ApplicationFacade.CHANGE_STATE, FinesGameState.NAME);
					break;
			}
		}
	}
}
