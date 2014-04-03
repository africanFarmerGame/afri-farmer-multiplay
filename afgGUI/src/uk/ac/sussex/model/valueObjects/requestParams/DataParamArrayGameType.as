package uk.ac.sussex.model.valueObjects.requestParams {
	import uk.ac.sussex.model.valueObjects.GameType;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArray;

	/**
	 * @author em97
	 */
	public class DataParamArrayGameType extends DataParamArray {
		public function DataParamArrayGameType(paramName : String) {
			super(paramName);
		}
		override public function addToServerParam(existingObject:SFSObject):SFSObject {
			//I don't think I'm going to need to send lots back. I might be wrong. 
			throw new Error("Adding a GameType Array to a server param hasn't been implemented.");
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var sfsArray:SFSArray = existingObject.getSFSArray(this.getParamName()) as SFSArray;
			if(sfsArray != null){
				var sfsSize:int = sfsArray.size();
				var myValue:Array = new Array();
				
				for (var i:int = 0; i < sfsSize; i++) {
					var serverSFSObj:SFSObject = sfsArray.getSFSObject(i) as SFSObject;
					var gameType:GameType = DataParamGameType.translateFromSFStoClass(serverSFSObj);
					
					myValue.push(gameType);
				}
			}
			this.setParamValue(myValue);
			return existingObject;
		}
	}
}
