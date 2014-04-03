package uk.ac.sussex.controller {
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.HearthMembersListProxy;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class HearthMemberResurrectedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("HearthMemberResurrectedCommand sez: Hallelujah");
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var message:String = incomingData.getParamValue("Message") as String;
			var charId:int = incomingData.getParamValue("CharId") as int;
			
			var hearthMembersLP:HearthMembersListProxy = facade.retrieveProxy(HearthMembersListProxy.NAME) as HearthMembersListProxy;
			hearthMembersLP.resurrectMember(charId);
			sendNotification(ApplicationFacade.DISPLAY_MESSAGE, message);
		}
	}
}
