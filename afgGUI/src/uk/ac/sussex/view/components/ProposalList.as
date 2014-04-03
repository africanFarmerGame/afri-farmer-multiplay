package uk.ac.sussex.view.components {
	import flash.events.MouseEvent;
	import flash.events.Event;
	import uk.ac.sussex.model.valueObjects.Proposal;
	import flash.text.*;
	import flash.display.Shape;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class ProposalList extends MovieClip {
		
		private var scrollingList:ScrollingList;
		private var acceptButton:SaveCancelBtn;
		private var refuseButton:SaveCancelBtn;
		private var retractButton:SaveCancelBtn;
		
		private static const GAP_SIZE:Number = 10;
		private static const POSITIVE_TEXT_COLOUR:uint = 0x0D6A5C;
		private static const NEGATIVE_TEXT_COLOUR:uint = 0xE4DF99;
		
		public static const PROP_ITEM_SELECTED:String = "PropItemSelected";
		public static const PROP_ITEM_DESELECTED:String = "PropItemDeselected";
		public static const ACCEPT_CLICKED:String = "PropAccepted";
		public static const DECLINE_CLICKED:String = "PropRejected";
		public static const RETRACT_CLICKED:String = "PropRetracted";
		
		public function ProposalList() {
			setup();
		}
		public function displayProposals(propArray:Array):void {
			scrollingList.clearList();
			for each (var prop:Proposal in propArray) {
				if(!prop.getDeleted()){
					var propItem:ProposalListItem = new ProposalListItem();
					propItem.setProposal(prop);
					
					scrollingList.addItem(propItem);
				}
			}
		}
		public function clearProps():void {
			scrollingList.clearCurrentSelection();
			scrollingList.clearList();
		}
		public function getSelectedProposal():Proposal{
			var selectedId:String = scrollingList.getCurrentValue();
			var selected:ProposalListItem  = scrollingList.getItemWithID(selectedId) as ProposalListItem;
			var proposal:Proposal = selected.getProposal();
			return proposal;
		}
		/**
		 * This function calls showHideAcceptDecline and showHideRetract to hide the 
		 * buttons as well as clearing the current selection. 
		 */
		public function clearSelection():void {
			scrollingList.clearCurrentSelection();
			showHideAcceptDecline(false);
			showHideRetract(false);
		}
		public function showHideAcceptDecline(show:Boolean):void {
			if(show){
				if(retractButton.parent!=null){retractButton.parent.removeChild(retractButton);}
				this.addChild(refuseButton);
				this.addChild(acceptButton);
			} else {
				if(refuseButton.parent!=null){
					refuseButton.parent.removeChild(refuseButton);
					acceptButton.parent.removeChild(acceptButton);
				}
			}
		}
		public function showHideRetract(show:Boolean):void{
			if(show){
				if(refuseButton.parent!=null){
					refuseButton.parent.removeChild(refuseButton);
					acceptButton.parent.removeChild(acceptButton);
				}
				this.addChild(retractButton);
			} else {
				if(retractButton.parent!=null){retractButton.parent.removeChild(retractButton);}
			}
		}
		private function setup():void {
			setupTitleBar();
			
			scrollingList = new ScrollingList(620, 264);
			scrollingList.x = 0;
			scrollingList.y = 25; 
			scrollingList.showBackgroundFilter(false);
			scrollingList.setBorderColour(0x09063A);
			this.addChild(scrollingList);
			scrollingList.addEventListener(ScrollingList.ITEM_SELECTED, itemSelected);
			scrollingList.addEventListener(ScrollingList.SELECTION_CLEARED, selectionCleared);
			
			setupAcceptDeclineRetract();
		}
		private function setupAcceptDeclineRetract():void {
			var scale:Number = 0.25;

			var blankRefuse:BlankCancelBtn = new BlankCancelBtn();
			blankRefuse.scaleX = blankRefuse.scaleY = scale;
			refuseButton = new SaveCancelBtn(blankRefuse);
			refuseButton.setButtonTextColour(NEGATIVE_TEXT_COLOUR);
			refuseButton.setButtonText("Refuse");
			refuseButton.x = -refuseButton.width - GAP_SIZE;
			refuseButton.y = scrollingList.y + scrollingList.height - refuseButton.height;
			refuseButton.addEventListener(MouseEvent.CLICK, refuseClick);
						
			var blankAccept:BlankSaveBtn = new BlankSaveBtn();
			blankAccept.scaleX = blankAccept.scaleY = scale;
			acceptButton = new SaveCancelBtn(blankAccept);
			acceptButton.setButtonTextColour(POSITIVE_TEXT_COLOUR);
			acceptButton.setButtonText("Accept");
			acceptButton.x = -acceptButton.width - GAP_SIZE;
			acceptButton.y = refuseButton.y - acceptButton.height - GAP_SIZE;
			acceptButton.addEventListener(MouseEvent.CLICK, acceptClick);
			
			var blankRetract:BlankCancelBtn = new BlankCancelBtn();
			blankRetract.scaleX = blankRetract.scaleY = scale;
			retractButton = new SaveCancelBtn(blankRetract);
			retractButton.setButtonTextColour(NEGATIVE_TEXT_COLOUR);
			retractButton.setButtonText("Retract");
			retractButton.x = -retractButton.width - GAP_SIZE;
			retractButton.y = scrollingList.y + scrollingList.height - retractButton.height;
			retractButton.addEventListener(MouseEvent.CLICK, retractClick);
		}
		
		private function setupTitleBar():void {
			var titleBar:Shape = new Shape();
			titleBar.graphics.lineStyle(1,0x000000);
			titleBar.graphics.beginFill(0xF49160); 
			titleBar.graphics.drawRect(0,0,607,25);
			titleBar.graphics.endFill();	
			this.addChild(titleBar);
			var tFormat:TextFormat = new TextFormat();
			tFormat.font = "Calibri";
			tFormat.size = 17;
			tFormat.bold = false;
			tFormat.align = TextFormatAlign.CENTER;	
			
			var headers:Array = ProposalListItem.getColumnHeaders();
			
			for each (var header:Array in headers){
				var text:TextField = new TextField();
				text.defaultTextFormat = tFormat;
				text.textColor = 0x000000;
				text.background = false;
				text.border = false;
				text.borderColor = 0x000000;
				text.selectable = false;
				text.x = header.pop();
				text.width = header.pop();
				text.text = header.pop();
				text.height = 25;
				text.y = 0;
				this.addChild(text);
			}
		}
		private function itemSelected(e:Event):void {
			dispatchEvent(new Event(PROP_ITEM_SELECTED));
		}
		private function selectionCleared(e:Event):void {
			dispatchEvent(new Event(PROP_ITEM_DESELECTED));
		}
		private function acceptClick(e:MouseEvent):void {
			dispatchEvent(new Event(ProposalList.ACCEPT_CLICKED));
		}
		private function retractClick(e:MouseEvent):void {
			dispatchEvent(new Event(ProposalList.RETRACT_CLICKED));
		}
		private function refuseClick(e:MouseEvent):void {
			dispatchEvent(new Event(ProposalList.DECLINE_CLICKED));
		}
	}
}
