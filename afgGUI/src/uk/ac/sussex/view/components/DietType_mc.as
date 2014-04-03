/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import uk.ac.sussex.model.valueObjects.Diet;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class DietType_mc extends MovieClip {
		public function DietType_mc() {
		}
		public function setDietType(dietType:int):void{
			switch (dietType) {
				case Diet.DIET_TARGET_MALE:
					this.gotoAndStop(1);
					break;
				case Diet.DIET_TARGET_FEMALE:
					this.gotoAndStop(2);
					break;
				case Diet.DIET_TARGET_CHILD:
					this.gotoAndStop(3);
					break;
				case Diet.DIET_TARGET_BABY:
					this.gotoAndStop(4);
					break;
				default:
					trace("DietIcons sez: Error in Diet.setDietType method");;
					break;
			}
		}
	}
}
