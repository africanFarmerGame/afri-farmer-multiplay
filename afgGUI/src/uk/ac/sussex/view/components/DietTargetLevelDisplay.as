package uk.ac.sussex.view.components {
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class DietTargetLevelDisplay extends MovieClip {
		private var dietType:DietType_mc;
		private var dietLevel:DietLevel_mc;
		public function DietTargetLevelDisplay() {
			dietLevel = new DietLevel_mc();
			var scaleLevel:Number = 45/dietLevel.height;
			dietLevel.scaleX = scaleLevel;
			dietLevel.scaleY = scaleLevel;
			dietLevel.x = 0; 
			dietLevel.y = 0;
			this.addChild(dietLevel);
			
			dietType = new DietType_mc();
			var scaleType:Number = 45/dietType.height;
			dietType.scaleX = scaleType;
			dietType.scaleY = scaleType;
			dietType.x = 50;
			dietType.y = 0;
			this.addChild(dietType);
			
			this.reset();
		}
		public function setDietType(target:int):void {
			dietType.setDietType(target);
		}
		public function setDietLevel(level:String):void {
			trace("DietTargetLevelDisplay sez: I'm setting to level " + level);
			dietLevel.setDietLevel(level);
		}
		public function reset():void {
			//Need to be able to set them to blank. 
			dietLevel.setDietLevel("NONE");
			dietType.setDietType(0);
		}
	}
}
