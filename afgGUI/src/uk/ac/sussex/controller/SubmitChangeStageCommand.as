/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import uk.ac.sussex.view.SubMenuMediator;
	import uk.ac.sussex.serverhandlers.SeasonsHandlers;
	import uk.ac.sussex.model.RequestProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SubmitChangeStageCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			//Retrieve the right requestProxy. 
			var changeRequest:RequestProxy = facade.retrieveProxy(SeasonsHandlers.SUBMIT_STAGE_CHANGE_REQUEST + RequestProxy.NAME) as RequestProxy;
			changeRequest.sendRequest();
			
			var submenu:SubMenuMediator = facade.retrieveMediator(SubMenuMediator.NAME) as SubMenuMediator;
			submenu.setCurrentSelection(HomeHandlers.GM_SUB_MENU_GAMEOVERVIEW);
		}
	}
}
