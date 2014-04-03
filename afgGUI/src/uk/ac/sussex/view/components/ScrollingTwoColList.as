/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	
	/**
	 * @author em97
	 */
	public class ScrollingTwoColList extends ScrollingList {
		public function ScrollingTwoColList(totalWidth : Number, maskHeight : Number) {
			super(totalWidth, maskHeight);
		}
		public function setInitialYPos(newInitialYPos:Number):void {
			this.initialYPos = newInitialYPos;
			if(this.allListItems.length == 0){
				this.nextYPos = initialYPos;
			}
		}
		override public function addItem(newItem:ListItem):void {
			//I need to calculate the offset to centre the items. I think I'm going to assume matching width items.
			if (this.allListItems.length == 0){
				this.initialXPos = 0.5*this.maskWidth - newItem.width;
				this.nextXPos = this.initialXPos;
			}
			super.addItem(newItem);
		}
		override protected function calculateNextItemPos(newItem:ListItem, itemPos:int):void {
			var x_offset:Number = 0.5*this.maskWidth - newItem.width;
			var remainder:int = (itemPos+ 1) % 2;
			
			nextYPos = nextYPos + (remainder) * newItem.height;
			nextXPos = x_offset - (remainder - 1) * newItem.width; 			
		}
	}
}
