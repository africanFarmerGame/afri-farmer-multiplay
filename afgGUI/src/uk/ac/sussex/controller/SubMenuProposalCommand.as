package uk.ac.sussex.controller {
	import uk.ac.sussex.view.ProposalListMediator;
	import uk.ac.sussex.model.FormProxy;
	import uk.ac.sussex.view.FormMediator;
	import uk.ac.sussex.states.VillageGameState;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.serverhandlers.VillageHandlers;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	/**
	 * @author em97
	 */
	public class SubMenuProposalCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			
			var proposalFormMediator:FormMediator = facade.retrieveMediator(VillageHandlers.PROPOSAL_FORM) as FormMediator;
			if(proposalFormMediator != null){
				facade.removeMediator(VillageHandlers.PROPOSAL_FORM);
			}
			var propListMediator:ProposalListMediator = facade.retrieveMediator(ProposalListMediator.NAME) as ProposalListMediator;
			
			var subMenuItem:String = note.getBody() as String;
			switch(subMenuItem){
				case VillageHandlers.PROP_SUB_MENU_EXIT:
					sendNotification(ApplicationFacade.CHANGE_STATE, VillageGameState.NAME);
					break;
				case VillageHandlers.PROP_SUB_MENU_INCOMING:
					propListMediator.displayIncomingProposals();
					propListMediator.showList(true);
					sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, "Incoming proposals");
					break;
				case VillageHandlers.PROP_SUB_MENU_OUTGOING:
					propListMediator.displayOutgoingProposals();
					propListMediator.showList(true);
					sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, "Outgoing proposals");
					break;
				case VillageHandlers.PROP_SUB_MENU_PROPOSE:
					propListMediator.showList(false);
					var proposalFormProxy:FormProxy = facade.retrieveProxy(VillageHandlers.PROPOSAL_FORM) as FormProxy;
					proposalFormProxy.resetForm();
					proposalFormMediator = new FormMediator(VillageHandlers.PROPOSAL_FORM, null);
					facade.registerMediator(proposalFormMediator);
					
					proposalFormMediator.addToViewArea();
					
					sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, "Propose");
					break;
				default:
					throw new Error("Unknown proposal menu item");
			}
		}
	}
}
