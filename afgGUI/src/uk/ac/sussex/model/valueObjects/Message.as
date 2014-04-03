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
	public class Message extends EventDispatcher {
		private var id:int;
		private var recipientId:int;
		private var subject:String;
		private var body:String;
		private var unread:Boolean;
		private var deleted:Boolean;
		private var timestamp:Number;
		
		public static const UPDATED:String = "messageUpdated";
		
		public function Message():void {
			
		}
		public function getId():int {
			return id;
		}
		public function setId(newId:int):void {
			this.id = newId;
		}
		public function getRecipientId():int {
			return recipientId;
		}
		public function setRecipientId(recipientId:int):void {
			this.recipientId = recipientId;
		}
		public function getSubject():String {
			return subject;
		}
		public function setSubject(newSubject:String):void {
			this.subject = newSubject;
		}
		public function getBody():String {
			return body;
		}
		public function setBody(newBody:String):void {
			this.body = newBody;
		}
		public function getUnread():Boolean {
			return unread;
		}
		public function setUnread(unread:Boolean):void {
			this.unread = unread;
			this.dispatchEvent(new Event(UPDATED));
		}
		public function getDeleted():Boolean {
			return deleted;
		}
		public function setDeleted(deleted:Boolean):void {
			this.deleted = deleted;
			this.dispatchEvent(new Event(UPDATED));
		}
		public function getTimestamp():Number {
			return timestamp;
		}
		public function setTimestamp(newTime:Number):void {
			this.timestamp = newTime;
		}
	}
}
