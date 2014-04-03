/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class HouseholdStatus {
		private var householdId:int;
		private var householdName:String;
		private var housenumber:int;
		private var viewStatuses:Array;
		
		public function getHouseholdId():int {
			return householdId;
		}
		public function setHouseholdId(newId:int):void {
			this.householdId = newId;
		}
		public function getViewStatuses():Array {
			return this.viewStatuses;
		}
		public function setViewStatuses(newStatuses:Array):void {
			this.viewStatuses = newStatuses;
		}
		public function getViewStatus(viewName:String):ViewStatus {
			for each (var viewStatus:ViewStatus in viewStatuses){
				if(viewStatus.getViewName()==viewName){
					return viewStatus;
				}
			}
			return null;
		}
		public function getHouseholdName():String {
			return householdName;
		}
		public function setHouseholdName(newName:String):void {
			householdName = newName;
		}
		public function getHousenumber():int {
			return housenumber;
		}
		public function setHousenumber(newNumber:int):void {
			this.housenumber = newNumber;
		}
	}
}
