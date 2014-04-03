/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.interfaces.*;

	import uk.ac.sussex.general.ApplicationFacade;
	
	/**
	 * @author em97
	 */
	public class LostConnectionCommand extends SimpleCommand {
		override public function execute(note:INotification):void{
			sendNotification(ApplicationFacade.DISPLAY_MESSAGE, "Lost server connection, please log in again.");
			sendNotification(ApplicationFacade.LOGOUT_SUCCESSFUL);
		}
	}
}
