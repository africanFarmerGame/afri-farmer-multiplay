/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects.requestParams {
	import uk.ac.sussex.model.valueObjects.Fine;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArray;

	/**
	 * @author em97
	 */
	public class DataParamArrayFines extends DataParamArray {
		public function DataParamArrayFines(paramName : String) {
			super(paramName);
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var sfsArray:SFSArray = existingObject.getSFSArray(this.getParamName()) as SFSArray;
			if(sfsArray != null){
				var sfsSize:int = sfsArray.size();
				var myValue:Array = new Array();
				for (var i:int = 0; i < sfsSize; i++) {
					var fine:Fine = new Fine();
					var fineObj:SFSObject = sfsArray.getSFSObject(i) as SFSObject;
					fine.setId(fineObj.getInt("Id"));
					fine.setPayee(fineObj.getInt("Payee"));
					fine.setDescription(fineObj.getUtfString("Description"));
					fine.setEarlyRate(fineObj.getDouble("EarlyRate"));
					fine.setLateRate(fineObj.getDouble("LateRate"));
					fine.setSeason(fineObj.getInt("Season"));
					fine.setPaid((fineObj.getInt("Paid")==1));
					myValue.push(fine);
				}
			}
			this.setParamValue(myValue);
			
			return existingObject;
		}
	}
}
