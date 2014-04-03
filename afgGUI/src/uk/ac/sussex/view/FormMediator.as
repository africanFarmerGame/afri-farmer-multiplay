/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view {
	import uk.ac.sussex.view.components.ScrollingList;
	import uk.ac.sussex.view.components.DropDownFormFieldMC;
	import uk.ac.sussex.model.valueObjects.FormField;
	import uk.ac.sussex.model.valueObjects.FormButton;
	import flash.events.Event;
	import uk.ac.sussex.view.components.GameButton;
	import uk.ac.sussex.model.FormProxy;
	import uk.ac.sussex.view.components.FormMC;
	import uk.ac.sussex.general.ApplicationFacade;
	import org.puremvc.as3.multicore.interfaces.*;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	/**
	 * @author em97
	 */
	public class FormMediator extends Mediator implements IMediator {
		private var myFormProxy:FormProxy;
		private var formLabelWidth:Number;
		
		public function FormMediator(name:String, viewComponent:Object):void {
			// constructor code
			super(name, viewComponent);
		}

		override public function listNotificationInterests():Array {
			return [FormProxy.FORM_FIELD_VALUE_CHANGED, 
					FormProxy.FORM_FIELD_ENABLED_CHANGED,
					FormProxy.FORM_FIELD_OPTIONS_UPDATED, 
					FormProxy.FORM_LAYOUT_CHANGED];
		}
		
		override public function handleNotification (note:INotification):void {
			var field:FormField = note.getBody() as FormField;
			var formProxyName:String;
			if(field==null){
				formProxyName = note.getBody() as String;
			} else {
				formProxyName = field.getParent().getName(); 
			}
			if(formProxyName == formProxy.getProxyName()){
				switch(note.getName()){
					case FormProxy.FORM_FIELD_VALUE_CHANGED:
						form.updateFieldValue(field);
						break;
					case FormProxy.FORM_FIELD_ENABLED_CHANGED:
						form.setFieldEnabled(field);
						break;
					case FormProxy.FORM_FIELD_OPTIONS_UPDATED:
						form.updatePossibleFieldValues(field);
						break;
					case FormProxy.FORM_LAYOUT_CHANGED:
						form.redrawForm();
						break;
				}
			}
		}
		
		public function addToMainScreen(xpos:Number, ypos:Number):void{
			//now we need to build our view component from the data on this proxy.
			form.x = xpos;
			form.y = ypos; 
			sendNotification(ApplicationFacade.ADD_TO_SCREEN, form);
		}
		public function addToOverlay():void{
			//now we need to build our view component from the data on this proxy. 
			//form.displayForm();
			
			sendNotification(ApplicationFacade.DISPLAY_OVERLAY_FORM, form);
		}
		public function addToViewArea():void{
			var subMenu:SubMenuMediator = facade.retrieveMediator(SubMenuMediator.NAME) as SubMenuMediator;
			//form.displayForm();
			form.x = subMenu.getSubmenuWidth();
			
			sendNotification(ViewAreaMediator.ADD_VIEW_COMPONENT, form);
		}
		public function hideForm():void{
			if(form.parent != null){
				sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, form);
			}
		}
		public function setLabelWidth(labelWidth:Number):void{
			//Somehow the form is occasionally null when this is called.
			if(form==null){
				//If that is the case, store the required labelwidth to use when the form is instantiated.
				this.formLabelWidth = labelWidth;
			} else {
				form.setLabelWidth(labelWidth);
			}
		}
		private function formButtonClicked(e:Event):void{
			var clicked:GameButton = e.target as GameButton;
			var buttonName:String = clicked.name;
			var button:FormButton = formProxy.getFormButton(buttonName);
			if(button != null){
				if(button.getSubmitFormData()){
					sendNotification(button.getNotification(), form.getFormData()); 
				} else {
					sendNotification(button.getNotification());
				}
			}
		}
		private function displayDropDown(e:Event):void{
			var dropDown:DropDownFormFieldMC = e.target as DropDownFormFieldMC;
			var list:ScrollingList = dropDown.fetchScrollingList();
			sendNotification(ApplicationFacade.FLOAT_UI_ITEM, list);
		}
		private function hideDropDown(e:Event):void {
			sendNotification(ApplicationFacade.CLEAR_DRAGLAYER);
		}
		//Cast the viewComponent to the correct type.
		public function get form():FormMC {
			return viewComponent as FormMC;
		}
		private function get formProxy():FormProxy {
			if(myFormProxy==null){
				myFormProxy = facade.retrieveProxy(this.mediatorName) as FormProxy;
				if(myFormProxy==null){
					throw new Error("The form Proxy is not defined for form " + this.getMediatorName());
				}
			}
			return myFormProxy;
		}
		override public function onRegister():void
		{
			viewComponent = new FormMC(formProxy.getForm());
			var labelWidth:Number;
			if(formLabelWidth==null || formLabelWidth==0){
				labelWidth = FormMC.DEFAULT_LABEL_WIDTH;
			} else {
				labelWidth = formLabelWidth;
			}
			form.setLabelWidth(labelWidth);
			
			form.addEventListener(GameButton.BUTTON_CLICK, formButtonClicked);
			form.addEventListener(DropDownFormFieldMC.DISPLAY_LIST, displayDropDown);
			form.addEventListener(DropDownFormFieldMC.HIDE_LIST, hideDropDown);
		}
		override public function onRemove():void
		{
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, form);
			sendNotification(ApplicationFacade.CLEAR_DRAGLAYER); //Just in case they were displaying the dropdown. 
			form.removeEventListener(GameButton.BUTTON_CLICK, formButtonClicked);
			form.removeEventListener(DropDownFormFieldMC.DISPLAY_LIST, displayDropDown);
			form.removeEventListener(DropDownFormFieldMC.HIDE_LIST, hideDropDown);
			form.destroy();
		}	
	}
}
