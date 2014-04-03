/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.display.MovieClip;
	import uk.ac.sussex.view.components.ListItem;

	/**
	 * @author em97
	 */
	public class SeparatorListItem extends ListItem {
		private var separator:SeparatorMC;
		private var background:MovieClip;
		public function SeparatorListItem() {
			super();
			setup();
			this.enabled = false;
		}
		override public function set width(newWidth:Number):void {
			var newX:Number = (newWidth - separator.width)/2;
			background.width = newWidth;
			separator.x = newX;
		}
		override public function set height(newHeight:Number):void {
			var newY:Number = (newHeight - separator.height)/2;
			trace("SeparatorListItem sez: A new Height of " + newHeight + " is given a y pos of " + newY);
			background.height = newHeight;
			this.addChild(background);
			separator.y = newY;
			this.addChild(separator);
			trace("SeparatorListItem: my height is now " + this.height);
		}
		private function setup():void {
			background = new MovieClip();
			background.graphics.beginFill(0, 0);
			background.graphics.drawRect(0, 0, 100, 20);
			background.graphics.endFill();
			separator = new SeparatorMC();
			separator.x = (background.width - separator.width)/2;
			separator.y = (background.height - separator.height)/2;
			this.addChild(separator);
		}
	}
}
