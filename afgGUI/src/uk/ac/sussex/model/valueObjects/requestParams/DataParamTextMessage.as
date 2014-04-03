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
