/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
