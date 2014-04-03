/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects.requestParams {
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import uk.ac.sussex.model.valueObjects.GMHouseholdData;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParam;

	/**
	 * @author em97
	 */
	public class DataParamGMHouseholdData extends DataParam {
		public function DataParamGMHouseholdData(paramName : String) {
			super(paramName);
		}
		override public function getParamValue() {
			var value:GMHouseholdData = this.paramValue as GMHouseholdData;
			return value;
		}
		override public function setParamValue(paramValue) {
			var value:GMHouseholdData = paramValue as GMHouseholdData;
			this.paramValue = value;
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var fsObj:SFSObject = existingObject.getSFSObject(this.getParamName()) as SFSObject;
			var fs:GMHouseholdData = DataParamGMHouseholdData.translateFromSFStoClass(fsObj);
			this.setParamValue(fs);
			return existingObject;
		}
		public static function translateFromSFStoClass(fsObj:SFSObject):GMHouseholdData{
			var fs:GMHouseholdData = new GMHouseholdData();
			fs.setHearthId(fsObj.getInt("HearthId"));
			fs.setPendingTaskCount(fsObj.getInt("PendingTaskCount"));
			fs.setADiets(fsObj.getInt("ADiet"));
			fs.setBDiets(fsObj.getInt("BDiet"));
			fs.setCDiets(fsObj.getInt("CDiet"));
			fs.setXDiets(fsObj.getInt("XDiet"));
			fs.setEnoughFood(fsObj.getBool("Enough"));
			return fs;
		}
	}
}
