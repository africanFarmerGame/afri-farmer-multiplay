package uk.ac.sussex.view.components {
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.text.TextField;
	/**
	 * @author em97
	 */
	public class DisplayMessagePanel extends MovieClip {
		public static const CLOSE_BUTTON_CLICK:String = "close_button_click";
		
		private var messageBox:TextField;
		
		public function DisplayMessagePanel() {
			//Create a box. 
			this.graphics.lineStyle(2, 0xaaaaff, 1);
			this.graphics.beginFill(0xffffff, 0.9);
			this.graphics.drawRect(0, 0, 400, 300);
			var closeButton:CloseButton = new CloseButton();
			closeButton.x = 400;
			closeButton.y = 0;
			this.addChild(closeButton);
			closeButton.addEventListener(MouseEvent.CLICK, closeMe);
			this.messageBox = new TextField();
			messageBox.width = 350;
			messageBox.height = 250;
			messageBox.x = 25;
			messageBox.y = 25;
			messageBox.wordWrap = true;
			messageBox.multiline = true;
			this.addChild(messageBox);
		}
		public function setDisplayText(displayText:String):void{
			this.messageBox.text = displayText;
		}
		private function closeMe(e:MouseEvent):void{
			this.dispatchEvent(new Event(CLOSE_BUTTON_CLICK, true));
		}
		
	}
}
