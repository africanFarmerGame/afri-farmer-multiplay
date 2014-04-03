/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model {
	import flash.events.Event;
	import uk.ac.sussex.model.valueObjects.Message;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.interfaces.IProxy;

	/**
	 * @author em97
	 */
	public class MessageListProxy extends Proxy implements IProxy {
		public static const NAME:String = "MessageListProxy";
		public static const MESSAGE_UPDATED:String = "MessageUpdated";
		public static const MESSAGE_LIST_UPDATED:String = "MessageListUpdated";
		
		public function MessageListProxy() {
			super(NAME, new Array());
		}
		public function addMessages(newMessages:Array):void {
			for each (var text:Message in newMessages){
				messages.push(text);
				text.addEventListener(Message.UPDATED, messageUpdated);
			}
			sendNotification(MESSAGE_LIST_UPDATED);
		}
		public function getUnreadCount():uint{
			var unread:uint = 0;
			for each (var message:Message in messages){
				if(message.getUnread()){
					unread++;
				}
			}
			return unread;
		}
		public function getMessages():Array {
			return messages.sort(sortTimeStamp);
		}
		public function getMessageById(messageId:int):Message {
			for each(var message:Message in messages){
				if(message.getId()==messageId){
					return message;
				}
			}
			return null;
		}
		private function messageUpdated(e:Event):void {
			var tm:Message = e.target as Message;
			sendNotification(MESSAGE_UPDATED, tm);
		}
		private function sortTimeStamp(a:Message, b:Message):int{
			var aTimeStamp:Number = a.getTimestamp();
			var bTimeStamp:Number = b.getTimestamp();
			if(aTimeStamp>bTimeStamp){
				return 1;
			} else if (aTimeStamp<bTimeStamp){
				return -1;
			} else {
				return 0;
			}
			
		}
		protected function get messages():Array {
			return data as Array;
		}
	}
}
