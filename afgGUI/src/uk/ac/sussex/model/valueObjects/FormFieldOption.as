package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class FormFieldOption {
		private var displayName:String;
		private var outputValue:String;
		private var type:String;
		private var status:int;
		private var notes:String;
		
		public static var VALID:int = 0;
		public static var INVALID:int = -1;
		
		public function FormFieldOption(displayName:String, outputValue:String){
			this.displayName = displayName;
			this.outputValue = outputValue;
		}
		public function getOutputValue():String {
			return this.outputValue;
		}
		public function getDisplayName():String {
			return this.displayName;
		}
		public function getType():String {
			return type;
		}
		public function setType(newType:String):void {
			this.type = newType;
		}
		public function getStatus():int {
			return status;
		}
		public function setStatus(newStatus:int):void {
			this.status = newStatus;
		}
		public function getNotes():String {
			return notes;
		}
		public function setNotes(newNotes:String):void {
			this.notes = newNotes;
		}
	}
}
