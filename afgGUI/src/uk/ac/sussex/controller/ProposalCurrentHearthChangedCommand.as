package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.Hearth;
	import uk.ac.sussex.model.HearthListProxy;
	import uk.ac.sussex.model.PlayerCharProxy;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.valueObjects.FormFieldOption;
	import uk.ac.sussex.model.valueObjects.AnyChar;
	import uk.ac.sussex.model.valueObjects.Form;
	import uk.ac.sussex.model.FormProxy;
	import uk.ac.sussex.serverhandlers.VillageHandlers;
	import uk.ac.sussex.model.VillageMembersListProxy;
	import uk.ac.sussex.model.valueObjects.FormField;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class ProposalCurrentHearthChangedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("ProposalCurrentHearthChangedCommand sez: My name is too long.");
			var currentHearthField:FormField = note.getBody() as FormField;
			var hearthId:int = int(currentHearthField.getFieldValue());
			var myChar:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;
			var myHearthId:int = myChar.getPCHearthId();
			var myId:int = myChar.getPlayerId();
			
			var vmlp:VillageMembersListProxy = facade.retrieveProxy(VillageMembersListProxy.NAME) as VillageMembersListProxy;
			var allMembers:Array; 
			if(hearthId>0){
				var hearthPCMembers:Array = vmlp.getHearthPCs(hearthId);
				var hearthNPCMembers:Array = vmlp.getHearthNPCs(hearthId);
				allMembers = hearthPCMembers.concat(hearthNPCMembers);
			} else {
				allMembers = vmlp.getHearthlessPCs();
			}
			var memberOptions:Array = new Array();
			if(myHearthId>0){
				for each (var character:AnyChar in allMembers){
					var fieldOption:FormFieldOption;
					if(character.getId() == myId){
						fieldOption = new FormFieldOption("You", myId.toString());
					} else {
						fieldOption = new FormFieldOption(character.getFirstName() + " " + character.getFamilyName(), character.getId().toString());
					}
					memberOptions.push(fieldOption);
				}
			} else {
				memberOptions.push(new FormFieldOption("You", myId.toString()));
			}
			
			var proposalFormProxy:FormProxy = facade.retrieveProxy(VillageHandlers.PROPOSAL_FORM) as FormProxy;
			var propForm:Form = proposalFormProxy.getForm();
			propForm.setFieldValue(VillageHandlers.PROPOSAL_FORM_TARGET, null);
			propForm.updatePossibleFieldValues(VillageHandlers.PROPOSAL_FORM_TARGET, memberOptions);
			
			
			var targetHearthOptions:Array = new Array();
			if(hearthId!=myHearthId){
				var hearthOption1:FormFieldOption = new FormFieldOption("Our household", myHearthId.toString());
				targetHearthOptions.push(hearthOption1);
				propForm.updatePossibleFieldValues(VillageHandlers.PROPOSAL_FORM_JOIN_HEARTH, targetHearthOptions);
				propForm.setFieldValue(VillageHandlers.PROPOSAL_FORM_JOIN_HEARTH, myHearthId.toString());
				propForm.setFieldEnabled(VillageHandlers.PROPOSAL_FORM_JOIN_HEARTH, false);
			} else {
				var hearthLP:HearthListProxy = facade.retrieveProxy(HearthListProxy.NAME) as HearthListProxy;
				var hearthList:Array = hearthLP.getHearths();
				for each (var hearth:Hearth in hearthList){
					if(hearth.getId()!=myHearthId){
						var hearthOption:FormFieldOption = new FormFieldOption(hearth.getHearthName(), hearth.getId().toString());
						targetHearthOptions.push(hearthOption);
					}
				}
				propForm.updatePossibleFieldValues(VillageHandlers.PROPOSAL_FORM_JOIN_HEARTH, targetHearthOptions);
				propForm.setFieldValue(VillageHandlers.PROPOSAL_FORM_JOIN_HEARTH, null);
				propForm.setFieldEnabled(VillageHandlers.PROPOSAL_FORM_JOIN_HEARTH, true);
			}
			
		}
	}
}
