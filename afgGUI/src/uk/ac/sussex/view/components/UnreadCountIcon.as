package uk.ac.sussex.view.components {
	import flash.text.*;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class UnreadCountIcon extends MovieClip {
		private var displayCount:TextField;
		public function UnreadCountIcon() {
			this.graphics.beginFill(0xDD0000, 1);
			this.graphics.drawCircle(0, 0, 9.5);
			this.graphics.endFill();
			
			var tf:TextFormat = new TextFormat();
			tf.font = "Arial";
			tf.align = TextFormatAlign.CENTER;
			tf.color = 0xFFFFFF;
			tf.size = 12;
			tf.bold = true;
			displayCount = new TextField();
			displayCount.defaultTextFormat = tf;
			displayCount.selectable = false;
			displayCount.width = 18;
			displayCount.height = 18;
			displayCount.x = -9;
			displayCount.y = -8.5;
			this.addChild(displayCount);
		}
		public function setUnread(unreadCount:uint):void {
			this.displayCount.text = unreadCount.toString();
		}
	}
}
