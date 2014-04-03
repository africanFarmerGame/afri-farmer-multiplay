/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects.requestParams {
	import uk.ac.sussex.model.valueObjects.AnyChar;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
	
	import uk.ac.sussex.model.valueObjects.PlayerChar;
	
	/**
	 * @author em97
	 */
	public class DataParamPlayerChar extends DataParam {
		public function DataParamPlayerChar(paramName : String) {
			super(paramName);
		}
		override public function getParamValue() {
			var value:PlayerChar = this.paramValue as PlayerChar;
			return value;
		}
		override public function setParamValue(paramValue) {
			var value:PlayerChar = paramValue as PlayerChar;
			this.paramValue = value;
		}
		override public function addToServerParam(existingObject:SFSObject):SFSObject {
			//existingObject.putUtfString(this.getParamName(), this.getParamValue());
			return existingObject;
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var pcObj:SFSObject = existingObject.getSFSObject(this.getParamName()) as SFSObject;
			var pc:PlayerChar = DataParamPlayerChar.translateFromSFStoClass(pcObj);
			this.setParamValue(pc);
			return existingObject;
		}
		override public function translateFromUserVariable(userVars:Array):void {
			for each (var pcVar:SFSUserVariable in userVars){
				if(pcVar.name == this.getParamName()) {
					break;
				}
			}
			if(pcVar != null){
				trace("DataParamPlayerChar sez: pcVar is not null");
				var pcObj:SFSObject = pcVar.getSFSObjectValue() as SFSObject;
				var pc:PlayerChar = DataParamPlayerChar.translateFromSFStoClass(pcObj);
				this.setParamValue(pc);
			}
		}
		public static function translateFromSFStoClass(pcObj:SFSObject):PlayerChar{
			var pc:PlayerChar = new PlayerChar();
			pc.setId(pcObj.getInt("id"));
			pc.setFirstName(pcObj.getUtfString("firstname"));
			pc.setFamilyName(pcObj.getUtfString("familyname"));
			pc.setRole(pcObj.getUtfString("role"));
			pc.setRelationship(AnyChar.IMMEDIATE_FAMILY);
			pc.setOnlineStatus(pcObj.getBool("online"));
			pc.setHearthId(pcObj.getInt("hearthid"));
			pc.setAvatarBody(pcObj.getInt("avatarbody"));
			pc.setDietTarget(pcObj.getInt("DietTarget"));
			pc.setAlive(pcObj.getInt("alive"));
			pc.setHealthHazard(pcObj.getUtfString("healthHazard"));
			pc.setCurrentDiet(pcObj.getUtfString("CurrentDiet"));
			pc.setFieldCount(pcObj.getInt("fields"));
			return pc;
		}
	}
}
