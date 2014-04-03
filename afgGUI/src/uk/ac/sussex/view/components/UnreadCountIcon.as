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
	public class UnreadCountIcon extends MovieClip {
		private var displayCount:TextField;
		public function UnreadCountIcon() {
			this.graphics.beginFill(0xDD0000, 1);
			this.graphics.drawCircle(0, 0, 9.5);
			this.graphics.endFill();
			
			var tf:TextFormat = new TextFormat();
			tf.font = "Arial";
			tf.align = TextFormatAlign.CENTER;
			tf.color = 0xFFFFFF;
			tf.size = 12;
			tf.bold = true;
			displayCount = new TextField();
			displayCount.defaultTextFormat = tf;
			displayCount.selectable = false;
			displayCount.width = 18;
			displayCount.height = 18;
			displayCount.x = -9;
			displayCount.y = -8.5;
			this.addChild(displayCount);
		}
		public function setUnread(unreadCount:uint):void {
			this.displayCount.text = unreadCount.toString();
		}
	}
}
