/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
