package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.Form;
	import uk.ac.sussex.model.valueObjects.FormFieldOption;
	import uk.ac.sussex.model.valueObjects.AnyChar;
	import uk.ac.sussex.model.valueObjects.FormField;
	import uk.ac.sussex.model.HearthMembersListProxy;
	import uk.ac.sussex.serverhandlers.VillageHandlers;
	import uk.ac.sussex.model.FormProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class ResHearthUpdatedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("ResHearthUpdatedCommand sez: Does this hearth have dead?");
			var formProxy:FormProxy = facade.retrieveProxy(VillageHandlers.RES_FORM) as FormProxy;
			var form:Form = formProxy.getForm();
			formProxy.updateFieldValue(VillageHandlers.RES_FORM_DEAD, null);
			var hearthField:FormField = note.getBody() as FormField;
			var hearthMembersLP:HearthMembersListProxy = facade.retrieveProxy(HearthMembersListProxy.NAME) as HearthMembersListProxy;
			if(hearthMembersLP!=null && hearthField!=null){
				var hearthString:String = hearthField.getFieldValue();
				var hearthId:int = int(hearthString);
				var deadMembers:Array = hearthMembersLP.getDeadMembers(hearthId);
				if(deadMembers.length>0){
					var deadOptions:Array = new Array();
					for each (var dead:AnyChar in deadMembers){
						 deadOptions.push(new FormFieldOption(dead.getFirstName() + " " + dead.getFamilyName(), dead.getId().toString()));
					}
					
					form.updatePossibleFieldValues(VillageHandlers.RES_FORM_DEAD, deadOptions);
				}
			}
		}
	}
}