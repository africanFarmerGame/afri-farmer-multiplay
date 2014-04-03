package uk.ac.sussex.model.valueObjects.requestParams {
	import uk.ac.sussex.model.valueObjects.DietaryRequirement;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import com.smartfoxserver.v2.entities.data.SFSObject;

	/**
	 * @author em97
	 */
	public class DataParamArrayDietaryRequirement extends DataParamArray {
		public function DataParamArrayDietaryRequirement(paramName : String) {
			super(paramName);
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var sfsArray:SFSArray = existingObject.getSFSArray(this.getParamName()) as SFSArray;
			if(sfsArray != null){
				var sfsSize:int = sfsArray.size();
				var myValue:Array = new Array();
				
				for (var i:int = 0; i < sfsSize; i++) {
					var dietaryReqItem:DietaryRequirement = new DietaryRequirement();
					var drSFSObj:SFSObject = sfsArray.getSFSObject(i) as SFSObject;
					dietaryReqItem.setType(drSFSObj.getInt("DietaryType"));
					dietaryReqItem.setLevel(drSFSObj.getUtfString("DietaryLevel"));
					dietaryReqItem.setProtein(drSFSObj.getInt("Protein"));
					dietaryReqItem.setCarbs(drSFSObj.getInt("Carbohydrate"));
					dietaryReqItem.setNutrients(drSFSObj.getInt("Nutrients"));
					
					myValue.push(dietaryReqItem);
				}
			}
			this.setParamValue(myValue);
			return existingObject;
		}
	}
}
