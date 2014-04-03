package uk.ac.sussex.states {
	import uk.ac.sussex.model.SubMenuListProxy;
	import uk.ac.sussex.controller.UpdateProposalCommand;
	import uk.ac.sussex.controller.ProposalUpdatedCommand;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamProposal;
	import uk.ac.sussex.view.ProposalListMediator;
	import uk.ac.sussex.controller.ProposalListReceivedCommand;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArrayProposal;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.PlayerCharProxy;
	import uk.ac.sussex.model.ProposalListProxy;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamInt;
	import uk.ac.sussex.controller.SubmitProposalCommand;
	import uk.ac.sussex.controller.CancelProposalForm;
	import uk.ac.sussex.controller.ProposalCurrentHearthChangedCommand;
	import uk.ac.sussex.model.FormProxy;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArrayPlayerChar;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArrayHearthMember;
	import uk.ac.sussex.model.VillageMembersListProxy;
	import uk.ac.sussex.model.HearthListProxy;
	import uk.ac.sussex.controller.VillageMembersReceivedCommand;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArrayHearth;
	import uk.ac.sussex.model.IncomingDataProxy;
	import uk.ac.sussex.model.IncomingDataErrorProxy;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.controller.SubMenuProposalCommand;
	import uk.ac.sussex.serverhandlers.VillageHandlers;
	import uk.ac.sussex.view.SubMenuMediator;
	
	import org.puremvc.as3.multicore.interfaces.IFacade;

	/**
	 * @author em97
	 */
	public class ProposalGameState extends PlayerRoomState implements IGameState  {
		public static const NAME:String = "ProposalGameState";
		private static const DISPLAY_TITLE:String = "Proposals";
	
		public function ProposalGameState(facade : IFacade) {
			super(facade, NAME, DISPLAY_TITLE);
		}
		
		override public function displayState() : void {
			super.displayState();
			this.registerProxies();
			this.registerCommands();
			this.registerMediators();
		}
		override public function cleanUpState() : void {
			this.removeMediators();
			this.removeCommands();
			this.removeProxies();
			super.cleanUpState();
		}
		override public function refresh():void {
			super.refresh();
		}
		private function registerProxies():void {
			var villageMembersRequest:RequestProxy = new RequestProxy(VillageHandlers.FETCH_VILLAGE_MEMBERS);
			facade.registerProxy(villageMembersRequest);
			villageMembersRequest.sendRequest();
			
			facade.registerProxy(new IncomingDataErrorProxy(VillageHandlers.FETCH_VILLAGE_MEMBERS_ERROR));
			
			var incomingVillageMembers:IncomingDataProxy = new IncomingDataProxy(VillageHandlers.VILLAGE_MEMBERS_RECEIVED, VillageHandlers.VILLAGE_MEMBERS_RECEIVED);
			incomingVillageMembers.addDataParam(new DataParamArrayHearth(VillageHandlers.VILLAGE_MEMBERS_HEARTHS));
			incomingVillageMembers.addDataParam(new DataParamArrayPlayerChar(VillageHandlers.VILLAGE_MEMBERS_PCS));
			incomingVillageMembers.addDataParam(new DataParamArrayHearthMember(VillageHandlers.VILLAGE_MEMBERS_NPCS));
			facade.registerProxy(incomingVillageMembers);
			
			facade.registerProxy(new IncomingDataErrorProxy(VillageHandlers.VILLAGE_ERROR));
			
			facade.registerProxy(new HearthListProxy());
			facade.registerProxy(new VillageMembersListProxy());
			
			var proposalFormProxy:FormProxy = new FormProxy(VillageHandlers.PROPOSAL_FORM);
			facade.registerProxy(proposalFormProxy);
			proposalFormProxy.addBackendData(VillageHandlers.PROPOSAL_FORM_PROPOSER);
			proposalFormProxy.addDropDown(VillageHandlers.PROPOSAL_FORM_CURRENT_HEARTH, "Current Household:", null, null, false, VillageHandlers.PROPOSAL_CURRENT_HEARTH_UPDATED);
			proposalFormProxy.addDropDown(VillageHandlers.PROPOSAL_FORM_TARGET, "Person: ");
			proposalFormProxy.addDropDown(VillageHandlers.PROPOSAL_FORM_JOIN_HEARTH, "Proposed Household:");
			proposalFormProxy.addButton("Submit Proposal", VillageHandlers.PROPOSAL_FORM_SUBMIT);
			proposalFormProxy.addButton("Cancel", VillageHandlers.PROPOSAL_FORM_CANCEL);
			
			var submitProposalProxy:RequestProxy = new RequestProxy(VillageHandlers.SUBMIT_PROPOSAL);
			submitProposalProxy.addRequestParam(new DataParamInt(VillageHandlers.PROPOSAL_FORM_PROPOSER));
			submitProposalProxy.addRequestParam(new DataParamInt(VillageHandlers.PROPOSAL_FORM_PROPOSER_HEARTH));
			submitProposalProxy.addRequestParam(new DataParamInt(VillageHandlers.PROPOSAL_FORM_TARGET));
			submitProposalProxy.addRequestParam(new DataParamInt(VillageHandlers.PROPOSAL_FORM_JOIN_HEARTH));
			facade.registerProxy(submitProposalProxy);
			
			var myChar:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;
			var hearthId:int = myChar.getPCHearthId();
			facade.registerProxy(new ProposalListProxy(hearthId));
			
			var propRequest:RequestProxy = new RequestProxy(VillageHandlers.PROPOSAL_REQUEST);
			facade.registerProxy(propRequest);
			propRequest.sendRequest();
			facade.registerProxy(new IncomingDataErrorProxy(VillageHandlers.PROPOSAL_REQUEST_ERROR));
			var incomingProposals:IncomingDataProxy = new IncomingDataProxy(VillageHandlers.PROPOSALS_RECEIVED, VillageHandlers.PROPOSALS_RECEIVED);
			incomingProposals.addDataParam(new DataParamArrayProposal(VillageHandlers.PROPOSALS_LIST));
			facade.registerProxy(incomingProposals);
			
			var updatedProposal:IncomingDataProxy = new IncomingDataProxy(VillageHandlers.PROPOSAL_UPDATED, VillageHandlers.PROPOSAL_UPDATED);
			updatedProposal.addDataParam(new DataParamProposal(VillageHandlers.PROPOSAL));
			facade.registerProxy(updatedProposal);
			
			var saveUpdatedProposal:RequestProxy = new RequestProxy(VillageHandlers.UPDATE_PROPOSAL);
			saveUpdatedProposal.addRequestParam(new DataParamProposal(VillageHandlers.PROPOSAL));
			facade.registerProxy(saveUpdatedProposal);
			
			var subMenuProxy:SubMenuListProxy = new SubMenuListProxy();
			facade.registerProxy(subMenuProxy);
			subMenuProxy.addSubMenuItem(VillageHandlers.PROP_SUB_MENU_INCOMING);
			subMenuProxy.addSubMenuItem(VillageHandlers.PROP_SUB_MENU_OUTGOING);
			subMenuProxy.addSubMenuItem(VillageHandlers.PROP_SUB_MENU_PROPOSE);
			subMenuProxy.addSubMenuItem(VillageHandlers.PROP_SUB_MENU_EXIT);
			subMenuProxy.setDefaultMenuItem(VillageHandlers.PROP_SUB_MENU_INCOMING);
		}
		private function removeProxies():void {
			facade.removeProxy(VillageHandlers.FETCH_VILLAGE_MEMBERS + RequestProxy.NAME);
			facade.removeProxy(VillageHandlers.FETCH_VILLAGE_MEMBERS_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(VillageHandlers.VILLAGE_MEMBERS_RECEIVED + IncomingDataProxy.NAME);
			facade.removeProxy(VillageHandlers.VILLAGE_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(VillageHandlers.PROPOSAL_FORM);
			facade.removeProxy(VillageHandlers.SUBMIT_PROPOSAL + RequestProxy.NAME);
			facade.removeProxy(ProposalListProxy.NAME);
			facade.removeProxy(VillageHandlers.PROPOSAL_REQUEST + RequestProxy.NAME);
			facade.removeProxy(VillageHandlers.PROPOSAL_REQUEST_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(VillageHandlers.PROPOSALS_RECEIVED + IncomingDataProxy.NAME);
			facade.removeProxy(VillageHandlers.PROPOSAL_UPDATED + IncomingDataProxy.NAME);
			facade.removeProxy(VillageHandlers.UPDATE_PROPOSAL + RequestProxy.NAME);
			facade.removeProxy(SubMenuListProxy.NAME);
		}
		private function registerCommands():void {
			facade.registerCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED, SubMenuProposalCommand);
			facade.registerCommand(VillageHandlers.VILLAGE_MEMBERS_RECEIVED, VillageMembersReceivedCommand);
			facade.registerCommand(VillageHandlers.PROPOSAL_CURRENT_HEARTH_UPDATED, ProposalCurrentHearthChangedCommand);
			facade.registerCommand(VillageHandlers.PROPOSAL_FORM_CANCEL, CancelProposalForm);
			facade.registerCommand(VillageHandlers.PROPOSAL_FORM_SUBMIT, SubmitProposalCommand);
			facade.registerCommand(VillageHandlers.PROPOSALS_RECEIVED, ProposalListReceivedCommand);
			facade.registerCommand(VillageHandlers.PROPOSAL_UPDATED, ProposalUpdatedCommand);
			facade.registerCommand(ProposalListMediator.UPDATED_PROPOSAL, UpdateProposalCommand);
		}
		private function removeCommands():void {
			facade.removeCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED);
			facade.removeCommand(VillageHandlers.VILLAGE_MEMBERS_RECEIVED);
			facade.removeCommand(VillageHandlers.PROPOSAL_CURRENT_HEARTH_UPDATED);
			facade.removeCommand(VillageHandlers.PROPOSAL_FORM_CANCEL);
			facade.removeCommand(VillageHandlers.PROPOSAL_FORM_SUBMIT);
			facade.removeCommand(VillageHandlers.PROPOSALS_RECEIVED);
			facade.removeCommand(VillageHandlers.PROPOSAL_UPDATED);
			facade.removeCommand(ProposalListMediator.UPDATED_PROPOSAL);
		}
		private function registerMediators():void {
			var submenuMediator:SubMenuMediator = new SubMenuMediator();
			facade.registerMediator(submenuMediator);
			
			facade.registerMediator(new ProposalListMediator());
			
			submenuMediator.moveToDefaultButton();
			
		}
		private function removeMediators():void {
			facade.removeMediator(SubMenuMediator.NAME);
			facade.removeMediator(ProposalListMediator.NAME);
		}
	}
}
