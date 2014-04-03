package uk.ac.sussex.model.valueObjects.requestParams {
	import uk.ac.sussex.model.valueObjects.Diet;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArray;

	/**
	 * @author em97
	 */
	public class DataParamArrayDiet extends DataParamArray {
		public function DataParamArrayDiet(paramName : String) {
			super(paramName);
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var sfsArray:SFSArray = existingObject.getSFSArray(this.getParamName()) as SFSArray;
			if(sfsArray != null){
				var sfsSize:int = sfsArray.size();
				var myValue:Array = new Array();
				
				for (var i:int = 0; i < sfsSize; i++) {
					var diet:Diet = new Diet();
					var dietSFSObj:SFSObject = sfsArray.getSFSObject(i) as SFSObject;
					diet = DataParamDiet.translateFromSFStoClass(dietSFSObj);
					
					myValue.push(diet);
				}
			}
			this.setParamValue(myValue);
			return existingObject;
		}
	}
}
