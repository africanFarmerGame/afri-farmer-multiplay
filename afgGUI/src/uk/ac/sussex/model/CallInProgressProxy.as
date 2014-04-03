/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model {
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.valueObjects.TalkMessage;
	import uk.ac.sussex.model.valueObjects.PlayerChar;
	import uk.ac.sussex.model.valueObjects.CallInProgress;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.interfaces.IProxy;

	/**
	 * @author em97
	 */
	public class CallInProgressProxy extends Proxy implements IProxy {
		public static const NAME:String = "CallInProgressProxy";
		public static const CALL_BEGUN:String = "CIPPCallBegun";
		public static const CALL_ENDED:String = "CIPPCallEnded";
		public static const CALL_ANSWERED:String = "CIPPCallAnswered";
		public static const CALL_CONTENT_ADDED:String = "CIPPCallContentAdded";
		
		public function CallInProgressProxy() {
			super(NAME, null);
		}
		public function beginCall(caller:PlayerChar, recipient:PlayerChar):void{
			call.setCaller(caller);
			call.setCallRecipient(recipient);
			sendNotification(CALL_BEGUN);
		}
		public function answerCall(answered:Number):void {
			call.setAnswered(answered);
			sendNotification(CALL_ANSWERED);
		} 
		public function addCallMessage(message:TalkMessage):void {
			call.addCallContentItem(message);
			sendNotification(CALL_CONTENT_ADDED, message);
		}
		public function getCallContent():Array {
			return call.getCallContent();
		}
		public function callNeedsAnswering():Boolean {
			//Does this call need answering?
			if(call.getAnswered()>0){
				return false;  
			} else {
				var myProxy:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;
				return (call.getCallRecipient().getId()==myProxy.getPlayerId());
			}
			
		}
		public function getCallAnswered():Number {
			if(isNaN(call.getAnswered())){
				return 0;
			} else {
				return call.getAnswered();
			}
		}
		public function setCallId(callId:int):void{
			call.setCallId(callId);
		}
		public function getCallId():int {
			return call.getCallId();
		}
		override public function onRegister():void {
			this.data = new CallInProgress();
		}
		override public function onRemove():void {
			sendNotification(CALL_ENDED);
		}
		private function get call():CallInProgress {
			return this.data as CallInProgress;
		}
	}
}
