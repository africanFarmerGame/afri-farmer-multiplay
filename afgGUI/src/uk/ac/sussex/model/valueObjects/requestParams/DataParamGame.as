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
