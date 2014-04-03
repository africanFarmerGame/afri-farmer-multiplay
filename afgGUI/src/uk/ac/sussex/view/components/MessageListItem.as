package uk.ac.sussex.view.components {
	import uk.ac.sussex.model.valueObjects.Message;
	import flash.text.*;
	
	/**
	 * Max width of this is decided by the width of the message display area. 540 at time of asking. 
	 * @author em97
	 */
	public class MessageListItem extends ListItem {
		private var message:Message;
		private var unreadIcon:TextMessageReadIcon;
		private var readTF:TextFormat;
		private var unreadTF:TextFormat;
		private var subjectText:TextField;
		
		private static const MAX_WIDTH:uint = 540;
		private static const ITEM_HEIGHT:uint = 23;
		private static const GAP_SIZE:uint = 3;
		private static const BORDER_COLOUR:uint = 0x454545;
		
		public function MessageListItem(message:Message) {
			super();
			this.message = message;
			this.setItemID(message.getId().toString());
			this.setup();
		}
		public function updateUnread():void {
			var unread:Boolean = message.getUnread();
			if(unread){
				unreadIcon.open = false;
				subjectText.defaultTextFormat = unreadTF;
			} else {
				unreadIcon.open = true;
				subjectText.defaultTextFormat = readTF;
			}
			subjectText.text = message.getSubject();
		}
		private function setup():void {
			this.graphics.lineStyle(1, BORDER_COLOUR);
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(0, ITEM_HEIGHT);
			this.graphics.lineTo(MAX_WIDTH, ITEM_HEIGHT);
			this.graphics.lineTo(MAX_WIDTH, 0);
			this.graphics.lineTo(0, 0);
			
			unreadIcon = new TextMessageReadIcon();
			unreadIcon.y = 1;
			unreadIcon.x = GAP_SIZE;
			
			readTF = new TextFormat();
			readTF.color = 0x000000;
			readTF.size = 12;
			readTF.font = "Arial";
			readTF.align = TextFormatAlign.LEFT;
			
			unreadTF = new TextFormat();
			unreadTF.color = 0x000000;
			unreadTF.size = 12;
			unreadTF.font = "Arial";
			unreadTF.bold = true;
			unreadTF.align = TextFormatAlign.LEFT;    

			subjectText = new TextField;
			subjectText.height = ITEM_HEIGHT - 2;
			subjectText.width = MAX_WIDTH - GAP_SIZE - unreadIcon.width;
			subjectText.x = unreadIcon.x + unreadIcon.width + GAP_SIZE;
			subjectText.y = 1;
			subjectText.selectable = false;
			
			this.updateUnread();
			
			this.addChild(unreadIcon);
			this.addChild(subjectText);
		}
	}
}
