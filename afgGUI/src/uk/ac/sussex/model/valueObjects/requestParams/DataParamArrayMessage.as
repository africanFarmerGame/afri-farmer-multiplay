package uk.ac.sussex.model.valueObjects.requestParams {
	
	import uk.ac.sussex.model.valueObjects.Message;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArray;

	/**
	 * @author em97
	 */
	public class DataParamArrayMessage extends DataParamArray {
		public function DataParamArrayMessage(paramName : String) {
			super(paramName);
		}
		override public function addToServerParam(existingObject:SFSObject):SFSObject {
			//I don't think I'm going to need to send lots back. I might be wrong. 
			throw new Error("DataParamArrayMessage sez: This hasn't been implemented.");
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var sfsArray:SFSArray = existingObject.getSFSArray(this.getParamName()) as SFSArray;
			if(sfsArray != null){
				var sfsSize:int = sfsArray.size();
				var myValue:Array = new Array();
				
				for (var i:int = 0; i < sfsSize; i++) {
					var tmSFSObj:SFSObject = sfsArray.getSFSObject(i) as SFSObject;
					var tmChar:Message = DataParamMessage.translateFromSFStoClass(tmSFSObj);
					
					myValue.push(tmChar);
				}
			}
			this.setParamValue(myValue);
			return existingObject;
		}
	}
}
