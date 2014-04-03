package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class FormButton {
		private var name:String;
		private var label:String;
		private var notification:String;
		private var submitFormData:Boolean;
		public function FormButton():void{
			
		}
		public function getName():String {
			return name;
		}
		public function setName(newName:String):void {
			name = newName;
		}
		public function getLabel():String {
			return label;
		}
		public function setLabel(newLabel:String):void {
			label = newLabel;
		}
		public function getNotification():String {
			return notification; 
		}
		public function setNotification(newNotification:String):void {
			notification = newNotification;
		}
		public function getSubmitFormData():Boolean {
			return submitFormData;
		}
		public function setSubmitFormData(submitFormData:Boolean):void {
			this.submitFormData = submitFormData;
		}
	}
}
