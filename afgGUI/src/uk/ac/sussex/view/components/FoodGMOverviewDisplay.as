/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import uk.ac.sussex.model.valueObjects.GMHouseholdData;
	import uk.ac.sussex.model.valueObjects.Hearth;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import flash.text.TextFormat;
	import flash.display.Shape;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class FoodGMOverviewDisplay extends MovieClip {
		private var scrollingList:ScrollingList;
		
		public function FoodGMOverviewDisplay() {
			setup();
		}
		public function clearList():void {
			scrollingList.clearList();
		}
		public function addHearthDetail(hearth:Hearth, householdData:GMHouseholdData):void {
			var foodItem:FoodGMOverviewListItem = new FoodGMOverviewListItem();
			foodItem.setDetails(hearth, householdData);
			scrollingList.addItem(foodItem);
		}
		public function clearSelection():void {
			scrollingList.clearCurrentSelection();
		}
		private function setup():void {
			setupTitleBar();
			
			scrollingList = new ScrollingList(620, 270);
			scrollingList.x = 0;
			scrollingList.y = 25; 
			scrollingList.setListItemsSelectable(false);
			scrollingList.showBackgroundFilter(false);
			scrollingList.setBorderColour(0x09063A);
			
			this.addChild(scrollingList);
		}
		private function setupTitleBar():void {
			var titleBar:Shape = new Shape();
			titleBar.graphics.lineStyle(1,0x000000);
			titleBar.graphics.beginFill(0xF49160); 
			titleBar.graphics.drawRect(0,0,607,25);
			titleBar.graphics.endFill();	
			this.addChild(titleBar);
			var tFormat:TextFormat = new TextFormat();
			tFormat.font = "Calibri";
			tFormat.size = 17;
			tFormat.bold = false;
			tFormat.align = TextFormatAlign.CENTER;	
			
			var headers:Array = FoodGMOverviewListItem.getColumnHeaders();
			
			for each (var header:Array in headers){
				var text:TextField = new TextField();
				text.defaultTextFormat = tFormat;
				text.textColor = 0x000000;
				text.background = false;
				text.border = false;
				text.borderColor = 0x000000;
				text.selectable = false;
				text.x = header.pop();
				text.width = header.pop();
				text.text = header.pop();
				text.height = 25;
				text.y = 0;
				this.addChild(text);
			}
		}
	}
}
