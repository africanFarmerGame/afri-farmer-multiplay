/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects.requestParams {
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import uk.ac.sussex.model.valueObjects.FinancialStatus;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParam;

	/**
	 * @author em97
	 */
	public class DataParamFinancialStatus extends DataParam {
		public function DataParamFinancialStatus(paramName : String) {
			super(paramName);
		}
		override public function getParamValue() {
			var value:FinancialStatus = this.paramValue as FinancialStatus;
			return value;
		}
		override public function setParamValue(paramValue) {
			var value:FinancialStatus = paramValue as FinancialStatus;
			this.paramValue = value;
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var fsObj:SFSObject = existingObject.getSFSObject(this.getParamName()) as SFSObject;
			var fs:FinancialStatus = DataParamFinancialStatus.translateFromSFStoClass(fsObj);
			this.setParamValue(fs);
			return existingObject;
		}
		public static function translateFromSFStoClass(fsObj:SFSObject):FinancialStatus{
			var fs:FinancialStatus = new FinancialStatus();
			fs.setAssetWorth(fsObj.getDouble("HearthAssets"));
			fs.setCashValue(fsObj.getDouble("HearthCash"));
			fs.setHearthId(fsObj.getInt("HearthId"));
			fs.setHearthName(fsObj.getUtfString("HearthName"));
			fs.setUnpaidBills(fsObj.getInt("PendingBills"));
			return fs;
		}
		
	}
}
