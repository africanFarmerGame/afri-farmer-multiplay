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
	public class DietTargetLevelDisplay extends MovieClip {
		private var dietType:DietType_mc;
		private var dietLevel:DietLevel_mc;
		public function DietTargetLevelDisplay() {
			dietLevel = new DietLevel_mc();
			var scaleLevel:Number = 45/dietLevel.height;
			dietLevel.scaleX = scaleLevel;
			dietLevel.scaleY = scaleLevel;
			dietLevel.x = 0; 
			dietLevel.y = 0;
			this.addChild(dietLevel);
			
			dietType = new DietType_mc();
			var scaleType:Number = 45/dietType.height;
			dietType.scaleX = scaleType;
			dietType.scaleY = scaleType;
			dietType.x = 50;
			dietType.y = 0;
			this.addChild(dietType);
			
			this.reset();
		}
		public function setDietType(target:int):void {
			dietType.setDietType(target);
		}
		public function setDietLevel(level:String):void {
			trace("DietTargetLevelDisplay sez: I'm setting to level " + level);
			dietLevel.setDietLevel(level);
		}
		public function reset():void {
			//Need to be able to set them to blank. 
			dietLevel.setDietLevel("NONE");
			dietType.setDietType(0);
		}
	}
}
