package uk.ac.sussex.view.components {
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.text.*;

	/**
	 * @author em97
	 */
	public class MouseoverTextField extends TextField {
		
		public function MouseoverTextField() {
			var mouseOverFormatN:TextFormat = new TextFormat();
			var mouseOverFormatBold:TextFormat = new TextFormat();	
		
			mouseOverFormatN.size = 11;
			mouseOverFormatN.leftMargin = 0;
			mouseOverFormatN.font = "Calibri";
			mouseOverFormatBold.bold = true;
		
			this.defaultTextFormat = mouseOverFormatN;	
			this.background = true;
			this.backgroundColor = 0xF6FA7A;
			this.border = true;
			this.borderColor = 0x000000;
			this.wordWrap = false;
			this.selectable = false;
			this.autoSize = TextFieldAutoSize.LEFT;
		}
		public function addToScreen(trigger:DisplayObject, newx:int, newy:int):void {
			var myPos:Point = trigger.localToGlobal(new Point(newx, newy));
			this.x = myPos.x;
			this.y = myPos.y;
			trigger.stage.addChild(this);
		}
		public function removeFromScreen():void {
			if(this.parent != null){
				this.parent.removeChild(this);
			}
		}
	}
}
