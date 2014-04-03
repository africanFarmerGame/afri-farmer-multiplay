/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import uk.ac.sussex.model.valueObjects.FormButton;
	import uk.ac.sussex.model.valueObjects.Form;
	import uk.ac.sussex.model.valueObjects.FormField;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class FormMC extends MovieClip {
		private var form:Form;
		private var nextY:uint;
		private var nextButtonX:uint;
		private var fields:Array;
		private var labelWidth:Number;
	
		private static const Y_OFFSET:uint = 10;
		private static const X_OFFSET:uint = 20;
		public static const DEFAULT_LABEL_WIDTH:Number = 200;
		
		public function FormMC(form:Form) {
			this.form = form;
			nextY = Y_OFFSET;
			nextButtonX = 0;
			labelWidth = DEFAULT_LABEL_WIDTH;
			setFormFields(form.getFormFields());
			setFormButtons(form.getFormButtons());
		}
		public function getFormData():Form {
			return form;
		}
 		public function updateFieldValue(formField:FormField):void{
			if(form==null){
 				throw new Error("No form set up for FormMC. Could be a problem but may just mean it isn't displayed yet.");
 			} else {
				if(formField.getFieldType()!=FormField.TYPE_BACKEND){
					var fieldName:String = formField.getFieldName();
					var field:GenericFormFieldMC = this.getField(fieldName);
					if(field!=null){ 	//Could happen, if that field isn't being displayed
						field.setFieldValue();
					}
				}
			}
 		}
 		public function setFieldEnabled(formField:FormField):void {
 			if(form==null){
 				throw new Error("No form set up for FormMC. Could be a problem.");
 			} else {
 				var fieldName:String = formField.getFieldName();
	 			for each(var field:GenericFormFieldMC in fields){
	 				if(field.getName()==fieldName){
	 					field.updateEnabled();
	 				}
	 			}
 			}
 		}
 		public function setLabelWidth(labelWidth:Number):void{
 			this.labelWidth = labelWidth;
			clearForm();
			setFormFields(form.getFormFields());
			setFormButtons(form.getFormButtons());
 		}
		public function updatePossibleFieldValues(formField:FormField):void {
			var fieldName:String = formField.getFieldName();
			switch(formField.getFieldType()){
				case FormField.TYPE_DROPDOWN:
					var dropdown:DropDownFormFieldMC = this.getField(fieldName) as DropDownFormFieldMC;
					if(dropdown!= null){
						dropdown.updateListOptions();
					}
					break;
			}
		}
		public function redrawForm():void{
			clearForm();
			setFormFields(form.getFormFields());
			setFormButtons(form.getFormButtons());
		}
		public function destroy():void {
			for each (var formField:GenericFormFieldMC in fields){
				formField.destroy();
			}
		}
 		private function clearForm():void {
 			var maxChildren:int = this.numChildren - 1;
 			for (var counter:int = maxChildren; counter>=0; counter--){
 				this.removeChildAt(counter); 
 			}
 			nextY = Y_OFFSET;
 			nextButtonX = 0;
 		}
		private function setFormFields(formFields:Array):void{
			
			var maxFields:uint = formFields.length;
			
			fields = new Array();
			for(var counter:uint = 0; counter < maxFields; counter++){
				var field:FormField = formFields[counter] as FormField;
				this.addFormField(field);	
			}
		}
		private function setFormButtons(formButtons:Array):void{
			var maxButtons:uint = formButtons.length;
			for (var counter:uint = 0; counter < maxButtons; counter++){
				var button:FormButton = formButtons[counter] as FormButton;
				this.addFormButton(button);
			}
		}
		private function addFormButton(button:FormButton):void {
			if(nextButtonX == 0){
				nextButtonX = this.width + X_OFFSET;
			}
			var gameButton:GameButton = new GameButton(button.getLabel());
			gameButton.y = nextY;
			gameButton.x = nextButtonX - gameButton.width - X_OFFSET;
			nextButtonX = gameButton.x;
			gameButton.name = button.getName();
			this.addChild(gameButton);
		}
		private function addFormField(field:FormField):void {
			if(field.show){
				var newField:GenericFormFieldMC;
				//Then add the right kind of input
				switch(field.getFieldType()){
					
					case FormField.TYPE_TEXTHIDDEN:
						newField = new TextFormFieldMC(field);
						break;
					case FormField.TYPE_TEXTINPUT:
						newField = new TextFormFieldMC(field);		
						break; 
					case FormField.TYPE_LABEL:
						newField = new LabelFormFieldMC(field);
						break;
					case FormField.TYPE_BACKEND:
						//I don't think I need to do anything with this. 
						break;
					case FormField.TYPE_RADIO:
						newField = new RadioFormFieldMC(field);
						break;
					case FormField.TYPE_DROPDOWN:
						newField = new DropDownFormFieldMC(field);
						break;
				}
			}
			if(newField!=null){
				addFormFieldMCToDisplay(newField);
				fields.push(newField);
			}
		}
		private function addFormFieldMCToDisplay(field:GenericFormFieldMC):void{
			field.setFieldValue();
			field.setFieldLabel();
			field.setLabelWidth(labelWidth);
			field.y = nextY;
			this.addChild(field);
			nextY = nextY + Y_OFFSET + field.height;
		}
		private function getField(fieldName:String):GenericFormFieldMC {
			for each(var field:GenericFormFieldMC in fields){
 				if(field.getName()==fieldName){
 					return field;
 				}
 			}
			return null;
		}
	}
}
