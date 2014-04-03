package uk.ac.sussex.view.components {
	import flash.events.MouseEvent;
	import flash.text.*;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class SaveCancelBtn extends MovieClip {
		private var backgroundButton:MovieClip;
		private var buttonText:TextField;
		public function SaveCancelBtn(backgroundButton:MovieClip) {
			this.backgroundButton = backgroundButton;
			setup();
		}
		public function setButtonTextColour(newColour:uint):void {
			buttonText.textColor = newColour;
		}
		public function setButtonText(buttonLabel:String):void {
			if(buttonLabel==null){
				buttonLabel = "";
			}
			buttonText.text = buttonLabel.toUpperCase();
		}
		private function setup():void {
			backgroundButton.x = 0;
			backgroundButton.y = 0;
			backgroundButton.gotoAndStop("UP");
			this.addChild(this.backgroundButton);
			
			var tFormat:TextFormat = new TextFormat();
			tFormat.font = "Arial";
			tFormat.size = 14;
			tFormat.bold = true;
			tFormat.align = TextFormatAlign.CENTER;
			
			buttonText = new TextField();
			buttonText.defaultTextFormat = tFormat;
			buttonText.width = backgroundButton.width - 4;
			buttonText.height = backgroundButton.height - 4;
			
			buttonText.x = 2;
			buttonText.y = 2;
			this.addChild(buttonText);
			
			this.mouseChildren = false;
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		private function mouseUp(e:MouseEvent):void {
		//	this.dispatchEvent(new Event(SUB_MENU_BUTTON_CLICKED));
			backgroundButton.gotoAndStop("UP");
		}
		private function mouseDown(e:MouseEvent):void {
			backgroundButton.gotoAndStop("DOWN");
		}
		private function mouseOver(e:MouseEvent):void {
			backgroundButton.gotoAndStop("OVER");
		}
		private function mouseOut(e:MouseEvent):void {
			backgroundButton.gotoAndStop("UP");
		}
	}
}
