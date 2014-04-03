package uk.ac.sussex.view.components {
	import flash.text.TextField;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class GameTextPanel extends MovieClip {
		var panel:TextField;
		
		public function GameTextPanel() {
			panel = new TextField;
			panel.wordWrap = true;
			panel.border = true;
			this.addChild(panel);
		}
		public function setText(text:String):void {
			panel.text = text;
		}
		public function setWidth(newWidth:Number):void {
			trace("GameTextPanel sez: I'm trying to set the width to " + newWidth);
			panel.width = newWidth;
			trace("GameTextPanel sez: I've managed to set the width to " + panel.width);
		}
	}
}
