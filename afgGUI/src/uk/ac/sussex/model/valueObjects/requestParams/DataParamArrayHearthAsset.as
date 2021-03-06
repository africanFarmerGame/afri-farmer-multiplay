/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects.requestParams {
	import com.smartfoxserver.v2.entities.data.ISFSArray;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import uk.ac.sussex.model.valueObjects.FormFieldOption;
	import uk.ac.sussex.model.valueObjects.GameAsset;
	import uk.ac.sussex.model.valueObjects.HearthAsset;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.entities.data.SFSArray;

	/**
	 * @author em97
	 */
	public class DataParamArrayHearthAsset extends DataParamArray {
		public function DataParamArrayHearthAsset(paramName : String) {
			super(paramName);
		}
		override public function addToServerParam(existingObject:SFSObject):SFSObject {
			var localArray:Array = this.getParamValue() as Array;
			var sfsArray:SFSArray = new SFSArray();
			for each (var item:HearthAsset in localArray) {
				var sfsObj:SFSObject = new SFSObject();
				sfsObj.putInt("Id", item.getId());
				sfsObj.putDouble("Amount", item.getAmount());
				sfsObj.putInt("Asset", item.getAsset().getId());
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
					var item:HearthAsset = new HearthAsset();
					var assetSFSObj:SFSObject = sfsArray.getSFSObject(i) as SFSObject;
					item.setId(assetSFSObj.getInt("Id"));
					item.setAmount(assetSFSObj.getDouble("Amount"));
					var asset:GameAsset = new GameAsset();
					asset.setId(assetSFSObj.getInt("Asset"));
					item.setAsset(asset);
					item.setOwner(assetSFSObj.getUtfString("Owner"));
					
					item.setSellOptions(translateOptionArray(assetSFSObj.getSFSArray("SellOptions")));
					
					myValue.push(item);
				}
			}
			this.setParamValue(myValue);
			return existingObject;
		}
		private function translateOptionArray( sfsOptions:ISFSArray):Array{
			if(sfsOptions==null){ 
				return null;
			} else {
				var sfsSize:int = sfsOptions.size();
				var options:Array = new Array();
				for(var i:int = 0; i<sfsSize; i++){
					var option:FormFieldOption = translateTaskOptionFromServerParam(sfsOptions.getSFSObject(i));
					options.push(option);
				}
				return options;
			}
		}
		private function translateTaskOptionFromServerParam(toObj:ISFSObject):FormFieldOption{
			var value:int = toObj.getInt("Value");
			var displayName:String = toObj.getUtfString("Name");
			var ffo:FormFieldOption = new FormFieldOption(displayName, value.toString());
			ffo.setType(toObj.getUtfString("Type"));
			ffo.setStatus(toObj.getInt("Status"));
			ffo.setNotes(toObj.getUtfString("Notes"));
			return ffo;
		}
	}
}
