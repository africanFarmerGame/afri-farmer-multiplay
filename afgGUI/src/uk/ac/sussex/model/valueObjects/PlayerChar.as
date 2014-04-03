/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class PlayerChar extends AnyChar{
		
		private var onlineStatus:Boolean = false;
		private var currentLocation:String;
		private var fieldCount:int;
		
		public function getOnlineStatus():Boolean {
			return this.onlineStatus;
		}
		public function setOnlineStatus(online:Boolean):void {
			this.onlineStatus = online;
		}
		public function getCurrentLocation():String {
			return this.currentLocation;
		}
		public function setCurrentLocation(loc:String):void {
			this.currentLocation = loc;
		}
		public function getFieldCount():int{
			return fieldCount;
		}
		public function setFieldCount(newFieldCount:int):void {
			this.fieldCount = newFieldCount;
		}
	}
}
