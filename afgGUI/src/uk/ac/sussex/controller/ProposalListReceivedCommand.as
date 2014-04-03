package uk.ac.sussex.controller {
	import uk.ac.sussex.model.ProposalListProxy;
	import uk.ac.sussex.serverhandlers.VillageHandlers;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class ProposalListReceivedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("ProposalListReceivedCommand sez: I am firing on all cylinders. ");
			var incomingData:IncomingData = note.getBody() as IncomingData;
			//That should be a list of the proposals. 
			var proposals:Array = incomingData.getParamValue(VillageHandlers.PROPOSALS_LIST) as Array;
			if(proposals==null){
				throw new Error("I was rather anticipating having an array of proposals.");
			}
			var proposalsProxy:ProposalListProxy = facade.retrieveProxy(ProposalListProxy.NAME) as ProposalListProxy;
			proposalsProxy.addManyProposals(proposals);
		}
	}
}
