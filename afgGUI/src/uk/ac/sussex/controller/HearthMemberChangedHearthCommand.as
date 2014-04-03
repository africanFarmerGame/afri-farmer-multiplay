package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.AnyChar;
	import uk.ac.sussex.view.HearthMemberListMediator;
	import uk.ac.sussex.model.HearthMembersListProxy;
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class HearthMemberChangedHearthCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("HearthMemberChangedHearthCommand sez: fired");
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var charId:int = incomingData.getParamValue(HomeHandlers.HMHC_CHAR) as int;
			var hearthId:int = incomingData.getParamValue(HomeHandlers.HMHC_HEARTH) as int;
			trace("HearthMemberChangedHearthCommand sez: I'm changing char " + charId + " to hearth " + hearthId);
			
			var hmlp:HearthMembersListProxy = facade.retrieveProxy(HearthMemberListMediator.NAME) as HearthMembersListProxy;
			var updatedMember:AnyChar = hmlp.getMember(charId);
			
			updatedMember.setHearthId(hearthId);
			//Now I need to update that in the list. 
			hmlp.updateMember(updatedMember);
			trace("HearthMemberChangedHearthCommand sez: I believe I am done now. ");
			
		}
	}
}
