package uk.ac.sussex.model.valueObjects.requestParams {
	import uk.ac.sussex.model.valueObjects.CallHistoryItem;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArray;

	/**
	 * @author em97
	 */
	public class DataParamArrayCallHistory extends DataParamArray {
		public function DataParamArrayCallHistory(paramName : String) {
			super(paramName);
		}
		
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var sfsArray:SFSArray = existingObject.getSFSArray(this.getParamName()) as SFSArray;
			if(sfsArray != null){
				var sfsSize:int = sfsArray.size();
				var myValue:Array = new Array();
				
				for (var i:int = 0; i < sfsSize; i++) {
					var callHistory:CallHistoryItem = new CallHistoryItem();
					var callHistorySFSObj:SFSObject = sfsArray.getSFSObject(i) as SFSObject;
					callHistory = DataParamCallHistory.translateFromSFStoClass(callHistorySFSObj);
					
					myValue.push(callHistory);
				}
			}
			this.setParamValue(myValue);
			return existingObject;
		}
	}
}
