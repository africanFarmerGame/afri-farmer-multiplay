package uk.ac.sussex.model.valueObjects.requestParams {
	import uk.ac.sussex.model.valueObjects.GameAsset;
	import uk.ac.sussex.model.valueObjects.GameAssetCrop;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArray;

	/**
	 * @author em97
	 */
	public class DataParamArrayGameAssetCrop extends DataParamArray {
		public function DataParamArrayGameAssetCrop(paramName : String) {
			super(paramName);
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var sfsArray:SFSArray = existingObject.getSFSArray(this.getParamName()) as SFSArray;
			if(sfsArray != null){
				var sfsSize:int = sfsArray.size();
				var myValue:Array = new Array();
				
				for (var i:int = 0; i < sfsSize; i++) {
					var item:GameAssetCrop = new GameAssetCrop();
					var assetSFSObj:SFSObject = sfsArray.getSFSObject(i) as SFSObject;
					item.setId(assetSFSObj.getInt("Id"));
					item.setMeasurement(assetSFSObj.getUtfString("Measurement"));
					item.setName(assetSFSObj.getUtfString("Name"));
					item.setType(assetSFSObj.getUtfString("Type"));
					item.setSubtype(assetSFSObj.getUtfString("Subtype"));
					item.setEdible((assetSFSObj.getInt("Edible")==1));
					item.setMaturity(assetSFSObj.getInt("Maturity"));
					item.setEPYield(assetSFSObj.getInt("EPYield"));
					item.setLPYield(assetSFSObj.getInt("LPYield"));
					item.setNotes(assetSFSObj.getUtfString("Notes"));
					var outputAsset:GameAsset = new GameAsset();
					outputAsset.setId(assetSFSObj.getInt("OutputAsset")); 
					item.setOutputAsset(outputAsset);
					myValue.push(item);
				}
			}
			this.setParamValue(myValue);
			return existingObject;
		}
	}
}
