package uk.ac.sussex.view.components {
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class TextMessageReadIcon extends MovieClip {
		
		public function TextMessageReadIcon() {
			gotoAndStop(1);
		}
		public function set open(open:Boolean):void {
			if(open){
				gotoAndStop(1);
			} else {
				gotoAndStop(2);
			}
		}
		
	}
}
