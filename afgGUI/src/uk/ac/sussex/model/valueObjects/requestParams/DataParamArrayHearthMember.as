/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects.requestParams {
	import uk.ac.sussex.model.valueObjects.HearthMember;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import com.smartfoxserver.v2.entities.data.SFSObject;

	/**
	 * @author em97
	 */
	public class DataParamArrayHearthMember extends DataParamArray {
		public function DataParamArrayHearthMember(paramName : String) {
			super(paramName);
		}
		override public function addToServerParam(existingObject:SFSObject):SFSObject {
			var localArray:Array = this.getParamValue() as Array;
			var sfsArray:SFSArray = new SFSArray();
			for each (var item:HearthMember in localArray) {
				var sfsObj:SFSObject = new SFSObject();
				sfsObj.putInt("ID", item.getId());
				//sfsObj.putUtfString("HearthName", item.getHearthName());
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
					var hearthMemberItem:HearthMember = new HearthMember();
					var hearthSFSObj:SFSObject = sfsArray.getSFSObject(i) as SFSObject;
					hearthMemberItem.setId(hearthSFSObj.getInt("ID"));
					hearthMemberItem.setFamilyName(hearthSFSObj.getUtfString("familyname"));
					hearthMemberItem.setFirstName(hearthSFSObj.getUtfString("firstname"));
					hearthMemberItem.setRole(hearthSFSObj.getUtfString("Role"));
					hearthMemberItem.setAvatarBody(hearthSFSObj.getInt("AvatarBody"));
					hearthMemberItem.setAge(hearthSFSObj.getInt("Age"));
					hearthMemberItem.setDietTarget(hearthSFSObj.getInt("DietTarget"));
					hearthMemberItem.setHearthId(hearthSFSObj.getInt("HearthId"));
					hearthMemberItem.setAlive(hearthSFSObj.getInt("Alive"));
					hearthMemberItem.setHealthHazard(hearthSFSObj.getUtfString("healthHazard"));
					hearthMemberItem.setCurrentDiet(hearthSFSObj.getUtfString("CurrentDiet"));
					myValue.push(hearthMemberItem);
				}
			}
			this.setParamValue(myValue);
			return existingObject;
		}
	}
}
