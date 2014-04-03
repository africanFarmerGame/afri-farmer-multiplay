package uk.ac.sussex.view.components {
	import flash.text.*;
	/**
	 * @author em97
	 */
	public class GameListItem extends ListItem {
		private var displayText:TextField;
		public function GameListItem() {
			//super();
			var entryContainer:directoryEntry_mc = new directoryEntry_mc();
			this.addChild(entryContainer);
			
			this.displayText = new TextField();
			
			var tf:TextFormat = new TextFormat();
			tf.color = 0x000000;
			tf.size = 12;
			tf.font = "Arial";
			tf.align = TextFormatAlign.LEFT;              
			this.displayText.defaultTextFormat = tf;
			this.displayText.selectable = false;	
			this.displayText.autoSize = "left";
			this.displayText.border = false;
			this.displayText.x = 3;
			this.displayText.y = 3;
			this.addChild(this.displayText);
		}
		public function setDisplayName(displayName:String):void{
			this.displayText.text = displayName;
		}
		public function setLocked(locked:Boolean):void{
			if(locked){
				trace("The game status is locked" );
			} else {
				trace("The game status is unlocked");
			}
		}
	}
}
