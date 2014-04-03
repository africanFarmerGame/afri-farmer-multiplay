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
