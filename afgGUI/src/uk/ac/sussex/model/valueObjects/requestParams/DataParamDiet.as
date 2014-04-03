package uk.ac.sussex.model.valueObjects.requestParams {
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import uk.ac.sussex.model.valueObjects.DietItem;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import uk.ac.sussex.model.valueObjects.Diet;

	/**
	 * @author em97
	 */
	public class DataParamDiet extends DataParam {
		public function DataParamDiet(paramName : String) {
			super(paramName);
		}
		override public function getParamValue() {
			var value:Diet = this.paramValue as Diet;
			return value;
		}
		override public function setParamValue(paramValue) {
			var value:Diet = paramValue as Diet;
			this.paramValue = value;
		}
		override public function addToServerParam(existingObject:SFSObject):SFSObject {
			//existingObject.putUtfString(this.getParamName(), this.getParamValue());
			var dietObj:SFSObject = SFSObject.newInstance();
			var diet:Diet = this.getParamValue() as Diet;
			if(diet == null){
				existingObject.putNull(this.getParamName());
				throw new Error("The Diet param is null.");
			}
			dietObj.putInt("Id", diet.getId());
			dietObj.putUtfString("Name", diet.getName());
			dietObj.putInt("HearthId", diet.getHearthId());
			dietObj.putInt("Target", diet.getTarget());
			var dietItems:Array = diet.getDietItems();
			var diArray:SFSArray = SFSArray.newInstance();
			for each (var dietItem:DietItem in dietItems){
				var diObj:SFSObject = SFSObject.newInstance();
				diObj.putInt("Id", dietItem.getId());
				diObj.putInt("Amount", dietItem.getAmount());
				diObj.putInt("AssetId", dietItem.getAssetId());
				diArray.addSFSObject(diObj);
			}
			dietObj.putSFSArray("DietItems", diArray);
			existingObject.putSFSObject(this.getParamName(), dietObj);
			return existingObject;
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var tmObj:SFSObject = existingObject.getSFSObject(this.getParamName()) as SFSObject;
			var tm:Diet = DataParamDiet.translateFromSFStoClass(tmObj);
			this.setParamValue(tm);
			return existingObject;
		}
		public static function translateFromSFStoClass(dietObj:SFSObject):Diet{
			var diet:Diet = new Diet();
			diet.setId(dietObj.getInt("Id"));
			diet.setName(dietObj.getUtfString("Name"));
			diet.setTarget(dietObj.getInt("Target"));
			var dietItemObjs:SFSArray = dietObj.getSFSArray("DietItems") as SFSArray;
			var dietItems:Array = new Array();
			var maxDietItems:uint = dietItemObjs.size();
			for (var counter:uint = 0; counter < maxDietItems; counter ++ ){
				var dietItem:DietItem = new DietItem();
				var diObj:SFSObject = dietItemObjs.getSFSObject(counter) as SFSObject;
				dietItem.setId(diObj.getInt("Id"));
				dietItem.setAmount(diObj.getInt("Amount"));
				dietItem.setAssetId(diObj.getInt("AssetId"));
				dietItem.setDiet(diet);
				dietItems.push(dietItem);
			}
			diet.setDietItems(dietItems);
			return diet;
		}
	}
}
