/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects.requestParams {
	import uk.ac.sussex.model.valueObjects.GameAsset;
	import uk.ac.sussex.model.valueObjects.GameAssetFood;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import com.smartfoxserver.v2.entities.data.SFSObject;

	/**
	 * @author em97
	 */
	public class DataParamArrayGameAssetFood extends DataParamArray {
		public function DataParamArrayGameAssetFood(paramName : String) {
			super(paramName);
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var sfsArray:SFSArray = existingObject.getSFSArray(this.getParamName()) as SFSArray;
			if(sfsArray != null){
				var sfsSize:int = sfsArray.size();
				var myValue:Array = new Array();
				
				for (var i:int = 0; i < sfsSize; i++) {
					var item:GameAssetFood = new GameAssetFood();
					var assetSFSObj:SFSObject = sfsArray.getSFSObject(i) as SFSObject;
					item.setId(assetSFSObj.getInt("Id"));
					item.setMeasurement(assetSFSObj.getUtfString("Measurement"));
					item.setName(assetSFSObj.getUtfString("Name"));
					item.setType(assetSFSObj.getUtfString("Type"));
					item.setSubtype(assetSFSObj.getUtfString("Subtype"));
					item.setEdible((assetSFSObj.getInt("Edible")==1));
					item.setCarbs((assetSFSObj.getInt("Carbs")));
					item.setNutrients(assetSFSObj.getInt("Nutrients"));
					item.setProtein(assetSFSObj.getInt("Protein"));
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
