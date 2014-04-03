/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import uk.ac.sussex.model.valueObjects.TalkMessage;
	import uk.ac.sussex.model.CallInProgressProxy;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class PhoneCallEndedCommand extends SimpleCommand {
		private var endCallTimer:Timer;
		private const END_CALL_TIME:uint = 3000;
		
		override public function execute(note:INotification):void {
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var message:String = incomingData.getParamValue("message") as String;
			
			trace("PhoneCallEndedCommand sez: I received this message - " + message);
			
			var callProxy:CallInProgressProxy = facade.retrieveProxy(CallInProgressProxy.NAME) as CallInProgressProxy;
			var callEndedMessage:TalkMessage = new TalkMessage();
			callEndedMessage.setAuthorId(-1);
			callEndedMessage.setAuthorName("System");
			callEndedMessage.setMessage(message);
			callProxy.addCallMessage(callEndedMessage);
			
			
			endCallTimer = new Timer(END_CALL_TIME);
			endCallTimer.repeatCount = 1;
			endCallTimer.addEventListener(TimerEvent.TIMER, clearCallEvent);
			endCallTimer.start();
		}
		private function clearCallEvent(e:TimerEvent):void {
			endCallTimer.stop();
			facade.removeProxy(CallInProgressProxy.NAME);
		}
	}
}
