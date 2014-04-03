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
	public class DietaryRequirement {
		private var type:int;
		private var level:String;
		private var protein:int;
		private var carbs:int;
		private var nutrients:int;
		
		public function getType():int {
			return type;
		}
		public function setType(newType:int):void {
			this.type = newType;
		}
		public function getLevel():String {
			return level;
		}
		public function setLevel(newLevel:String):void {
			this.level = newLevel;
		}
		public function getProtein():int {
			return protein;
		}
		public function setProtein(newProtein:int):void {
			this.protein = newProtein;
		}
		public function getCarbs():int {
			return carbs;
		}
		public function setCarbs(newCarbs:int):void {
			this.carbs = newCarbs;
		}
		public function getNutrients():int {
			return this.nutrients;
		}
		public function setNutrients(newNutrients:int):void {
			this.nutrients = newNutrients;
		}
	}
}
