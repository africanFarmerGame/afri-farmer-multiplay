package uk.ac.sussex.model.valueObjects {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * @author em97
	 */
	public class TextMessage extends EventDispatcher {
		private var id:int;
		private var senderId:int;
		private var senderName:String;
		private var receiverId:int;
		private var message:String;
		private var unread:Boolean;
		private var deleted:Boolean;
		private var timeStamp:Number;
		
		public static const UPDATED:String = "textMessageUpdated"; 
		
		public function TextMessage():void {
			
		}
		public function getId():int {
			return this.id;
		}
		public function setId(newId:int):void {
			this.id = newId;
		}
		public function getSender():int {
			return this.senderId;
		}
		public function setSender(newSenderId:int):void {
			this.senderId = newSenderId;
		}
		public function getSenderName():String {
			return this.senderName;
		}
		public function setSenderName(newName:String):void {
			this.senderName = newName;
		}
		public function getReceiver():int {
			return this.receiverId;
		}
		public function setReceiver(newReceiverId:int):void {
			this.receiverId = newReceiverId;
		}
		public function getTextMessage():String {
			return this.message;
		}
		public function setTextMessage(newMessage:String):void {
			this.message = newMessage;
		}
		public function getUnread():Boolean {
			return this.unread;
		}
		public function setUnread(unread:Boolean):void {
			this.unread = unread;
			this.dispatchEvent(new Event(UPDATED));
		}
		public function getDeleted():Boolean {
			return this.deleted;
		}
		public function setDeleted(deleted:Boolean):void {
			this.deleted = deleted;
			this.dispatchEvent(new Event(UPDATED));
		}
		public function getTimeStamp():Number{
			return this.timeStamp;
		}
		public function setTimeStamp(timeStamp:Number):void {
			this.timeStamp = timeStamp;
		}
	}
}
