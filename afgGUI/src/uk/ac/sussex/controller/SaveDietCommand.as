/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.PlayerCharProxy;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.model.valueObjects.Diet;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SaveDietCommand extends SimpleCommand {
		override public function execute (note:INotification):void {
			trace("SaveDietCommand sez: I haz been fired.");
			var diet:Diet = note.getBody() as Diet;
			var myChar:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;
			var saveDietRequest:RequestProxy = facade.retrieveProxy(HomeHandlers.SAVE_DIET + RequestProxy.NAME) as RequestProxy;
			saveDietRequest.setParamValue("Diet", diet);
			saveDietRequest.setParamValue("hearthId", myChar.getPCHearthId());
			saveDietRequest.sendRequest();
			sendNotification(ApplicationFacade.SWITCH_SUBMENU_ITEM, HomeHandlers.DIET_SUB_MENU_OVERVIEW);
		}
	}
}
