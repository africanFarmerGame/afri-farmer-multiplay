package uk.ac.sussex.model.valueObjects.requestParams {
	import uk.ac.sussex.model.valueObjects.GameAsset;
	import uk.ac.sussex.model.valueObjects.Field;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import com.smartfoxserver.v2.entities.data.SFSObject;

	/**
	 * @author em97
	 */
	public class DataParamArrayField extends DataParamArray {
		public function DataParamArrayField(paramName : String) {
			super(paramName);
		}
		override public function addToServerParam(existingObject:SFSObject):SFSObject {
			var localArray:Array = this.getParamValue() as Array;
			var sfsArray:SFSArray = new SFSArray();
			for each (var item:Field in localArray) {
				var sfsObj:SFSObject = new SFSObject();
				sfsObj.putInt("Id", item.getId());
				sfsObj.putInt("Quality", item.getQuality());
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
					var field:Field = new Field();
					var fieldSFSObj:SFSObject = sfsArray.getSFSObject(i) as SFSObject;
					field.setId(fieldSFSObj.getInt("Id"));
					field.setQuality(fieldSFSObj.getInt("Quality"));
					field.setName(fieldSFSObj.getUtfString("Name"));
					
					if(fieldSFSObj.getInt("Crop") > 0){
						var crop:GameAsset = new GameAsset();
						crop.setId(fieldSFSObj.getInt("Crop"));
						field.setCrop(crop);
						field.setCropAge(fieldSFSObj.getInt("CropAge"));
						field.setCropHealth(fieldSFSObj.getInt("CropHealth"));
						field.setCropPlanting(fieldSFSObj.getInt("CropPlanting"));
						field.setWeeded(fieldSFSObj.getInt("Weeded")==1);
					}
					if(fieldSFSObj.getInt("Fertiliser") > 0){
						var fertiliser:GameAsset = new GameAsset();
						fertiliser.setId(fieldSFSObj.getInt("Fertiliser"));
						field.setFertiliser(fertiliser);
					}
					if(fieldSFSObj.getUtfString("Hazard")!=null){
					  field.setHazard(fieldSFSObj.getUtfString("Hazard"));
					  field.setHazardNotes(fieldSFSObj.getUtfString("HazardNotes"));
					  field.setFullReduction(fieldSFSObj.getInt("FullRed"));
					  field.setMitigatedReduction(fieldSFSObj.getInt("MitigatedRed"));
					}
					myValue.push(field);
				}
			}
			this.setParamValue(myValue);
			return existingObject;
		}
	}
}
