/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects.requestParams {
	import uk.ac.sussex.model.valueObjects.HouseholdStatus;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArray;

	/**
	 * @author em97
	 */
	public class DataParamArrayHouseholdStatus extends DataParamArray {
		public function DataParamArrayHouseholdStatus(paramName : String) {
			super(paramName);
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var sfsArray:SFSArray = existingObject.getSFSArray(this.getParamName()) as SFSArray;
			if(sfsArray != null){
				var sfsSize:int = sfsArray.size();
				var myValue:Array = new Array();
				
				for (var i:int = 0; i < sfsSize; i++) {
					var sfsObject:SFSObject = sfsArray.getSFSObject(i) as SFSObject;
					var household:HouseholdStatus = new HouseholdStatus();
					household.setHouseholdId(sfsObject.getInt("HearthId"));
					household.setHouseholdName(sfsObject.getUtfString("HearthName"));
					household.setHousenumber(sfsObject.getInt("HouseNumber"));
					var statusArray:SFSArray = sfsObject.getSFSArray("ViewDetails") as SFSArray;
					household.setViewStatuses(DataParamArrayViewStatus.translateToArray(statusArray));
					myValue.push(household);
				}
			}
			this.setParamValue(myValue);
			return existingObject;
		}
	}
}
