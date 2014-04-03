﻿/**This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	**/package uk.ac.sussex.model {	import flash.events.Event;	import uk.ac.sussex.model.valueObjects.FormButton;	import uk.ac.sussex.model.valueObjects.Form;	import uk.ac.sussex.model.valueObjects.FormField;	import uk.ac.sussex.model.valueObjects.FormFieldOption;	import org.puremvc.as3.multicore.interfaces.IProxy;	import org.puremvc.as3.multicore.patterns.proxy.Proxy;	/**	 * @author em97	 */	public class FormProxy extends Proxy implements IProxy {		 		/**		 * These constants are used to send notifications to the corresponding FormMediator.		 * If a notification is sent, it must either have a field attached or the name of this		 * formProxy, to tell the formMediator it is the right one.		 */		public static const FORM_FIELD_ERROR:String = "FormFieldError";		public static const FORM_FIELD_VALUE_CHANGED:String = "FormFieldValueChanged";		public static const FORM_FIELD_ENABLED_CHANGED:String = "FormFieldEnabledChanged";		public static const FORM_FIELD_OPTIONS_UPDATED:String = "FormFieldOptionsUpdated";		public static const FORM_LAYOUT_CHANGED:String = "FormLayoutChanged";				public function FormProxy(proxyName : String) {			super(proxyName, new Form());			form.setName(proxyName);		}		public function addTextField(fieldName:String, fieldLabel:String, optional:Boolean = false, allowedChars:String = null, maxLength:int = 0, changeNotification:String = null):void{			var formField:FormField = new FormField();			formField.setFieldName(fieldName);			formField.setFieldLabel(fieldLabel);			formField.setFieldType(FormField.TYPE_TEXTINPUT);			formField.setOptional(optional);			formField.setAllowedChars(allowedChars);			formField.setMaxLength(maxLength);			formField.setChangeNotification(changeNotification);			this.addFieldEventListeners(formField);			form.addFormField(formField);		}		public function addHiddenTextField(fieldName:String, fieldLabel:String, optional:Boolean = false, changeNotification:String = null):void {			var formField:FormField = new FormField();			formField.setFieldName(fieldName);			formField.setFieldLabel(fieldLabel);			formField.setFieldType(FormField.TYPE_TEXTHIDDEN);			formField.setOptional(optional);			formField.setChangeNotification(changeNotification);			this.addFieldEventListeners(formField);			form.addFormField(formField);		}		public function addButton(buttonName:String, notification:String, submitFormData:Boolean = true ):void{			var formButton:FormButton = new FormButton();			formButton.setName(buttonName);			formButton.setLabel(buttonName);			formButton.setNotification(notification);			formButton.setSubmitFormData(submitFormData);			form.addFormButton(formButton);		}		/**		 * Displays a field value in a readonly text box. 		 * @param fieldName - The name of the field for reference		 * @param fieldLabel - The displayed label of the field		 */		public function addDisplayText(fieldName:String, fieldLabel:String, fieldValue:String = ""):void{			var formField:FormField = new FormField();			formField.setFieldName(fieldName);			formField.setFieldLabel(fieldLabel);			formField.setFieldType(FormField.TYPE_LABEL);			formField.setOptional(true);			formField.setFieldValue(fieldValue);			this.addFieldEventListeners(formField);			form.addFormField(formField);		}		public function addBackendData(fieldName:String, changeNotification:String = null):void{			var formField:FormField = new FormField();			formField.setFieldName(fieldName);			formField.setFieldLabel("This should be hidden");			formField.setFieldType(FormField.TYPE_BACKEND);			formField.setChangeNotification(changeNotification);			this.addFieldEventListeners(formField);			form.addFormField(formField);		}		public function addRadioButton(fieldName:String, fieldLabel:String, values:Array, defaultValue:FormFieldOption = null, optional:Boolean = false, changeNotification:String = null):void{			var formField:FormField = new FormField();			formField.setFieldName(fieldName);			formField.setFieldLabel(fieldLabel);			formField.setFieldType(FormField.TYPE_RADIO);			formField.setOptional(optional);			formField.setPossibleValues(values);			formField.setChangeNotification(changeNotification);			this.addFieldEventListeners(formField);			if(defaultValue != null) {				formField.setDefaultValue(defaultValue.getOutputValue());			}			form.addFormField(formField);		}		public function addDropDown(fieldName:String, fieldLabel:String, values:Array=null, defaultValue:FormFieldOption = null, optional:Boolean = false, changeNotification:String = null):void {			var formField:FormField = new FormField();			formField.setFieldName(fieldName);			formField.setFieldLabel(fieldLabel);			formField.setFieldType(FormField.TYPE_DROPDOWN);			formField.setOptional(optional);			formField.setPossibleValues(values);			formField.setChangeNotification(changeNotification);			this.addFieldEventListeners(formField);			if(defaultValue != null){				formField.setDefaultValue(defaultValue.getOutputValue());			}			form.addFormField(formField);		}		public function updateDropDownOptions(newValues:Array):void {			//TODO: implement this			throw new Error("This hasn't been implemented yet.");		}		/**		 * @param fieldName There is no protection against duplicate fieldnames, so take care!		 * @param fieldValue		 */		public function updateFieldValue(fieldName:String, fieldValue:String):void{			//TODO This needs more work. Not sure when to check validation or send errors.			//Search through the array to find the matching name.			var formField:FormField = this.retrieveField(fieldName);			//Then update the value.			if(formField != null){				formField.setFieldValue(fieldValue);			}		}		public function retrieveFieldValue(fieldName:String):String {			var formField:FormField = this.retrieveField(fieldName);			if(formField != null){				return formField.getFieldValue();			}		}		public function getForm():Form {			return form;		}		public function getFormButton(buttonName:String):FormButton{			var formButtons:Array = form.getFormButtons();			var maxButtons:uint = formButtons.length;			var counter:uint = 0;			var formButton:FormButton = null;			while(formButton == null && counter < maxButtons){				var thisButton:FormButton = formButtons[counter] as FormButton;				if(thisButton.getName() == buttonName){					formButton = thisButton;				}				counter++;			}			return formButton;					}		public function getFormFields():Array{			return form.getFormFields();		}		/**		 * This resets all of the fields in the form to their default values. 		 * It does not wipe the possible values. 		 */		public function resetForm():void {			form.resetForm();		}		/**		 * This takes two arrays of fields, because I mostly want to show and hide fields at the same time. 		 * e.g. if one field value changes I want to hide one of the fields below and show a different one.		 * Fields not in either array will not be affected.  		 * @param hideFields - names of fields to be hidden.		 * @param showFields - names of fields to show. 		 */		public function showHideFields(hideFields:Array, showFields:Array):void {			for each (var hiddenField:String in hideFields){				var hideFormField:FormField = retrieveField(hiddenField);				hideFormField.show = false;			}			for each (var showingField:String in showFields){				var showFormField:FormField = retrieveField(showingField);				showFormField.show = true;			}			sendNotification(FORM_LAYOUT_CHANGED, this.proxyName);		}		private function addFieldEventListeners(field:FormField):void {			field.addEventListener(FormField.VALUE_CHANGED, fieldValueChanged);			field.addEventListener(FormField.ENABLED_CHANGED, enabledChanged);			field.addEventListener(FormField.OPTIONS_UPDATED, fieldOptionsUpdated);		}		private function fieldValueChanged(e:Event):void {			var field:FormField = e.target as FormField;			if(field.getFieldError()){				sendNotification(FORM_FIELD_ERROR, field);			}			//field.notifyObservers();			var notification:String = field.getChangeNotification();			if(notification!=null && notification!=""){					sendNotification(notification, field);			}			sendNotification(FORM_FIELD_VALUE_CHANGED, field);		}		private function enabledChanged(e:Event):void {			var field:FormField = e.target as FormField;			if(field != null){				sendNotification(FORM_FIELD_ENABLED_CHANGED, field);			}		}		private function fieldOptionsUpdated(e:Event):void{			var field:FormField = e.target as FormField;			if(field != null){				sendNotification(FORM_FIELD_OPTIONS_UPDATED, field);			}		}		private function retrieveField(fieldName:String):FormField{			var formFields:Array = form.getFormFields();			var maxFieldValue:uint = formFields.length;			var counter:uint = 0;			var formField:FormField = null;			while(formField == null && counter < maxFieldValue){				var thisField:FormField = formFields[counter] as FormField;				if(thisField.getFieldName() == fieldName){					formField = thisField;				}				counter++;			}			return formField;		}		protected function get form():Form{			return data as Form;		}	}}