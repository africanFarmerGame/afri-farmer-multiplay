/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class FormFieldOption {
		private var displayName:String;
		private var outputValue:String;
		private var type:String;
		private var status:int;
		private var notes:String;
		
		public static var VALID:int = 0;
		public static var INVALID:int = -1;
		
		public function FormFieldOption(displayName:String, outputValue:String){
			this.displayName = displayName;
			this.outputValue = outputValue;
		}
		public function getOutputValue():String {
			return this.outputValue;
		}
		public function getDisplayName():String {
			return this.displayName;
		}
		public function getType():String {
			return type;
		}
		public function setType(newType:String):void {
			this.type = newType;
		}
		public function getStatus():int {
			return status;
		}
		public function setStatus(newStatus:int):void {
			this.status = newStatus;
		}
		public function getNotes():String {
			return notes;
		}
		public function setNotes(newNotes:String):void {
			this.notes = newNotes;
		}
	}
}
