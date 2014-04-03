package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class SeasonNotification {
		private var id:int;
		private var notification:String;
		private var previousStage:String;
		private var nextStage:String;
		
		public function SeasonNotification():void {
			
		}
		public function getId():int {
			return id;
		}
		public function setId(newId:int):void {
			this.id = newId;
		}
		public function getNotification():String {
			return this.notification;
		}
		public function setNotification(newMessage:String):void {
			this.notification = newMessage;
		}
		public function getPreviousStage():String {
			return this.previousStage;
		}
		public function setPreviousStage(previousStage:String):void {
			this.previousStage = previousStage;
		}
		public function getNextStage():String {
			return this.nextStage;
		}
		public function setNextStage(nextStage:String):void {
			this.nextStage = nextStage;
		}
	}
}
