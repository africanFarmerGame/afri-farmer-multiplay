/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model {
	import uk.ac.sussex.model.valueObjects.CallHistory;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.interfaces.IProxy;

	/**
	 * @author em97
	 */
	public class CallHistoryProxy extends Proxy implements IProxy {
		public static const NAME:String = "CallHistoryProxy";
		public static const RECEIVED_INCOMING:String = "ReceivedIncomingCallHistory";
		public static const RECEIVED_OUTGOING:String = "ReceivedOutgoingCallHistory";
		
		public function CallHistoryProxy() {
			super(NAME, null);
		}
		public function addIncomingCalls(incomingCalls:Array):void {
			callHistory.setIncomingCalls(incomingCalls);
			sendNotification(RECEIVED_INCOMING);
		}
		public function addOutgoingCalls(outgoingCalls:Array):void {
			callHistory.setOutgoingCalls(outgoingCalls);
			sendNotification(RECEIVED_OUTGOING);
		}
		public function getCallHistoryList():Array {
			return callHistory.getAllCalls();
		}
		protected function get callHistory():CallHistory {
			return data as CallHistory;
		}
		override public function onRegister():void{
			data = new CallHistory();
		}
	}
}
