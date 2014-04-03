package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class CallInProgress {
		private var callContent:Array;
		private var caller:PlayerChar;
		private var callRecipient:PlayerChar;
		private var answered:Number;
		private var callId:int;
		
		public function CallInProgress():void {
			this.callContent = new Array();
		}
		public function getCallContent():Array{
			return this.callContent;
		}
		public function addCallContentItem(talkMessage:TalkMessage):void {
			this.callContent.push(talkMessage);
		}
		public function getCaller():PlayerChar {
			return this.caller;
		}
		public function setCaller(caller:PlayerChar):void {
			this.caller = caller;
		}
		public function getCallRecipient():PlayerChar {
			return this.callRecipient;
		}
		public function setCallRecipient(newRecipient:PlayerChar):void {
			this.callRecipient = newRecipient;
		}
		public function getAnswered():Number {
			return this.answered;
		}
		public function setAnswered(answered:Number):void {
			this.answered = answered;
		}
		public function setCallId(newCallId:int):void {
			this.callId = newCallId;
		}
		public function getCallId():int {
			return this.callId;
		}
	}
}
