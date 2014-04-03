package uk.ac.sussex.model.valueObjects.requestParams {
	import uk.ac.sussex.model.valueObjects.GameType;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParam;

	/**
	 * @author em97
	 */
	public class DataParamGameType extends DataParam {
		public function DataParamGameType(paramName : String) {
			super(paramName);
		}
		override public function getParamValue() {
			var value:GameType = this.paramValue as GameType;
			return value;
		}
		override public function setParamValue(paramValue) {
			var value:GameType = GameType(paramValue);
			this.paramValue = value;
		}
		override public function addToServerParam(existingObject:SFSObject):SFSObject {
			throw new Error("Trying to add a Game Type to a server param, and that's not supported.");
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var serverObj:SFSObject = existingObject.getSFSObject(this.getParamName()) as SFSObject;
			var gameType:GameType = DataParamGameType.translateFromSFStoClass(serverObj);
			this.setParamValue(gameType);
			return existingObject;
		}
		public static function translateFromSFStoClass(serverObj:SFSObject):GameType{
			var gameType:GameType = new GameType();
			gameType.setGameType(serverObj.getUtfString("GameType"));
			gameType.setGameTypeDisplay(serverObj.getUtfString("GameTypeDisplay"));
			return gameType;
		}
	}
}
