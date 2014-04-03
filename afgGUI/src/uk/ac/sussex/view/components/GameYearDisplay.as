package uk.ac.sussex.view.components {
	import flash.text.*;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class GameYearDisplay extends MovieClip {
		private var yearLabel:TextField;
		private var yearNumber:TextField;
		public function GameYearDisplay() {
			var yearFormat:TextFormat = new TextFormat();
			yearFormat.font = "Arial";
			yearFormat.size = 25;
			yearFormat.color = 0x09063A;
			yearFormat.align = TextFormatAlign.CENTER;
			yearFormat.bold = true;
			
			yearLabel = new TextField();
			yearLabel.text = "YEAR";
			yearLabel.setTextFormat(yearFormat);
			yearLabel.height = 29;
			yearLabel.selectable = false;
			//yearLabel.x = 750;
			//yearLabel.y = 6;
			
			yearFormat.size = 42;
			yearNumber = new TextField();
			yearNumber.defaultTextFormat = yearFormat;
			yearNumber.text = "1";
			yearNumber.height = 45;
			yearNumber.x = yearLabel.x + (yearLabel.width - yearNumber.width)/2;
			//yearNumber.y = 35;
			yearNumber.y = yearLabel.y + 29;
			yearNumber.selectable = false;
			this.addChild(yearLabel);
			this.addChild(yearNumber);
		}
		public function setGameYearNumber(newNumber:int):void {
			yearNumber.text = newNumber.toString();
		}
	}
}
