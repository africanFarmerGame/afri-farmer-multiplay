package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class TalkMessage {
		private var message:String;
		private var authorId:int;
		private var authorName:String;
		public function getMessage():String {
			return this.message;
		}
		public function setMessage(newMessage:String):void {
			this.message = newMessage;
		}
		public function getAuthorId():int{
			return authorId;
		}
		public function setAuthorId(newId:int):void {
			this.authorId = newId;
		}
		public function getAuthorName():String {
			return this.authorName;
		}
		public function setAuthorName(newName:String):void {
			this.authorName = newName;
		}
	}
}
