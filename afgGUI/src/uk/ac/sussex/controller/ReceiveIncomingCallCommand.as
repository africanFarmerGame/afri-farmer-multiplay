/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.PlayerChar;
	import uk.ac.sussex.model.PCListProxy;
	import uk.ac.sussex.model.TalkMessageListProxy;
	import uk.ac.sussex.model.valueObjects.TalkMessage;
	import uk.ac.sussex.model.CallInProgressProxy;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.PlayerCharProxy;
	import uk.ac.sussex.serverhandlers.CommsHandlers;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class ReceiveIncomingCallCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var callerId:int = incomingData.getParamValue(CommsHandlers.CALLER_ID) as int;
			var callerName:String = incomingData.getParamValue(CommsHandlers.CALLER_NAME) as String;
			var callId:int = incomingData.getParamValue("CallId") as int;
			
			var allChars:PCListProxy = facade.retrieveProxy(CommsHandlers.DIR_ALL_PCS) as PCListProxy;
			var caller:PlayerChar = allChars.getPC(callerId);
			
			var myProxy:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;
			
			var callInProgressProxy:CallInProgressProxy = new CallInProgressProxy();
			facade.registerProxy(callInProgressProxy);
			var talkProxy:TalkMessageListProxy = facade.retrieveProxy(TalkMessageListProxy.NAME) as TalkMessageListProxy;
			
			var callingMessage:TalkMessage = new TalkMessage();
			callingMessage.setAuthorId(callerId);
			callingMessage.setAuthorName(callerName);
			callingMessage.setMessage(callerName + " is calling...");
			
			callInProgressProxy.addCallMessage(callingMessage);
			talkProxy.addMessage(callingMessage);
			
			var toAnswerMessage:TalkMessage = new TalkMessage();
			toAnswerMessage.setAuthorId(myProxy.getPlayerId());
			toAnswerMessage.setMessage("Click the phone button to answer the call.");
			
			talkProxy.addMessage(toAnswerMessage);
			callInProgressProxy.addCallMessage(toAnswerMessage);
			callInProgressProxy.setCallId(callId);
			trace("ReceiveIncomingCallCommand sez: I received a call with id " + callId);
			
			callInProgressProxy.beginCall(caller, myProxy.playerChar);
		}
	}
}
