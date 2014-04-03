/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects.requestParams {
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import uk.ac.sussex.model.valueObjects.SeasonNotification;

	/**
	 * @author em97
	 */
	public class DataParamSeasonNotification extends DataParam {
		public function DataParamSeasonNotification(paramName : String) {
			trace("DataParamSeasonNotification sez: I have a name " + paramName);
			super(paramName);
			trace("DataParamSeasonNotification sez: and my name is stored as " + this.getParamName());
		}
		override public function getParamValue() {
			var value:SeasonNotification = this.paramValue as SeasonNotification;
			trace("DataParamSeasonNotification sez: value is not null " + (value!=null));
			return value;
		}
		override public function setParamValue(paramValue) {
			var value:SeasonNotification = paramValue as SeasonNotification;
			this.paramValue = value;
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			trace("DataParamSeasonNotification sez: I'm translating from server param");
			var tmObj:SFSObject = existingObject.getSFSObject(this.getParamName()) as SFSObject;
			var tm:SeasonNotification = DataParamSeasonNotification.translateFromSFStoClass(tmObj);
			
			this.setParamValue(tm);
			return existingObject;
		}
		public static function translateFromSFStoClass(tmObj:SFSObject):SeasonNotification{
			trace("DataParamSeasonNotification sez: translating. ");
			var sn:SeasonNotification = new SeasonNotification();
			sn.setId(tmObj.getInt("Id"));
			sn.setNotification(tmObj.getUtfString("Notification"));
			sn.setPreviousStage(tmObj.getUtfString("PreviousStage"));
			sn.setNextStage(tmObj.getUtfString("NextStage"));
			return sn;
		}
	}
}
