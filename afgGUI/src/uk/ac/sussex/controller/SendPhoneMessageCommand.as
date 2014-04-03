/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.serverhandlers.CommsHandlers;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.model.CallInProgressProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SendPhoneMessageCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var message:String = note.getBody() as String;
			trace("SendPhoneMessageCommand sez: I am trying to send message " + message);
			var callProxy:CallInProgressProxy = facade.retrieveProxy(CallInProgressProxy.NAME) as CallInProgressProxy;
			var requestProxy:RequestProxy = facade.retrieveProxy(CommsHandlers.TALK_PHONE_MESSAGE + RequestProxy.NAME) as RequestProxy;
			requestProxy.setParamValue("message", message);
			requestProxy.setParamValue("CallId", callProxy.getCallId());
			requestProxy.sendRequest();
		}
	}
}
