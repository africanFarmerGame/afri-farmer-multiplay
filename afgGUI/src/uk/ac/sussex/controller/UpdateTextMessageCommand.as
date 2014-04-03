/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.serverhandlers.CommsHandlers;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.model.valueObjects.TextMessage;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class UpdateTextMessageCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var tm:TextMessage = note.getBody() as TextMessage;
			var updateTm:RequestProxy = facade.retrieveProxy(CommsHandlers.UPDATE_TEXT_MESSAGE + RequestProxy.NAME) as RequestProxy;
			updateTm.setParamValue("textMessage", tm);
			updateTm.sendRequest();
		}
	}
}
