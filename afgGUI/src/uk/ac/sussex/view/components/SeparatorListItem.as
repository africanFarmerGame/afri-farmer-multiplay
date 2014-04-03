package uk.ac.sussex.view.components {
	import flash.display.MovieClip;
	import uk.ac.sussex.view.components.ListItem;

	/**
	 * @author em97
	 */
	public class SeparatorListItem extends ListItem {
		private var separator:SeparatorMC;
		private var background:MovieClip;
		public function SeparatorListItem() {
			super();
			setup();
			this.enabled = false;
		}
		override public function set width(newWidth:Number):void {
			var newX:Number = (newWidth - separator.width)/2;
			background.width = newWidth;
			separator.x = newX;
		}
		override public function set height(newHeight:Number):void {
			var newY:Number = (newHeight - separator.height)/2;
			trace("SeparatorListItem sez: A new Height of " + newHeight + " is given a y pos of " + newY);
			background.height = newHeight;
			this.addChild(background);
			separator.y = newY;
			this.addChild(separator);
			trace("SeparatorListItem: my height is now " + this.height);
		}
		private function setup():void {
			background = new MovieClip();
			background.graphics.beginFill(0, 0);
			background.graphics.drawRect(0, 0, 100, 20);
			background.graphics.endFill();
			separator = new SeparatorMC();
			separator.x = (background.width - separator.width)/2;
			separator.y = (background.height - separator.height)/2;
			this.addChild(separator);
		}
	}
}
