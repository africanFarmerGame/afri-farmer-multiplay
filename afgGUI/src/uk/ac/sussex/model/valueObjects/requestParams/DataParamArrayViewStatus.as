package uk.ac.sussex.model.valueObjects.requestParams {
	import uk.ac.sussex.model.valueObjects.ViewStatus;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArray;

	/**
	 * @author em97
	 */
	public class DataParamArrayViewStatus extends DataParamArray {
		public function DataParamArrayViewStatus(paramName : String) {
			super(paramName);
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var sfsArray:SFSArray = existingObject.getSFSArray(this.getParamName()) as SFSArray;
			if(sfsArray != null){
				var myValue:Array = translateToArray(sfsArray);
			}
			this.setParamValue(myValue);
			
			return existingObject;
		}
		
		public static function translateToArray(sfsArray:SFSArray):Array {
			var sfsSize:int = sfsArray.size();
			var myValue:Array = new Array();
			for (var i:int = 0; i < sfsSize; i++) {
				var viewStatus:ViewStatus = new ViewStatus();
				var vsObj:SFSObject = sfsArray.getSFSObject(i) as SFSObject;
				viewStatus.setViewName(vsObj.getUtfString("view"));
				viewStatus.setStatus(vsObj.getInt("value"));
				myValue.push(viewStatus);
			}
			return myValue;	
		}
	}
}
