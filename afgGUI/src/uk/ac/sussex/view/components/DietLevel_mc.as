package uk.ac.sussex.view.components {
	import flash.display.MovieClip;
	/**
	 * @author em97
	 */
	public class DietLevel_mc extends MovieClip{
		
		public function DietLevel_mc(){
			super();
		}
		public function setDietLevel(level:String):void {
			this.gotoAndStop(level);
		}
	}
}
