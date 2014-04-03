package uk.ac.sussex.model.valueObjects.requestParams {
	import uk.ac.sussex.model.valueObjects.PlayerChar;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import com.smartfoxserver.v2.entities.data.SFSObject;

	/**
	 * @author em97
	 */
	public class DataParamArrayPlayerChar extends DataParamArray {
		public function DataParamArrayPlayerChar(paramName : String) {
			super(paramName);
		}
		override public function addToServerParam(existingObject:SFSObject):SFSObject {
			//I don't think I'm going to need to send lots back. I might be wrong. 
			throw new Error("This hasn't been implemented.");
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var sfsArray:SFSArray = existingObject.getSFSArray(this.getParamName()) as SFSArray;
			if(sfsArray != null){
				var sfsSize:int = sfsArray.size();
				var myValue:Array = new Array();
				
				for (var i:int = 0; i < sfsSize; i++) {
					var playerSFSObj:SFSObject = sfsArray.getSFSObject(i) as SFSObject;
					var playerChar:PlayerChar = DataParamPlayerChar.translateFromSFStoClass(playerSFSObj);
					
					myValue.push(playerChar);
				}
			}
			this.setParamValue(myValue);
			return existingObject;
		}
	}
}
