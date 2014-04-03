/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects.requestParams {
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import uk.ac.sussex.model.valueObjects.TextMessage;

	/**
	 * @author em97
	 */
	public class DataParamTextMessage extends DataParam {
		public function DataParamTextMessage(paramName : String) {
			super(paramName);
		}
		override public function getParamValue() {
			var value:TextMessage = this.paramValue as TextMessage;
			return value;
		}
		override public function setParamValue(paramValue) {
			var value:TextMessage = paramValue as TextMessage;
			this.paramValue = value;
		}
		override public function addToServerParam(existingObject:SFSObject):SFSObject {
			//existingObject.putUtfString(this.getParamName(), this.getParamValue());
			var tmObj:SFSObject = SFSObject.newInstance();
			var tm:TextMessage = this.getParamValue() as TextMessage;
			if(tm == null){
				existingObject.putNull(this.getParamName());
				throw new Error("The TextMessage param is null.");
			}
			tmObj.putInt("id", tm.getId());
			tmObj.putInt("sender", tm.getSender());
			tmObj.putInt("receiver", tm.getReceiver());
			tmObj.putUtfString("message", tm.getTextMessage());
			tmObj.putInt("unread", (tm.getUnread()?1:0));
			tmObj.putInt("deleted", (tm.getDeleted()?1:0));
			existingObject.putSFSObject(this.getParamName(), tmObj);
			return existingObject;
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var tmObj:SFSObject = existingObject.getSFSObject(this.getParamName()) as SFSObject;
			var tm:TextMessage = DataParamTextMessage.translateFromSFStoClass(tmObj);
			this.setParamValue(tm);
			return existingObject;
		}
		public static function translateFromSFStoClass(tmObj:SFSObject):TextMessage{
			var tm:TextMessage = new TextMessage();
			tm.setId(tmObj.getInt("id"));
			tm.setTextMessage(tmObj.getUtfString("message"));
			tm.setUnread((tmObj.getInt("unread")==1));
			tm.setDeleted((tmObj.getInt("deleted")==1));
			tm.setReceiver(tmObj.getInt("receiver"));
			tm.setSender(tmObj.getInt("sender"));
			tm.setSenderName(tmObj.getUtfString("senderName"));
			tm.setTimeStamp(tmObj.getLong("timestamp"));
			return tm;
		}
	}
}
