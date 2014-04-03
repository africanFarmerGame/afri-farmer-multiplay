/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class FoodAllocationSelection extends MovieClip {
		private var tableTop:TableTopDisplay;
		private var dietAllocationList:DietAllocationList;
		
		private static const TABLE_SCREEN_X:Number = 0;
		private static const TABLE_SCREEN_Y:Number = 43;
		
		public function FoodAllocationSelection() {
			setup();
		}
		private function setup():void {
			tableTop = new TableTopDisplay();
			tableTop.x =  TABLE_SCREEN_X;
			tableTop.y = TABLE_SCREEN_Y;
			
			dietAllocationList = new DietAllocationList();
			dietAllocationList.setTitle("Diets & Allocations");
			dietAllocationList.x = tableTop.x + tableTop.width + 40;
			
			this.addChild(tableTop);
			this.addChild(dietAllocationList);
		}
	}
}
