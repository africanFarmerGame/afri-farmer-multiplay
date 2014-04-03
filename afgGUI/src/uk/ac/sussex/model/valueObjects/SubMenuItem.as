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
	public class SubMenuItem {
		private var buttonOrder:int;
		private var displayName:String;
		private var menuDefault:Boolean;
		private var displayStages:Array;
		
		public function SubMenuItem(buttonOrder:int, displayName:String, displayStages:Array = null){
			this.buttonOrder = buttonOrder;
			this.displayName = displayName;
			this.displayStages = displayStages;
			this.menuDefault = false;
		}
		public function getButtonOrder():int {
			return this.buttonOrder;
		}
		public function getDisplayName():String {
			return this.displayName;
		}
		public function displayThisButton(stageName:String):Boolean{
			stageName = stageName.toUpperCase();
			if(this.displayStages==null){
				return true;
			} else {
				for each (var displayStage:String in displayStages){
					if(stageName.search(displayStage)>=0){
						return true;
					}
				}
			}
			return false;
		}
		public function getMenuDefault():Boolean {
			 return this.menuDefault;
		}
		public function setMenuDefault(isDefault:Boolean):void {
			this.menuDefault = isDefault;
		}
	}
}
