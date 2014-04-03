package uk.ac.sussex.model.valueObjects.requestParams {
	import uk.ac.sussex.model.valueObjects.Hearth;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import com.smartfoxserver.v2.entities.data.SFSObject;

	/**
	 * @author em97
	 */
	public class DataParamArrayHearth extends DataParamArray {
		public function DataParamArrayHearth(paramName : String) {
			super(paramName);
		}
		override public function addToServerParam(existingObject:SFSObject):SFSObject {
			var localArray:Array = this.getParamValue() as Array;
			var sfsArray:SFSArray = new SFSArray();
			for each (var item:Hearth in localArray) {
				var sfsObj:SFSObject = new SFSObject();
				sfsObj.putInt("ID", item.getId());
				sfsObj.putUtfString("HearthName", item.getHearthName());
				sfsArray.addSFSObject(sfsObj);
			}
			existingObject.putSFSArray(this.getParamName(), sfsArray);
			return existingObject;
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var sfsArray:SFSArray = existingObject.getSFSArray(this.getParamName()) as SFSArray;
			if(sfsArray != null){
				var sfsSize:int = sfsArray.size();
				var myValue:Array = new Array();
				
				for (var i:int = 0; i < sfsSize; i++) {
					var hearthItem:Hearth = new Hearth();
					var hearthSFSObj:SFSObject = sfsArray.getSFSObject(i) as SFSObject;
					hearthItem.setId(hearthSFSObj.getInt("ID"));
					hearthItem.setHearthName(hearthSFSObj.getUtfString("HearthName"));
					hearthItem.setHouseNumber(hearthSFSObj.getInt("HouseNumber"));
					hearthItem.setNumAdults(hearthSFSObj.getInt("HearthAdults"));
					hearthItem.setNumChildren(hearthSFSObj.getInt("HearthChildren"));
					hearthItem.setNumFields(hearthSFSObj.getInt("HearthFields"));
					myValue.push(hearthItem);
				}
			}
			this.setParamValue(myValue);
			return existingObject;
		}
	}
}
