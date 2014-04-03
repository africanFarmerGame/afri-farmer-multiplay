package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class CallHistoryItem {
		private var id:int;
		private var callerId:int;
		private var callerName:String;
		private var receiverId:int;
		private var receiverName:String;
		private var started:Number;
		private var answered:Number;
		private var finished:Number;
		public function CallHistoryItem(){
		}
		public function getId():int {
			return this.id;
		}
		public function setId(newId:int):void {
			this.id = newId;
		}
		public function getCallerId():int {
			return this.callerId;
		}
		public function setCallerId(callerId:int):void {
			this.callerId = callerId;
		}
		public function getReceiverId():int {
			return this.receiverId;
		}
		public function setReceiverId(receiverId:int):void{
			this.receiverId = receiverId;
		}
		public function getCallerName():String {
			return this.callerName;
		}
		public function setCallerName(callerName:String):void{
			this.callerName = callerName;
		}
		public function getReceiverName():String {
			return this.receiverName;
		}
		public function setReceiverName(receiverName:String):void {
			this.receiverName = receiverName;
		}
		public function getStarted():Number {
			return this.started;
		}
		public function setStarted(started:Number):void {
			this.started = started;
		}
		public function getAnswered():Number {
			return this.answered;
		}
		public function setAnswered(answered:Number):void {
			this.answered = answered;
		}
		public function getFinished():Number {
			return this.finished;
		}
		public function setFinished(finished:Number):void {
			this.finished = finished;
		}
	}
}
