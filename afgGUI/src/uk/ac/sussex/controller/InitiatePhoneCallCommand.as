/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.serverhandlers.CommsHandlers;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.model.valueObjects.TalkMessage;
	import uk.ac.sussex.model.CallInProgressProxy;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.PlayerCharProxy;
	import uk.ac.sussex.model.valueObjects.PlayerChar;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class InitiatePhoneCallCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var recipient:PlayerChar = note.getBody() as PlayerChar;
			var myProxy:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;
			
			var callProxy:CallInProgressProxy = new CallInProgressProxy();
			facade.registerProxy(callProxy);
			
			var callerId:int = myProxy.getPlayerId();
			
			var callingMessage:TalkMessage = new TalkMessage();
			callingMessage.setAuthorId(callerId);
			callingMessage.setMessage("Calling " + recipient.getFirstName() + " " + recipient.getFamilyName());
			
			var chargeMessage:TalkMessage = new TalkMessage();
			chargeMessage.setAuthorId(callerId);
			chargeMessage.setMessage("You will be charged when they answer.");
			
			var hangupMessage:TalkMessage = new TalkMessage();
			hangupMessage.setAuthorId(callerId);
			hangupMessage.setMessage("To end the call at any time, click the phone icon on the right.");
			
			callProxy.addCallMessage(callingMessage);
			callProxy.addCallMessage(chargeMessage);
			callProxy.addCallMessage(hangupMessage);
			
			callProxy.beginCall(myProxy.playerChar, recipient);
			
			var startCallRequest:RequestProxy = facade.retrieveProxy(CommsHandlers.START_CALL + RequestProxy.NAME) as RequestProxy;
			startCallRequest.setParamValue(CommsHandlers.RECIPIENT_ID, recipient.getId());
			startCallRequest.sendRequest();
		}
	}
}
