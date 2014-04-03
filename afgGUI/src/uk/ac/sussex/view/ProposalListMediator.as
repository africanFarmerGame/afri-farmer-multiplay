package uk.ac.sussex.view {
	import uk.ac.sussex.model.valueObjects.Proposal;
	import flash.events.Event;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.view.components.ProposalList;
	import uk.ac.sussex.model.ProposalListProxy;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.interfaces.IMediator;

	/**
	 * @author em97
	 */
	public class ProposalListMediator extends Mediator implements IMediator {
		private var propListProxy:ProposalListProxy;
		public static const NAME:String = "ProposalListMediator";
		public static const UPDATED_PROPOSAL:String = "UpdatedProposal";
		
		private static const INCOMING:int = 0;
		private static const OUTGOING:int = 1;
		
		private var currentDisplay:int;
		
		public function ProposalListMediator() {
			super(NAME, null);
		}
		override public function listNotificationInterests():Array {
			return [ProposalListProxy.PROPOSAL_ADDED];
		}
		override public function handleNotification (note:INotification):void {
			switch (note.getName()){
				case ProposalListProxy.PROPOSAL_ADDED:
					trace("ProposalListMediator sez: Some proposals need displaying");
					switch(currentDisplay){
						case OUTGOING:
							break;
						case INCOMING:
						default:
							displayIncomingProposals();
							break;
					}
					break;
			}
		}
		public function showList(showList:Boolean):void{
			proposalListDisplay.clearSelection();
			if(showList){
				sendNotification(ViewAreaMediator.ADD_VIEW_COMPONENT, proposalListDisplay);
			} else {
				sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, proposalListDisplay);
			}
		}
		public function displayIncomingProposals():void {
			this.currentDisplay = INCOMING;
			var props:Array = propListProxy.fetchIncomingProposals();
			proposalListDisplay.displayProposals(props);
		}
		public function displayOutgoingProposals():void {
			this.currentDisplay = OUTGOING;
			var props:Array = propListProxy.fetchOutgoingProposals();
			proposalListDisplay.displayProposals(props);	
		}
		private function itemSelected(e:Event):void {
			switch(currentDisplay){
				case INCOMING: 	
					proposalListDisplay.showHideAcceptDecline(true);
					break;
				case OUTGOING:
					proposalListDisplay.showHideRetract(true);
					break;
			}
		}
		private function itemDeselected(e:Event):void {
			switch(currentDisplay){
				case INCOMING: 	
					proposalListDisplay.showHideAcceptDecline(false);
					break;
				case OUTGOING:
					proposalListDisplay.showHideRetract(false);
					break;
			}
		}
		private function propAccepted(e:Event):void {
			trace("ProposalListMediator sez: Proposal accepted");
			updateProposalStatus(Proposal.ACCEPTED);
		}
		private function propDeclined(e:Event):void {
			trace("ProposalLIstMediator sez: Proposal declined");
			updateProposalStatus(Proposal.DECLINED);
		}
		private function propRetracted(e:Event):void {
			updateProposalStatus(Proposal.RETRACTED);
		}
		private function updateProposalStatus(proposalStatus:int):void{
			trace("ProposalListMediator sez: setting proposal status to " + proposalStatus);
			var proposal:Proposal = proposalListDisplay.getSelectedProposal();
			proposal.setStatus(proposalStatus);
			sendNotification(UPDATED_PROPOSAL, proposal);
			proposalListDisplay.clearSelection();
		}
		protected function get proposalListDisplay():ProposalList {
			return viewComponent as ProposalList;
		}
		override public function onRegister():void {
			viewComponent = new ProposalList();
			var submenu:SubMenuMediator = facade.retrieveMediator(SubMenuMediator.NAME) as SubMenuMediator;
			
			proposalListDisplay.x = submenu.getSubmenuWidth();
			proposalListDisplay.y = 10;
			proposalListDisplay.addEventListener(ProposalList.PROP_ITEM_SELECTED, itemSelected);
			proposalListDisplay.addEventListener(ProposalList.PROP_ITEM_DESELECTED, itemDeselected);
			proposalListDisplay.addEventListener(ProposalList.ACCEPT_CLICKED, propAccepted);
			proposalListDisplay.addEventListener(ProposalList.DECLINE_CLICKED, propDeclined);
			proposalListDisplay.addEventListener(ProposalList.RETRACT_CLICKED, propRetracted);
			
			propListProxy = facade.retrieveProxy(ProposalListProxy.NAME) as ProposalListProxy;
			sendNotification(ViewAreaMediator.ADD_VIEW_COMPONENT, proposalListDisplay);
		}
		override public function onRemove():void {
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, proposalListDisplay);
			proposalListDisplay.removeEventListener(ProposalList.PROP_ITEM_SELECTED, itemSelected);
			proposalListDisplay.removeEventListener(ProposalList.PROP_ITEM_DESELECTED, itemDeselected);
			proposalListDisplay.removeEventListener(ProposalList.ACCEPT_CLICKED, propAccepted);
			proposalListDisplay.removeEventListener(ProposalList.DECLINE_CLICKED, propDeclined);
			proposalListDisplay.removeEventListener(ProposalList.RETRACT_CLICKED, propRetracted);
		}
	}
}
