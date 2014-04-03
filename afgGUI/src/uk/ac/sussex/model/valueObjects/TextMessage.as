/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
