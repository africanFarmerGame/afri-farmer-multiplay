package uk.ac.sussex.view.components {
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class DietAllocationList extends MovieClip {
		private var listObject:TitledTwoColumnScrollingList;
		public function DietAllocationList() {
			listObject = new TitledTwoColumnScrollingList();
			this.addChild(listObject);
		}
		public function setTitle(titleText:String):void {
			listObject.setTitleLabel(titleText);
		}
	}
}
