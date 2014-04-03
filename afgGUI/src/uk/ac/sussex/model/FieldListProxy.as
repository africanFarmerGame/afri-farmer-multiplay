package uk.ac.sussex.model {
	import uk.ac.sussex.model.valueObjects.Field;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	/**
	 * @author em97
	 */
	public class FieldListProxy extends Proxy implements IProxy {
		public static const NAME:String = "FieldListProxy";
		public static const FIELD_ADDED:String = "FieldAdded";
		public static const FIELD_UPDATED:String = "FieldUpdated";
		
		public function FieldListProxy() {
			super(NAME, new Array());
		}
		public function addField(field:Field):void {
			var newFieldId:int = field.getId();
			var preexisting:Boolean = false;
			for each (var existingField:Field in fieldList){
				if(existingField.getId()==newFieldId){
					existingField = field;
					trace("FieldListProxy sez: field " + field.getId() + " has been matched.");
					trace("FieldListProxy sez: field crop is " + field.getCrop());
					preexisting = true;
					sendNotification(FIELD_UPDATED, field);
					break;
				}
			}
			if(!preexisting){
				fieldList.push(field);
				sendNotification(FIELD_ADDED, field);
			}
		}
		protected function get fieldList():Array {
			return data as Array;
		}
	}
}
