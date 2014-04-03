package uk.ac.sussex.model.valueObjects.requestParams {
	import uk.ac.sussex.model.valueObjects.FinancialStatus;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArray;

	/**
	 * @author em97
	 */
	public class DataParamArrayFinancialStatus extends DataParamArray {
		public function DataParamArrayFinancialStatus(paramName : String) {
			super(paramName);
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var sfsArray:SFSArray = existingObject.getSFSArray(this.getParamName()) as SFSArray;
			if(sfsArray != null){
				var sfsSize:int = sfsArray.size();
				var myValue:Array = new Array();
				
				for (var i:int = 0; i < sfsSize; i++) {
					var fsSFSObj:SFSObject = sfsArray.getSFSObject(i) as SFSObject;
					var fsItem:FinancialStatus = DataParamFinancialStatus.translateFromSFStoClass(fsSFSObj);					
					myValue.push(fsItem);
				}
			}
			this.setParamValue(myValue);
			return existingObject;			
		}
	}
}
