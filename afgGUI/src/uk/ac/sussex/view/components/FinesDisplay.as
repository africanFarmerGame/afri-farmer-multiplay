package uk.ac.sussex.view.components {
	import uk.ac.sussex.model.valueObjects.Fine;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class FinesDisplay extends MovieClip {
		private var scrollingList:ScrollingList;
		
		public function FinesDisplay() {
			setup();
		}
		public function displayFines(finesArray:Array):void {
			scrollingList.clearList();
			for each (var fine:Fine in finesArray) {
				var fineItem:FinesListItem = new FinesListItem();
				fineItem.setFine(fine);
				scrollingList.addItem(fineItem);
			}
		}
		public function getSelectedFineId():String{
			var selectedId:String = scrollingList.getCurrentValue();
			return selectedId;
		}
		public function clearSelection():void {
			scrollingList.clearCurrentSelection();
		}
		private function setup():void {
			scrollingList = new ScrollingList(620, 264);
			scrollingList.x = 0;
			scrollingList.y = 0; 
			scrollingList.showBackgroundFilter(false);
			scrollingList.setBorderColour(0x09063A); 
			this.addChild(scrollingList);
		}
	}
}
