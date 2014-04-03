/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects.requestParams {
	import com.smartfoxserver.v2.entities.data.SFSObject;
	
	/**
	 * @author em97
	 */
	public class DataParamNumber extends DataParam {
		public function DataParamNumber(paramName : String) {
			super(paramName);
		}
		override public function getParamValue() {
			var value:Number = this.paramValue as Number;
			return value;
		}
		override public function setParamValue(paramValue) {
			var value:Number = Number(paramValue);
			this.paramValue = value;
		}
		override public function addToServerParam(existingObject:SFSObject):SFSObject {
			existingObject.putDouble(this.getParamName(), this.getParamValue() as Number);
			return existingObject;
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var myValue:Number = existingObject.getDouble(this.getParamName());
			this.setParamValue(myValue);
			return existingObject;
		}
	}
}
