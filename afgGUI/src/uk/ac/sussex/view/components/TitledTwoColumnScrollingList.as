/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.text.*;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class TitledTwoColumnScrollingList extends MovieClip {
		private var listName:GenericFieldLabel;
		private var listObject:ScrollingTwoColList;
		
		private static const WIDGET_WIDTH:uint = 175;
		private static const TITLE_HEIGHT:uint = 30;
		private static const LIST_HEIGHT:uint = 250;
		
		public function TitledTwoColumnScrollingList() {
			setupLabel();
			setupList();
		}
		public function setTitleLabel(newLabel:String):void {
			listName.setText(newLabel);
		}
		public function addItem(newItem:ListItem):void {
			listObject.addItem(newItem);
		}
		public function getSelectedListItem():ListItem {
			var currentId:String = listObject.getCurrentValue();
			if(currentId!=null){
				var currentListItem:ListItem = listObject.getItemWithID(currentId) as ListItem;
				return currentListItem;
			}
			return null;
		}
		public function setListItemsSelectable(selectable:Boolean):void{
			listObject.setListItemsSelectable(selectable);
		}
		public function clearList():void {
			listObject.clearList();
		}
		public function removeItem(itemId:String):void {
			listObject.removeItem(itemId);
		}
		public function setSelectedItem(item:ListItem):void{
			if(item == null){
				listObject.clearCurrentSelection();
			} else {
				listObject.setCurrentSelection(item); 
			}
		}
		public function destroy():void {
			listObject.destroy();
		}
		private function setupLabel():void {
			var tFormat:TextFormat = new TextFormat();
			tFormat.font = "Calibri";
			tFormat.size = 20;
			tFormat.bold = false;
			tFormat.align = TextFormatAlign.CENTER;
			
			listName = new GenericFieldLabel();	
			listName.width = WIDGET_WIDTH-1;
			listName.height = TITLE_HEIGHT;
				
			this.addChild(listName);
		}
		private function setupList():void{
			listObject = new ScrollingTwoColList(WIDGET_WIDTH, LIST_HEIGHT);
			listObject.y = TITLE_HEIGHT;
			listObject.setBackgroundColour(0xF4EFA4);
			listObject.showBackgroundFilter(false);
			listObject.setInitialYPos(0);
			listObject.setBorderColour(0x09063A);
			this.addChild(listObject);
		}
	}
}
