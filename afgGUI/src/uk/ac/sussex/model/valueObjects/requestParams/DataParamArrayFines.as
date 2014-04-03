package uk.ac.sussex.model.valueObjects.requestParams {
	import uk.ac.sussex.model.valueObjects.Fine;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArray;

	/**
	 * @author em97
	 */
	public class DataParamArrayFines extends DataParamArray {
		public function DataParamArrayFines(paramName : String) {
			super(paramName);
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var sfsArray:SFSArray = existingObject.getSFSArray(this.getParamName()) as SFSArray;
			if(sfsArray != null){
				var sfsSize:int = sfsArray.size();
				var myValue:Array = new Array();
				for (var i:int = 0; i < sfsSize; i++) {
					var fine:Fine = new Fine();
					var fineObj:SFSObject = sfsArray.getSFSObject(i) as SFSObject;
					fine.setId(fineObj.getInt("Id"));
					fine.setPayee(fineObj.getInt("Payee"));
					fine.setDescription(fineObj.getUtfString("Description"));
					fine.setEarlyRate(fineObj.getDouble("EarlyRate"));
					fine.setLateRate(fineObj.getDouble("LateRate"));
					fine.setSeason(fineObj.getInt("Season"));
					fine.setPaid((fineObj.getInt("Paid")==1));
					myValue.push(fine);
				}
			}
			this.setParamValue(myValue);
			
			return existingObject;
		}
	}
}
