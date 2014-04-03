package uk.ac.sussex.view.components {
	import flash.display.MovieClip;

	/**
	 * This will eventually manage all of the food layout etc. 
	 * @author em97
	 */
	public class TableTopDisplay extends MovieClip {
		private var tableTop:Tabletop1_mc;
		public function TableTopDisplay() {
			tableTop = new Tabletop1_mc();
			this.addChild(tableTop);
		}
	}
}
