package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class CallHistory {
		private var incomingCalls:Array;
		private var outgoingCalls:Array;
		public function getIncomingCalls():Array {
			return incomingCalls;
		}
		public function setIncomingCalls(incomingCalls:Array):void {
			this.incomingCalls = incomingCalls;
		}
		public function getOutgoingCalls():Array {
			return outgoingCalls;
		}
		public function setOutgoingCalls(outgoingCalls:Array):void{
			this.outgoingCalls = outgoingCalls;
		}
		public function getAllCalls():Array{
			var allCalls:Array = incomingCalls.concat(outgoingCalls);
			allCalls.sort(sortOnStartTime);
			return allCalls;
		}
		private function sortOnStartTime(a:CallHistoryItem, b:CallHistoryItem):Number {
    		var aStarted:Number = a.getStarted();
    		var bStarted:Number = b.getStarted();

    		if(aStarted > bStarted) {
        		return 1;
    		} else if(aStarted < bStarted) {
        		return -1;
   	 		} else  {
        		return 0;
		    }
		}
	}
}
