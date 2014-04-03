/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class Hearth {
		private var id:int;
		private var hearthName:String;
		private var houseNumber:int;
		private var numFields:int;
		private var numAdults:int;
		private var numChildren:int;
		
		public function Hearth(){
			
		}
		public function getId():int {
			return id;
		}
		public function setId(newId:int):void {
			this.id = newId;
		}
		public function getHearthName():String {
			return this.hearthName;
		}
		public function setHearthName(newHearthName:String):void {
			this.hearthName = newHearthName;
		}
		public function getHouseNumber():int {
			return this.houseNumber;
		}
		public function setHouseNumber(newNumber:int):void {
			this.houseNumber = newNumber;
		}
		public function getNumFields():int {
			return this.numFields;
		}
		public function setNumFields(numFields:int):void {
			this.numFields = numFields;
		}
		public function getNumAdults():int {
			return this.numAdults;
		}
		public function setNumAdults(numAdults:int):void {
			this.numAdults = numAdults;
		}
		public function getNumChildren():int {
			return this.numChildren;
		}
		public function setNumChildren(numChildren:int):void {
			this.numChildren = numChildren;
		}
	}
}
