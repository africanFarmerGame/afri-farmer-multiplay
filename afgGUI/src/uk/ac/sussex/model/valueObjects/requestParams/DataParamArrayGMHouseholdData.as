package uk.ac.sussex.model.valueObjects.requestParams {
	import uk.ac.sussex.model.valueObjects.GMHouseholdData;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArray;

	/**
	 * @author em97
	 */
	public class DataParamArrayGMHouseholdData extends DataParamArray {
		public function DataParamArrayGMHouseholdData(paramName : String) {
			super(paramName);
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var sfsArray:SFSArray = existingObject.getSFSArray(this.getParamName()) as SFSArray;
			if(sfsArray != null){
				var sfsSize:int = sfsArray.size();
				var myValue:Array = new Array();
				
				for (var i:int = 0; i < sfsSize; i++) {
					var fsSFSObj:SFSObject = sfsArray.getSFSObject(i) as SFSObject;
					var fsItem:GMHouseholdData = DataParamGMHouseholdData.translateFromSFStoClass(fsSFSObj);					
					myValue.push(fsItem);
				}
			}
			this.setParamValue(myValue);
			return existingObject;			
		}
	}
}
