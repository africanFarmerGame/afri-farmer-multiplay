package uk.ac.sussex.model {
	import uk.ac.sussex.model.valueObjects.Proposal;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.interfaces.IProxy;

	/**
	 * @author em97
	 */
	public class ProposalListProxy extends Proxy implements IProxy {
		public static const NAME:String = "ProposalListProxy";
		public static const PROPOSAL_ADDED:String = "ProposalAdded";
		private var householdId:int;
		
		public function ProposalListProxy(householdId:int) {
			this.householdId = householdId;
			super(NAME, null);
		}
		public function addManyProposals(newProps:Array):void{
			 for each (var proposal:Proposal in newProps){
				this.addOrUpdate(proposal);
			 }
			 sendNotification(ProposalListProxy.PROPOSAL_ADDED);
		}
		public function addSingleProposal(proposal:Proposal):void {
			this.addOrUpdate(proposal);
			sendNotification(PROPOSAL_ADDED);
		}
		public function fetchIncomingProposals():Array{
			var incoming:Array = new Array();
			for each (var prop:Proposal in proposals){
				if(prop.getProposerHearthId()!=householdId){
					incoming.push(prop);
				}
			}
			return incoming;
		}
		public function fetchOutgoingProposals():Array{
			var outgoing:Array = new Array();
			for each (var prop:Proposal in proposals){
				if(prop.getProposerHearthId()==householdId){
					outgoing.push(prop);
				}
			}
			return outgoing;
		}
		/**
		 * Checks a proposal to see if we need to add it, or update an existing. 
		 * Does the update/adding.
		 * Returns true if updating, false if adding.
		 */
		private function addOrUpdate(proposal:Proposal):Boolean{
			var propId:int = proposal.getId();
			var found:Boolean = false;
			for each(var existingProp:Proposal in proposals){
				if(existingProp.getId() == propId){
					found = true;
					//It should only be the status that could be changed. 
					existingProp.setStatus(proposal.getStatus());
				}
			}
			if(!found){
				proposals.push(proposal);
			}
			return found;
		}
		protected function get proposals():Array {
			return data as Array;
		}
		override public function onRegister():void{
			data = new Array();
		}
	}
}
