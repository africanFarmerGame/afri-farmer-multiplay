/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import uk.ac.sussex.model.valueObjects.Fine;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class FinesDisplay extends MovieClip {
		private var scrollingList:ScrollingList;
		
		public function FinesDisplay() {
			setup();
		}
		public function displayFines(finesArray:Array):void {
			scrollingList.clearList();
			for each (var fine:Fine in finesArray) {
				var fineItem:FinesListItem = new FinesListItem();
				fineItem.setFine(fine);
				scrollingList.addItem(fineItem);
			}
		}
		public function getSelectedFineId():String{
			var selectedId:String = scrollingList.getCurrentValue();
			return selectedId;
		}
		public function clearSelection():void {
			scrollingList.clearCurrentSelection();
		}
		private function setup():void {
			scrollingList = new ScrollingList(620, 264);
			scrollingList.x = 0;
			scrollingList.y = 0; 
			scrollingList.showBackgroundFilter(false);
			scrollingList.setBorderColour(0x09063A); 
			this.addChild(scrollingList);
		}
	}
}
