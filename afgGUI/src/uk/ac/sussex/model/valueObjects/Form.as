/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class Form {
		private var formFields:Array;
		private var formButtons:Array;
		private var nextFieldIndex:uint = 0;
		private var nextButtonIndex:uint = 0;
		private var formName:String;
	
		public function Form():void {
			formFields = new Array();
			formButtons = new Array();
		}
		public function getName():String{
			return this.formName;
		}
		public function setName(newName:String):void {
			this.formName = newName;
		}
		public function getFormFields():Array{
			return formFields;
		}
		public function getFormButtons():Array{
			return formButtons;
		}
		public function addFormField(newField:FormField):void {
			newField.setParent(this);
			formFields[nextFieldIndex] = newField;
			nextFieldIndex++;
		}
		public function addFormButton(newButton:FormButton):void {
			formButtons[nextButtonIndex] = newButton;
			nextButtonIndex ++;
		}
		public function setFieldValue(fieldName:String, fieldValue:String):void {
			var field:FormField = this.getField(fieldName);
			if(field != null){
				field.setFieldValue(fieldValue);
			}
		}
		public function getFieldValue(fieldName:String):String {
			var field:FormField = this.getField(fieldName);
			return field.getFieldValue();
		}
		public function setFieldEnabled(fieldName:String, enabled:Boolean):void {
			var field:FormField = this.getField(fieldName);
			field.setEnabled(enabled);
		}
		/** 
		 * This overwrites the possible field values for the field.
		 */
		public function updatePossibleFieldValues(fieldName:String, possibleValues:Array):void {
			var field:FormField = this.getField(fieldName);
			//Check the field type.
			var fieldType:String = field.getFieldType(); 
			if(fieldType==FormField.TYPE_RADIO || fieldType==FormField.TYPE_DROPDOWN){
				field.setPossibleValues(possibleValues);
			} else {
				throw new Error ("Field type " + fieldType + " doesn't support possible options");
			}
		}
		public function resetForm():void {
			for each (var field:FormField in formFields){
				field.resetValueToDefault();
			}
		}
		private function getField(fieldName:String):FormField{
			var counter:uint = 0;
			var field:FormField = null;
			while(field == null && counter < nextFieldIndex){
				var thisField:FormField = formFields[counter] as FormField;
				if(thisField.getFieldName() == fieldName){
					field = thisField;
				}
				counter++;
			}
			return field;
		}
	}
}
