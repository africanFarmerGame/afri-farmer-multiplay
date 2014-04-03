/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.view.FinesGMOverviewListMediator;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.states.BankManagerGameState;
	import uk.ac.sussex.serverhandlers.BankHandlers;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SubMenuFinesManagerCommands extends SimpleCommand {
		override public function execute(note:INotification):void {
			
			var menuItem:String = note.getBody() as String;
			
			var finesOverview:FinesGMOverviewListMediator = facade.retrieveMediator(FinesGMOverviewListMediator.NAME) as FinesGMOverviewListMediator;
			if(finesOverview!=null){
				finesOverview.showList(false);
			}
			
			switch(menuItem){
				case BankHandlers.GM_FINES_SUB_MENU_LIST:
					finesOverview.showList(true);
					break;
				case BankHandlers.GM_FINES_SUB_MENU_EXIT:
					sendNotification(ApplicationFacade.CHANGE_STATE, BankManagerGameState.NAME);
					break;
			}
		}
	}
}
