/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.text.TextField;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class GameTextPanel extends MovieClip {
		var panel:TextField;
		
		public function GameTextPanel() {
			panel = new TextField;
			panel.wordWrap = true;
			panel.border = true;
			this.addChild(panel);
		}
		public function setText(text:String):void {
			panel.text = text;
		}
		public function setWidth(newWidth:Number):void {
			trace("GameTextPanel sez: I'm trying to set the width to " + newWidth);
			panel.width = newWidth;
			trace("GameTextPanel sez: I've managed to set the width to " + panel.width);
		}
	}
}
