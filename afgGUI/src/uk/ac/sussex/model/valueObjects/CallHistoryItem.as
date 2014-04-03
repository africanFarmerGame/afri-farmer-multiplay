/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
