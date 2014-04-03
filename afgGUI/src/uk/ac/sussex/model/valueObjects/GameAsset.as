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
	public class GameAsset {
		private var id:int;
		private var name:String;
		private var measurement:String;
		private var edible:Boolean;
		private var type:String;
		private var subtype:String;
		private var notes:String;
		
		public static const TYPE_FERTILISER:String = "FERTILISER";
		public static const TYPE_CROP:String = "CROP";
		public static const TYPE_FOOD:String = "FOOD";
		public static const TYPE_HERBICIDE:String = "HERBICIDE";
		public static const TYPE_INSECTICIDE:String = "INSECTICIDE";
		public static const TYPE_CASH:String = "CASH";
		public static const SUBTYPE_ORGANIC:String = "ORGANIC";
		public static const SUBTYPE_INORGANIC:String = "INORGANIC";
		public static const SUBTYPE_MAIZE:String = "MAIZE";
		
		public function GameAsset(){	
		}
		public function getId():int {
			return id;
		}
		public function setId(newId:int):void {
			this.id = newId;
		}
		public function getName():String {
			return name;
		}
		public function setName(newName:String):void {
			this.name = newName;
		}
		public function getMeasurement():String {
			return measurement;
		}
		public function setMeasurement(newMeasurement:String):void{
			this.measurement = newMeasurement;
		}
		public function getEdible():Boolean {
			return edible;
		}
		public function setEdible(newEdible:Boolean):void {
			edible = newEdible;
		}
		public function getType():String {
			return type;
		}
		public function setType(newType:String):void {
			this.type = newType;
		}
		public function getSubtype():String {
			return subtype;
		}
		public function setSubtype(newSubtype:String):void {
			this.subtype = newSubtype;
		}
		public function getNotes():String {
			return notes;
		}
		public function setNotes(newNotes:String):void{
			this.notes = newNotes;
		}
	}
}
