package uk.ac.sussex.controller {
	import uk.ac.sussex.model.ProposalListProxy;
	import uk.ac.sussex.serverhandlers.VillageHandlers;
	import uk.ac.sussex.model.valueObjects.Proposal;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class ProposalUpdatedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("ProposalUpdatedCommand sez: I have been executed");
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var proposal:Proposal = incomingData.getParamValue(VillageHandlers.PROPOSAL) as Proposal;
			var propListProxy:ProposalListProxy = facade.retrieveProxy(ProposalListProxy.NAME) as ProposalListProxy;
			if(propListProxy==null){
				throw new Error("ProposalListProxy was null when it shouldn't have been!");
			}
			propListProxy.addSingleProposal(proposal);
		}
	}
}
