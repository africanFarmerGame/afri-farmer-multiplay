/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class CallHistory {
		private var incomingCalls:Array;
		private var outgoingCalls:Array;
		public function getIncomingCalls():Array {
			return incomingCalls;
		}
		public function setIncomingCalls(incomingCalls:Array):void {
			this.incomingCalls = incomingCalls;
		}
		public function getOutgoingCalls():Array {
			return outgoingCalls;
		}
		public function setOutgoingCalls(outgoingCalls:Array):void{
			this.outgoingCalls = outgoingCalls;
		}
		public function getAllCalls():Array{
			var allCalls:Array = incomingCalls.concat(outgoingCalls);
			allCalls.sort(sortOnStartTime);
			return allCalls;
		}
		private function sortOnStartTime(a:CallHistoryItem, b:CallHistoryItem):Number {
    		var aStarted:Number = a.getStarted();
    		var bStarted:Number = b.getStarted();

    		if(aStarted > bStarted) {
        		return 1;
    		} else if(aStarted < bStarted) {
        		return -1;
   	 		} else  {
        		return 0;
		    }
		}
	}
}
