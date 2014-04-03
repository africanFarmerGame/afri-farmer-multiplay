package uk.ac.sussex.model.valueObjects.requestParams {
	import uk.ac.sussex.model.valueObjects.HouseholdStatus;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArray;

	/**
	 * @author em97
	 */
	public class DataParamArrayHouseholdStatus extends DataParamArray {
		public function DataParamArrayHouseholdStatus(paramName : String) {
			super(paramName);
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var sfsArray:SFSArray = existingObject.getSFSArray(this.getParamName()) as SFSArray;
			if(sfsArray != null){
				var sfsSize:int = sfsArray.size();
				var myValue:Array = new Array();
				
				for (var i:int = 0; i < sfsSize; i++) {
					var sfsObject:SFSObject = sfsArray.getSFSObject(i) as SFSObject;
					var household:HouseholdStatus = new HouseholdStatus();
					household.setHouseholdId(sfsObject.getInt("HearthId"));
					household.setHouseholdName(sfsObject.getUtfString("HearthName"));
					household.setHousenumber(sfsObject.getInt("HouseNumber"));
					var statusArray:SFSArray = sfsObject.getSFSArray("ViewDetails") as SFSArray;
					household.setViewStatuses(DataParamArrayViewStatus.translateToArray(statusArray));
					myValue.push(household);
				}
			}
			this.setParamValue(myValue);
			return existingObject;
		}
	}
}
