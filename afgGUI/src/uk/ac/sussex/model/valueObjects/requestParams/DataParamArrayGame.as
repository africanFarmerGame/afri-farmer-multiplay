package uk.ac.sussex.model.valueObjects.requestParams {
	import uk.ac.sussex.model.valueObjects.Game;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArray;

	/**
	 * @author em97
	 */
	public class DataParamArrayGame extends DataParamArray {
		public function DataParamArrayGame(paramName : String) {
			super(paramName);
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var sfsArray:SFSArray = existingObject.getSFSArray(this.getParamName()) as SFSArray;
			if(sfsArray != null){
				var sfsSize:int = sfsArray.size();
				var myValue:Array = new Array();
				
				for (var i:int = 0; i < sfsSize; i++) {
					var game:Game = new Game();
					var sfsobject:SFSObject =  sfsArray.getSFSObject(i) as SFSObject;
					game = DataParamGame.translateFromSFStoClass(sfsobject);
					myValue.push(game);
				}
			}
			this.setParamValue(myValue);
			return existingObject;
			
		}
	}
}
