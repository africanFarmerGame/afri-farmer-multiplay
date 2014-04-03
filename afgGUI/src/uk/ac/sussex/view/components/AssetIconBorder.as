/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class AssetIconBorder extends MovieClip {
		private var assetIcon:AssetIcon;
		public function AssetIconBorder() {
			super();
			this.graphics.lineStyle(3, 0, 1);
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(0, 0, 200, 200);
			this.graphics.endFill();
			assetIcon = new AssetIcon();
			this.addChild(assetIcon);
		}
		public function setType(type:String, name:String):void {
			assetIcon.setType(type, name);
		}
	}
}
