package uk.ac.sussex.view.components {
	import flash.events.Event;
	import uk.ac.sussex.model.valueObjects.PlayerChar;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class HearthlessList extends MovieClip {
		public static const HEARTHLESS_PERSON_SELECTED:String = "HearthlessPersonSelected";
		public static const HEARTHLESS_SELECTION_CLEARED:String = "HearthlessSelectionCleared";
		
		private var scrollingList:ScrollingList;
		
		public function HearthlessList() {
			this.setup();
		}
		public function displayHearthless(hearthlessArray:Array):void {
			scrollingList.clearList();
			
			for each (var pc:PlayerChar in hearthlessArray) {
				var pcListItem:HearthlessListItem = new HearthlessListItem(pc);
				scrollingList.addItem(pcListItem);
			}
		}
		public function getSelectedHearthlessPerson():String {
			var selectedListItem:String = scrollingList.getCurrentValue();
			return selectedListItem;
		}
		private function setup():void {
			scrollingList = new ScrollingList(60, 275);
			scrollingList.x = 0;
			scrollingList.y = 0; 
			scrollingList.showBackgroundFilter(false);
			scrollingList.hideBackground(true);
			this.addChild(scrollingList);
			scrollingList.addEventListener(ScrollingList.ITEM_SELECTED, itemClicked);
			scrollingList.addEventListener(ScrollingList.SELECTION_CLEARED, itemUnclicked);
		}
		private function itemClicked(e:Event):void {
			dispatchEvent(new Event(HEARTHLESS_PERSON_SELECTED));
		}
		private function itemUnclicked(e:Event):void {
			dispatchEvent(new Event(HEARTHLESS_SELECTION_CLEARED));
		}
	}
}
