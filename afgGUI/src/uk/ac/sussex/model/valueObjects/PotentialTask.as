/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class PotentialTask {
		private var name:String;
		private var locations:Array;
		private var actors:Array;
		private var assets:Array;
		private var type:String;
		public function PotentialTask(){
			
		}
		public function getName():String {
			return name;
		}
		public function setName(newName:String):void {
			this.name = newName;
		}
		public function getLocations():Array {
			return this.locations;
		}
		public function setLocations(newLocations:Array):void {
			this.locations = newLocations.sort(sortOptions);
		}
		public function getActors():Array {
			return this.actors;
		}
		public function setActors(newActors:Array):void {
			this.actors = newActors.sort(sortOptions);
		}
		public function getAssets():Array {
			return this.assets;
		}
		public function setAssets(newAssets:Array):void {
			this.assets = newAssets.sort(sortOptions);
		}
		public function getType():String {
			return type;
		}
		public function setType(newType:String):void {
			this.type = newType;
		}
		private function sortOptions(a:FormFieldOption, b:FormFieldOption):int{
			var aName:String = a.getDisplayName();
			var bName:String = b.getDisplayName();
			if(aName>bName){
				return 1;
			} else if (aName<bName){
				return -1;
			} else {
				return 0;
			}
		}
	}
}
