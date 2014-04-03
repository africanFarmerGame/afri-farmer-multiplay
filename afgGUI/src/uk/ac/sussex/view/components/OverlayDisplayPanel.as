/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.display.Sprite;
	import flash.events.*;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class OverlayDisplayPanel extends MovieClip {
		public static const CLOSE_ME:String = "CloseMePlease";
		
		private var displayStage:Sprite;
		private var winBorder:Sprite;
		private var dismissBtn:DismissBtn;
		
		public function OverlayDisplayPanel() {
			/**backgroundPanel = new OverlayDisplayPanelMC();
			backgroundPanel.closeButton.addEventListener(MouseEvent.CLICK, closeButtonClicked);
			this.addChild(backgroundPanel);
			displayStage = new MovieClip();
			displayStage.graphics.clear();
			displayStage.graphics.beginFill(0xffffff, 0);
			displayStage.graphics.drawRect(0, 0, backgroundPanel.width  - 2*DISPLAY_MARGIN, backgroundPanel.height - 2* DISPLAY_MARGIN);
			displayStage.graphics.endFill();
			displayStage.x = DISPLAY_MARGIN;
			displayStage.y = DISPLAY_MARGIN;
			this.addChild(displayStage);
			*/
			winBorder = new Sprite();
			displayStage = new Sprite();
			dismissBtn = new DismissBtn();
		}
		public function resizeMe(newWidth:Number, newHeight:Number):void {
			winBorder.graphics.clear();
			winBorder.graphics.lineStyle(1, 0x000000);
			winBorder.graphics.beginFill(0xA2BE29);
			winBorder.graphics.drawRect(0, 0, newWidth, newHeight);
			winBorder.graphics.endFill();
			winBorder.alpha = 1;
			
			dismissBtn.x = newWidth - dismissBtn.width - 4;
			dismissBtn.y = 2;
			dismissBtn.addEventListener(MouseEvent.CLICK, closeButtonClicked, false, 0, true);
			
			displayStage.graphics.clear();
			displayStage.graphics.lineStyle(1, 0x000000);
			displayStage.graphics.beginFill(0xffffff);
			displayStage.graphics.drawRect(0, 0, newWidth -8, newHeight -28);
			displayStage.graphics.endFill();
			displayStage.x = 4;
			displayStage.y = 24;
			
			this.addChild(winBorder);
			this.addChild(dismissBtn);
			this.addChild(displayStage);
		}
		public function resizeForThing(thingWidth:Number, thingHeight:Number):void {
			var newWidth:Number = thingWidth+8;
			var newHeight:Number = thingHeight+28;
			this.resizeMe(newWidth, newHeight);
		}
		public function getDisplayWidth():Number {
			//return backgroundPanel.width  - 2*DISPLAY_MARGIN;
			return displayStage.width;
		}
		public function getDisplayHeight():Number {
			//return backgroundPanel.height - 2* DISPLAY_MARGIN;
			return displayStage.height;
		}
		public function addToDisplay(thing:Sprite):void{
			displayStage.addChild(thing);
			trace("OverlayDisplayPanel sez: My background width is now " + this.width);
			trace("OverlayDisplayPanel sez: My background height is now " + this.height);
		}
		public function clearMe():void {
			var numObjects:int = displayStage.numChildren -1;
			for (var childNum:int = numObjects; childNum >=0; childNum--){
				displayStage.removeChildAt(childNum);
			}
		}
		private function closeButtonClicked(e:MouseEvent):void{
			dispatchEvent(new Event(CLOSE_ME));
		}
		
	}
}
