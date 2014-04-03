package uk.ac.sussex.view.components {
	import uk.ac.sussex.model.valueObjects.Proposal;
	import uk.ac.sussex.view.components.ListItem;

	/**
	 * @author em97
	 */
	public class ProposalListItem extends ListItem {
		private var proposal:Proposal;
		private var person:GameTextField;
		private var currentHearth:GameTextField;
		private var proposedHearth:GameTextField;
		private var status:GameTextField;
		
		private static const GAP_SIZE:Number = 2;
		private static const FIELD_WIDTH:Number = 140;
		private static const ITEM_Y_POS:uint = 0;
		private static const ITEM_HEIGHT:uint = 25;
		
		public function ProposalListItem() {
			super();
			setup();
		}
		public function setProposal(proposal:Proposal):void{
			this.proposal = proposal;
			setItemID(proposal.getId().toString());
			person.text = proposal.getTargetName();
			if(proposal.getCurrentHearthName()!=null){
				currentHearth.text = proposal.getCurrentHearthName();
			} else {
				currentHearth.text = "None";
			}
			proposedHearth.text = proposal.getTargetHearthName();
			setStatus(proposal.getStatus());
		}
		public function getProposal():Proposal {
			return this.proposal;
		}
		private function setStatus(propStatus:int):void{
			switch(propStatus){
				case Proposal.PENDING:
					status.text = "Pending";
					this.enabled = true;
					break;
				case Proposal.ACCEPTED:
					status.text = "Accepted";
					this.enabled = false;
					break;
				case Proposal.DECLINED:
					status.text = "Refused";
					this.enabled = false;
					break;
				case Proposal.RETRACTED:
					status.text = "Retracted";
					this.enabled = false;
					break;
			}
		}
		private function setup():void{
			person = new GameTextField();
			person.readonly = true;
			person.height = ITEM_HEIGHT;
			person.width = FIELD_WIDTH;
			person.x = GAP_SIZE;
			person.y = ITEM_Y_POS;
			this.addChild(person);
			
			currentHearth = new GameTextField();
			currentHearth.readonly = true;
			currentHearth.height = ITEM_HEIGHT;
			currentHearth.width = FIELD_WIDTH;
			currentHearth.x = person.x + person.width + GAP_SIZE;
			currentHearth.y = ITEM_Y_POS;
			this.addChild(currentHearth);

			proposedHearth = new GameTextField();
			proposedHearth.readonly = true;
			proposedHearth.height = ITEM_HEIGHT;
			proposedHearth.width = FIELD_WIDTH;
			proposedHearth.x = currentHearth.x + currentHearth.width + GAP_SIZE;
			proposedHearth.y = ITEM_Y_POS;
			this.addChild(proposedHearth);
			
			status = new GameTextField();
			status.readonly = true;
			status.height = ITEM_HEIGHT;
			status.width = FIELD_WIDTH;
			status.x = proposedHearth.x + proposedHearth.width + GAP_SIZE;
			status.y = ITEM_Y_POS;
			this.addChild(status);
		}
		override public function set enabled(enabled:Boolean):void {
			super.enabled = enabled;
			if(enabled){
				this.alpha = 1;
			} else {
				this.alpha = 0.5;
			}
		}
		public static function getColumnHeaders():Array {
			var headers:Array = new Array();
			
			headers.push(new Array("Who", FIELD_WIDTH, 0));
			headers.push(new Array("Current Hearth", FIELD_WIDTH, FIELD_WIDTH + GAP_SIZE));
			headers.push(new Array("Proposed Hearth", FIELD_WIDTH, 2*(FIELD_WIDTH + GAP_SIZE)));
			headers.push(new Array("Status", FIELD_WIDTH, 3*(FIELD_WIDTH + GAP_SIZE)));
			
			return headers;
		}
	}
}
