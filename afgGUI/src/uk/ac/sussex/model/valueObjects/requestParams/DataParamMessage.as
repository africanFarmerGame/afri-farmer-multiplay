package uk.ac.sussex.model.valueObjects.requestParams {
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import uk.ac.sussex.model.valueObjects.Message;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParam;

	/**
	 * @author em97
	 */
	public class DataParamMessage extends DataParam {
		public function DataParamMessage(paramName : String) {
			super(paramName);
		}
		override public function getParamValue() {
			var value:Message = this.paramValue as Message;
			return value;
		}
		override public function setParamValue(paramValue) {
			var value:Message = paramValue as Message;
			this.paramValue = value;
		}
		override public function addToServerParam(existingObject:SFSObject):SFSObject {
			//existingObject.putUtfString(this.getParamName(), this.getParamValue());
			var tmObj:SFSObject = SFSObject.newInstance();
			var m:Message = this.getParamValue() as Message;
			if(m == null){
				existingObject.putNull(this.getParamName());
				throw new Error("The TextMessage param is null.");
			}
			tmObj.putInt("Id", m.getId());
			tmObj.putInt("Receiver", m.getRecipientId());
			tmObj.putUtfString("Subject", m.getSubject());
			tmObj.putUtfString("Body", m.getBody());
			tmObj.putInt("Unread", (m.getUnread()?1:0));
			tmObj.putInt("Deleted", (m.getDeleted()?1:0));
			existingObject.putSFSObject(this.getParamName(), tmObj);
			return existingObject;
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var tmObj:SFSObject = existingObject.getSFSObject(this.getParamName()) as SFSObject;
			var tm:Message = DataParamMessage.translateFromSFStoClass(tmObj);
			this.setParamValue(tm);
			return existingObject;
		}
		public static function translateFromSFStoClass(tmObj:SFSObject):Message{
			var tm:Message = new Message();
			tm.setId(tmObj.getInt("Id"));
			tm.setUnread((tmObj.getInt("Unread")==1));
			tm.setDeleted((tmObj.getInt("Deleted")==1));
			tm.setRecipientId(tmObj.getInt("Recipient"));
			tm.setSubject(tmObj.getUtfString("Subject"));
			tm.setBody(tmObj.getUtfString("Body"));
			tm.setTimestamp(tmObj.getLong("Timestamp"));
			return tm;
		}
	}
}
