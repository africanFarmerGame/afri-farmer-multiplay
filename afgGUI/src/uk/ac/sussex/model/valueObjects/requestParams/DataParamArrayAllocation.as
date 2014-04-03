package uk.ac.sussex.model.valueObjects.requestParams {
	import uk.ac.sussex.model.valueObjects.Allocation;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArray;

	/**
	 * @author em97
	 */
	public class DataParamArrayAllocation extends DataParamArray {
		public function DataParamArrayAllocation(paramName : String) {
			super(paramName);
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var sfsArray:SFSArray = existingObject.getSFSArray(this.getParamName()) as SFSArray;
			if(sfsArray != null){
				var sfsSize:int = sfsArray.size();
				var myValue:Array = new Array();
				
				for (var i:int = 0; i < sfsSize; i++) {
					var allocation:Allocation = new Allocation();
					var allocationSFSObj:SFSObject = sfsArray.getSFSObject(i) as SFSObject;
					allocation = DataParamAllocation.translateFromSFStoClass(allocationSFSObj);
					
					myValue.push(allocation);
				}
			}
			this.setParamValue(myValue);
			return existingObject;
		}
	}
}
