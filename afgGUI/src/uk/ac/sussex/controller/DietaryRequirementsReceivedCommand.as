package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.AnyChar;
	import uk.ac.sussex.model.*;
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class DietaryRequirementsReceivedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var dietaryRequirements:Array = incomingData.getParamValue(HomeHandlers.DIETARY_REQUIREMENTS) as Array;
			var dietaryReqsProxy:DietaryRequirementsProxy = facade.retrieveProxy(DietaryRequirementsProxy.NAME) as DietaryRequirementsProxy;
			if(dietaryReqsProxy == null){
				dietaryReqsProxy = new DietaryRequirementsProxy();
				facade.registerProxy(dietaryReqsProxy);
			}
			facade.removeProxy(HomeHandlers.GET_DIETARY_REQS + RequestProxy.NAME);
			facade.removeProxy(HomeHandlers.DIETARY_REQUIREMENTS + IncomingDataProxy.NAME);
			facade.removeCommand(HomeHandlers.DIETARY_REQUIREMENTS);
			
			dietaryReqsProxy.addRequirements(dietaryRequirements);
			
			//Let's add them to the hearth members if we need to. 
			var hearthMemberLP:HearthMembersListProxy = facade.retrieveProxy(HearthMembersListProxy.NAME) as HearthMembersListProxy;
			if(hearthMemberLP != null){
				var members:Array = hearthMemberLP.getMembers();
				for each (var member:AnyChar in members){
					member.setDietaryReqs(dietaryReqsProxy.getTargetRequirements(member.getDietTarget()));
				}
			}
		}
	}
}
