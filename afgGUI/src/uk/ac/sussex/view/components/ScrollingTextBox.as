package uk.ac.sussex.view.components {
	import flash.text.*;

	/**
	 * @author em97
	 */
	public class ScrollingTextBox extends ScrollingContainer {
		
		private var textField:TextField;
		private var normalTextFormat:TextFormat;
		private var headerTextFormat:TextFormat;
		
		public function ScrollingTextBox(totalWidth : Number, onScreenHeight : Number) {
			super(totalWidth, onScreenHeight);
			this.setupTextFormats();
			this.setupTextField();
			this.addItemToContainer(textField);
		}
		//TODO: Need to be able to make readonly/text entry.
		
		/**
		 * @param newText - the text to show on the screen.
		 */
		public function setText(newText:String):void {
			if(newText == null){
				newText = "";
			}
			textField.text = newText;
			//This needs to adjust the size I think. 
			this.refreshContainer();
		}
		
		private function setupTextFormats():void {
			normalTextFormat = new TextFormat();
			normalTextFormat.font = "Calibri";
			normalTextFormat.size = 15;
			normalTextFormat.leftMargin = 6;
			normalTextFormat.rightMargin = 6;
			
			headerTextFormat = new TextFormat();
			headerTextFormat.leftMargin = 6;
			headerTextFormat.size = 17;
			headerTextFormat.bold = true;
			headerTextFormat.bold = true;
		}
		private function setupTextField():void{
			textField = new TextField;
			textField.defaultTextFormat = normalTextFormat;	
			textField.wordWrap = true;
			textField.width = this.maskWidth;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.selectable = false;
			textField.text = "";
		}
	}
}
