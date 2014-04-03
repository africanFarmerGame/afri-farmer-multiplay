/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.text.*;

	/**
	 * @author em97
	 */
	public class MouseoverTextField extends TextField {
		
		public function MouseoverTextField() {
			var mouseOverFormatN:TextFormat = new TextFormat();
			var mouseOverFormatBold:TextFormat = new TextFormat();	
		
			mouseOverFormatN.size = 11;
			mouseOverFormatN.leftMargin = 0;
			mouseOverFormatN.font = "Calibri";
			mouseOverFormatBold.bold = true;
		
			this.defaultTextFormat = mouseOverFormatN;	
			this.background = true;
			this.backgroundColor = 0xF6FA7A;
			this.border = true;
			this.borderColor = 0x000000;
			this.wordWrap = false;
			this.selectable = false;
			this.autoSize = TextFieldAutoSize.LEFT;
		}
		public function addToScreen(trigger:DisplayObject, newx:int, newy:int):void {
			var myPos:Point = trigger.localToGlobal(new Point(newx, newy));
			this.x = myPos.x;
			this.y = myPos.y;
			trigger.stage.addChild(this);
		}
		public function removeFromScreen():void {
			if(this.parent != null){
				this.parent.removeChild(this);
			}
		}
	}
}
