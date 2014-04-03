/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects.requestParams {
	import uk.ac.sussex.model.valueObjects.Diet;
	import uk.ac.sussex.model.valueObjects.DietItem;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import uk.ac.sussex.model.valueObjects.Allocation;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParam;

	/**
	 * @author em97
	 */
	public class DataParamAllocation extends DataParam {
		public function DataParamAllocation(paramName : String) {
			super(paramName);
		}
		override public function getParamValue() {
			var value:Allocation = this.paramValue as Allocation;
			return value;
		}
		override public function setParamValue(paramValue) {
			var value:Allocation = paramValue as Allocation;
			this.paramValue = value;
		}
		override public function addToServerParam(existingObject:SFSObject):SFSObject {
			//existingObject.putUtfString(this.getParamName(), this.getParamValue());
			var allocationObj:SFSObject = SFSObject.newInstance();
			var allocation:Allocation = this.getParamValue() as Allocation;
			if(allocation == null){
				existingObject.putNull(this.getParamName());
				throw new Error("The Allocation param is null.");
			}
			allocationObj.putInt("Id", allocation.getId());
			allocationObj.putUtfString("Name", allocation.getName());
			allocationObj.putInt("HearthId", allocation.getHearthid());
			allocationObj.putInt("Selected", (allocation.getSelected()?1:0));
			var diets:Array = allocation.getAllocationDiets();
			var aiArray:SFSArray = SFSArray.newInstance();
			for each (var diet:Diet in diets){
				var dietItems:Array= diet.getDietItems();
				for each (var dietItem:DietItem in dietItems){
					var diObj:SFSObject = SFSObject.newInstance();
					diObj.putInt("Id", dietItem.getId());
					diObj.putInt("Amount", dietItem.getAmount());
					diObj.putInt("Asset", dietItem.getAssetId());
					diObj.putInt("Character", diet.getId());
					diObj.putInt("Allocation", allocation.getId());
					aiArray.addSFSObject(diObj);
				}
			}
			allocationObj.putSFSArray("AllocationItems", aiArray);
			existingObject.putSFSObject(this.getParamName(), allocationObj);
			return existingObject;
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var allocationObj:SFSObject = existingObject.getSFSObject(this.getParamName()) as SFSObject;
			var allocation:Allocation = translateFromSFStoClass(allocationObj);
			this.setParamValue(allocation);
			return existingObject;
		}
		public static function translateFromSFStoClass(allocationObj:SFSObject):Allocation{
			var allocation:Allocation = new Allocation();
			allocation.setId(allocationObj.getInt("Id"));
			allocation.setName(allocationObj.getUtfString("Name"));
			allocation.setSelected((allocationObj.getInt("Selected")==1));
			var allocationItemObjs:SFSArray = allocationObj.getSFSArray("AllocationItems") as SFSArray;
			var allocationItems:Array = new Array();
			var maxDietItems:uint = allocationItemObjs.size();
			for (var counter:uint = 0; counter < maxDietItems; counter ++ ){
				var aiObj:SFSObject = allocationItemObjs.getSFSObject(counter) as SFSObject;
				var dietId:int = aiObj.getInt("Character");
				var diet:Diet = allocation.getAllocationDiet(dietId);
				if (diet==null){
					diet = new Diet();
					diet.setId(dietId);
					allocationItems.push(diet);
					allocation.setAllocationDiets(allocationItems);
				}
				var dietItems:Array = diet.getDietItems();
				if(dietItems == null){
					dietItems = new Array();
				}
				var dietItem:DietItem = new DietItem();
				dietItem.setId(aiObj.getInt("Id"));
				dietItem.setAmount(aiObj.getInt("Amount"));
				dietItem.setAssetId(aiObj.getInt("Asset"));
				dietItem.setDiet(diet);
				dietItems.push(dietItem);
				diet.setDietItems(dietItems);
			}
			return allocation;
		}
	}
}
