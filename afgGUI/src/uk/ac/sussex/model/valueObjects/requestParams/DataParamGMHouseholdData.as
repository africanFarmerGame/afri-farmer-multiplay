package uk.ac.sussex.model.valueObjects.requestParams {
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import uk.ac.sussex.model.valueObjects.GMHouseholdData;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParam;

	/**
	 * @author em97
	 */
	public class DataParamGMHouseholdData extends DataParam {
		public function DataParamGMHouseholdData(paramName : String) {
			super(paramName);
		}
		override public function getParamValue() {
			var value:GMHouseholdData = this.paramValue as GMHouseholdData;
			return value;
		}
		override public function setParamValue(paramValue) {
			var value:GMHouseholdData = paramValue as GMHouseholdData;
			this.paramValue = value;
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var fsObj:SFSObject = existingObject.getSFSObject(this.getParamName()) as SFSObject;
			var fs:GMHouseholdData = DataParamGMHouseholdData.translateFromSFStoClass(fsObj);
			this.setParamValue(fs);
			return existingObject;
		}
		public static function translateFromSFStoClass(fsObj:SFSObject):GMHouseholdData{
			var fs:GMHouseholdData = new GMHouseholdData();
			fs.setHearthId(fsObj.getInt("HearthId"));
			fs.setPendingTaskCount(fsObj.getInt("PendingTaskCount"));
			fs.setADiets(fsObj.getInt("ADiet"));
			fs.setBDiets(fsObj.getInt("BDiet"));
			fs.setCDiets(fsObj.getInt("CDiet"));
			fs.setXDiets(fsObj.getInt("XDiet"));
			fs.setEnoughFood(fsObj.getBool("Enough"));
			return fs;
		}
	}
}
