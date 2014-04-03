/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class Allocation {
		private var id:int;
		private var name:String;
		private var hearthid:int;
		private var selected:Boolean;
		private var allocationDiets:Array;
		public function getId():int {
			return this.id;
		}
		public function setId(newId:int):void {
			this.id = newId;
		}
		public function getName():String {
			return this.name;
		}
		public function setName(newName:String):void {
			this.name = newName;
		}
		public function getHearthid():int {
			return this.hearthid;
		}
		public function setHearthid(newHearthid:int):void {
			this.hearthid = newHearthid;
		}
		public function getSelected():Boolean {
			return this.selected;
		}
		public function setSelected(selected:Boolean):void {
			this.selected = selected;
		}
		public function getAllocationDiets():Array {
			return this.allocationDiets;
		}
		public function setAllocationDiets(newDiets:Array):void {
			this.allocationDiets = new Array();
			for each (var diet:Diet in newDiets){
				this.allocationDiets.push(diet);
			}
		}
		public function getAllocationDiet(dietId:int):Diet {
			for each(var diet:Diet in this.allocationDiets){
				if(diet.getId() == dietId){
					return diet;
				}
			}
			return null;
		}
		public function getCopy():Allocation{
			var alloc:Allocation = new Allocation();
			alloc.setId(this.getId());
			alloc.setName(this.getName());
			alloc.setHearthid(this.getHearthid());
			alloc.setSelected(this.getSelected());
			var copyDiets:Array = new Array();
			var currentDiets:Array = this.getAllocationDiets();
			for each (var diet:Diet in currentDiets){
				var newDiet:Diet = diet.getCopy();
				copyDiets.push(newDiet);
			}
			alloc.setAllocationDiets(copyDiets);
			return alloc;
		}
		public function addDiet(newDiet:Diet):void {
			this.allocationDiets.push(newDiet);
		}
	}
}