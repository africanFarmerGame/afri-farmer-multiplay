package uk.ac.sussex.model.valueObjects.requestParams {
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import uk.ac.sussex.model.valueObjects.FinancialStatus;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParam;

	/**
	 * @author em97
	 */
	public class DataParamFinancialStatus extends DataParam {
		public function DataParamFinancialStatus(paramName : String) {
			super(paramName);
		}
		override public function getParamValue() {
			var value:FinancialStatus = this.paramValue as FinancialStatus;
			return value;
		}
		override public function setParamValue(paramValue) {
			var value:FinancialStatus = paramValue as FinancialStatus;
			this.paramValue = value;
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var fsObj:SFSObject = existingObject.getSFSObject(this.getParamName()) as SFSObject;
			var fs:FinancialStatus = DataParamFinancialStatus.translateFromSFStoClass(fsObj);
			this.setParamValue(fs);
			return existingObject;
		}
		public static function translateFromSFStoClass(fsObj:SFSObject):FinancialStatus{
			var fs:FinancialStatus = new FinancialStatus();
			fs.setAssetWorth(fsObj.getDouble("HearthAssets"));
			fs.setCashValue(fsObj.getDouble("HearthCash"));
			fs.setHearthId(fsObj.getInt("HearthId"));
			fs.setHearthName(fsObj.getUtfString("HearthName"));
			fs.setUnpaidBills(fsObj.getInt("PendingBills"));
			return fs;
		}
		
	}
}
