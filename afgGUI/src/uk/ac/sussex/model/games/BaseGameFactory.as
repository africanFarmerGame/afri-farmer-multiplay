/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.games {
	/**
	 * @author em97
	 */
	public class BaseGameFactory {
	
		public function getBaseGame(gameType:String):BaseGame {
			switch(gameType){
				case CoreBaseGame.TYPE:
					return new CoreBaseGame();
				case AfriBaseGame.TYPE:
					return new AfriBaseGame();
				default:
					throw new Error (gameType + " is not a supported game type.");
			}
		}
	}
}
