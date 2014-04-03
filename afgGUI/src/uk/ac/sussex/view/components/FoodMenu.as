/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class FoodMenu extends MovieClip {
		private var submenu:SubMenu;
		private var dietsList:InStockAssetList;
		
		private static const MAX_WIDTH:Number = 800;
		private static const BORDER:Number = 10;
		
		public function FoodMenu() {
			setupSubMenu();
			setupDietsList();
		}
		private function setupSubMenu():void{
			submenu = new SubMenu();
			submenu.addButton("Diet");
			submenu.addButton("Allocation");
			submenu.addButton("Select");
			submenu.addButton("Exit");
			submenu.x = BORDER;
			submenu.y = BORDER;
			this.addChild(submenu);
		}
		private function setupDietsList():void {
			dietsList = new InStockAssetList();
			dietsList.setTitleLabel("Diets & Allocations");
			dietsList.x = MAX_WIDTH - dietsList.width - BORDER;
			dietsList.y = BORDER;
			this.addChild(dietsList);
		}
	}
}
