package uk.ac.sussex.view {
	import flash.events.Event;
	import uk.ac.sussex.model.valueObjects.Field;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.view.components.FieldsDisplay;
	import uk.ac.sussex.model.FieldListProxy;
	import org.puremvc.as3.multicore.interfaces.*;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	/**
	 * @author em97
	 */
	public class FieldsMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "FIELDS_MEDIATOR";
		public static const X_POS:uint = 140;
		public static const Y_POS:uint = 10;
		
		private var fieldListProxy:FieldListProxy;
		
		public function FieldsMediator(viewComponent : Object = null) {
			super(NAME, viewComponent);
		}
		override public function listNotificationInterests():Array {
			return [FieldListProxy.FIELD_ADDED, 
					FieldListProxy.FIELD_UPDATED
					];
		}
		override public function handleNotification (note:INotification):void {
			switch (note.getName()){
				case FieldListProxy.FIELD_ADDED:
					var newField:Field = note.getBody() as Field;
					fieldsDisplay.addField(newField);
					sendNotification(ViewAreaMediator.REFRESH_VIEW_COMPONENT);
					break;
				case FieldListProxy.FIELD_UPDATED:
					var updatedField:Field = note.getBody() as Field;
					fieldsDisplay.updateField(updatedField);
					sendNotification(ViewAreaMediator.REFRESH_VIEW_COMPONENT);
					break;
			}
		}
		private function fieldSelected(e:Event):void {
			var field:Field = fieldsDisplay.getSelectedField();
			if(field!= null){
				var message:String = "Field Details: \n";
				message += "Name: " + field.getName() + "\n";
				if(field.getCrop() != null){
					message += "Crop: " + field.getCrop().getName() + "\n";
					message += "Crop Health: " + field.getCropHealth() + "% \n"; 
					message += "Crop Age: " + field.getCropAge() + " seasons \n";
					message += "Crop Planting: " + this.displayPlantingType(field.getCropPlanting()) + " \n";
					message += "Crop Weeded: " + (field.getWeeded()?"Yes":"No") + "\n";
				}
				//message += "Soil: " +  displaySoilQuality(field.getQuality()) + " \n";
				message += "Fertilizer: "; 
				if(field.getFertiliser()==null){
					message += "None \n";
				} else {
					message += field.getFertiliser().getName() + " \n";
				}
				message += "Pesticide: " + "None" + "\n"; //TODO Add the pesticide use here.
				message += displayHazard(field);
				sendNotification(ApplicationFacade.DISPLAY_TEMP_INFO_TEXT, message);
			}
		}
		private function fieldSelectionCleared(e:Event):void {
			sendNotification(ApplicationFacade.REVERT_TEMP_INFO_TEXT);
		}
		private function displayPlantingType(planting:int):String {
			switch(planting){
				case 0:
					return "Early";
					break;
				case 1: 
					return "Late";
					break;
			}
		}
		/*private function displaySoilQuality(soilLevel:int):String {
			switch(soilLevel){
				case 1: 
					return "Poor";
				case 2:
					return "Medium";
				case 3: 
					return "Good";
			}
		}*/
		private function displayHazard(field:Field):String {
			if(field.getHazard()!=null){
				var message:String = "Hazard: " + field.getHazard() + "\n";
				message += field.getHazardNotes() + "\n";
				message += "Crop health reduction: " + field.getFullReduction() + "\n";
				message += "Mitigated reduction: " + field.getMitigatedReduction() + "\n";
				return message;
			} else {
				return "";
			}	
		}
		protected function get fieldsDisplay():FieldsDisplay {
			return viewComponent as FieldsDisplay;
		}
		override public function onRegister():void {
			viewComponent = new FieldsDisplay();
			fieldsDisplay.x = X_POS;
			fieldsDisplay.y = Y_POS;
			fieldsDisplay.addEventListener(FieldsDisplay.FIELD_SELECTED, fieldSelected);
			fieldsDisplay.addEventListener(FieldsDisplay.FIELD_SELECTION_CLEARED, fieldSelectionCleared);
			fieldListProxy = facade.retrieveProxy(FieldListProxy.NAME) as FieldListProxy;
			sendNotification(ViewAreaMediator.ADD_VIEW_COMPONENT, fieldsDisplay);
		}
		override public function onRemove():void {
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, fieldsDisplay);
			fieldsDisplay.destroy();
		}
	}
}
