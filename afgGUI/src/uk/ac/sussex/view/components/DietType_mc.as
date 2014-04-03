package uk.ac.sussex.view.components {
	import uk.ac.sussex.model.valueObjects.Diet;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class DietType_mc extends MovieClip {
		public function DietType_mc() {
		}
		public function setDietType(dietType:int):void{
			switch (dietType) {
				case Diet.DIET_TARGET_MALE:
					this.gotoAndStop(1);
					break;
				case Diet.DIET_TARGET_FEMALE:
					this.gotoAndStop(2);
					break;
				case Diet.DIET_TARGET_CHILD:
					this.gotoAndStop(3);
					break;
				case Diet.DIET_TARGET_BABY:
					this.gotoAndStop(4);
					break;
				default:
					trace("DietIcons sez: Error in Diet.setDietType method");;
					break;
			}
		}
	}
}
