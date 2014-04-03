package uk.ac.sussex.model.valueObjects.requestParams {
	import com.smartfoxserver.v2.entities.data.SFSObject;
	
	/**
	 * @author em97
	 */
	public class DataParamNumber extends DataParam {
		public function DataParamNumber(paramName : String) {
			super(paramName);
		}
		override public function getParamValue() {
			var value:Number = this.paramValue as Number;
			return value;
		}
		override public function setParamValue(paramValue) {
			var value:Number = Number(paramValue);
			this.paramValue = value;
		}
		override public function addToServerParam(existingObject:SFSObject):SFSObject {
			existingObject.putDouble(this.getParamName(), this.getParamValue() as Number);
			return existingObject;
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var myValue:Number = existingObject.getDouble(this.getParamName());
			this.setParamValue(myValue);
			return existingObject;
		}
	}
}
