package uk.ac.sussex.view.components {
	import flash.text.*;

	/**
	 * @author em97
	 */
	public class MsgListItem extends ListItem {
		private var displayText:TextField; 
		public function MsgListItem() {
			super();
		
			//this.addChild(entryContainer);
			
			this.displayText = new TextField();
			
			var tf:TextFormat = new TextFormat();
			tf.font = "Calibri";
			tf.size = 15;
			tf.bold = false;
			tf.leftMargin = 6;
			tf.align = TextFormatAlign.LEFT; 
			
/**			tf.color = 0x000000;
			tf.size = 12;
			tf.font = "Arial";
			tf.align = TextFormatAlign.LEFT;**/              

			this.displayText.defaultTextFormat = tf;
			this.displayText.selectable = false;	
			this.displayText.autoSize = "left";
			this.displayText.border = false;
			this.displayText.x = 3;
			this.displayText.y = 3;
			this.addChild(this.displayText);
		}	
		public function setText(newText:String, author:String):void{
			this.displayText.text = author.toUpperCase() + ": " + newText;
		}
	}
}
