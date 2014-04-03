package uk.ac.sussex.model.valueObjects.requestParams {
	import uk.ac.sussex.serverhandlers.SeasonsHandlers;
	import uk.ac.sussex.model.valueObjects.Weather;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArray;

	/**
	 * @author em97
	 */
	public class DataParamArrayWeather extends DataParamArray {
		public function DataParamArrayWeather(paramName : String) {
			super(paramName);
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var sfsArray:SFSArray = existingObject.getSFSArray(this.getParamName()) as SFSArray;
			if(sfsArray != null){
				var sfsSize:int = sfsArray.size();
				var myValue:Array = new Array();
				
				for (var i:int = 0; i < sfsSize; i++) {
					var weatherSFSObj:SFSObject = sfsArray.getSFSObject(i) as SFSObject;
					var item:Weather = new Weather(weatherSFSObj.getUtfString(SeasonsHandlers.WEATHER), weatherSFSObj.getInt(SeasonsHandlers.WEATHER_SEASON));
					myValue.push(item);
				}
			}
			this.setParamValue(myValue);
			return existingObject;
		}
	}
}
