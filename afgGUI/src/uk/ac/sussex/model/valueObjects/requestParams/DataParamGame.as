/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects.requestParams {
	import uk.ac.sussex.model.valueObjects.Game;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParam;

	/**
	 * @author em97
	 */
	public class DataParamGame extends DataParam {
		public static const GAME_ID:String = "Id";
		public static const GAME_NAME:String = "Name";
		public function DataParamGame(paramName : String) {
			super(paramName);
		}
		override public function getParamValue() {
			var value:Game = this.paramValue as Game;
			return value;
		}
		override public function setParamValue(paramValue) {
			var value:Game = paramValue as Game;
			this.paramValue = value;
		}
		override public function addToServerParam(existingObject:SFSObject):SFSObject {
			var game:Game = this.getParamValue() as Game;
			var gameObj:SFSObject = SFSObject.newInstance();
			gameObj.putInt(GAME_ID, game.getId());
			gameObj.putUtfString(GAME_NAME, game.getName());
			existingObject.putSFSObject(this.getParamValue(), gameObj);
			return existingObject;
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var object:SFSObject = existingObject.getSFSObject(this.getParamName()) as SFSObject;
			var game:Game = DataParamGame.translateFromSFStoClass(object);
			this.setParamValue(game);
			return existingObject;
		}
		public static function translateFromSFStoClass(object:SFSObject):Game{
			var game:Game = new Game();
			game.setId(object.getInt(GAME_ID));
			game.setName(object.getUtfString(GAME_NAME));
			return game;
		}
	}
}
