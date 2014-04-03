package uk.ac.sussex.controller {
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.serverhandlers.VillageHandlers;
	import uk.ac.sussex.model.valueObjects.Proposal;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class UpdateProposalCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var updatedProposal:Proposal = note.getBody() as Proposal;
			if(updatedProposal==null){
				throw new Error ("We have no proposal to update!");
			}
			var sendProxy:RequestProxy = facade.retrieveProxy(VillageHandlers.UPDATE_PROPOSAL + RequestProxy.NAME) as RequestProxy;
			sendProxy.setParamValue(VillageHandlers.PROPOSAL, updatedProposal);
			sendProxy.sendRequest();
		}
	}
}
