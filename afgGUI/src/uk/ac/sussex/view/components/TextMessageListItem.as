package uk.ac.sussex.view.components {
	import flash.text.*;
	import uk.ac.sussex.model.valueObjects.TextMessage;

	/**
	 * Max width of this is decided by the width of the message display area. 540 at time of asking. 
	 * @author em97
	 */
	public class TextMessageListItem extends ListItem {
		private var textMessage:TextMessage;
		private var unreadIcon:TextMessageReadIcon;
		
		private static const MAX_WIDTH:uint = 540;
		private static const ITEM_HEIGHT:uint = 23;
		private static const STUB_LENGTH:uint = 60;
		private static const GAP_SIZE:uint = 3;
		private static const BORDER_COLOUR:uint = 0x454545;
		
		public function TextMessageListItem(textMessage:TextMessage) {
			super();
			this.textMessage = textMessage;
			this.setItemID(textMessage.getId().toString());
			this.setup();
		}
		public function updateUnread():void {
			unreadIcon.open = !(textMessage.getUnread());
		}
		private function setup():void {
			this.graphics.lineStyle(1, BORDER_COLOUR);
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(0, ITEM_HEIGHT);
			this.graphics.lineTo(MAX_WIDTH, ITEM_HEIGHT);
			this.graphics.lineTo(MAX_WIDTH, 0);
			this.graphics.lineTo(0, 0);
			
			var nameTF:TextFormat = new TextFormat();
			nameTF.color = 0x000000;
			nameTF.size = 14;
			nameTF.font = "Arial";
			nameTF.align = TextFormatAlign.LEFT;  
			nameTF.bold = true;
			var sendersName:TextField = new TextField;
			sendersName.defaultTextFormat = nameTF;
			sendersName.text = textMessage.getSenderName();
			sendersName.x = GAP_SIZE;
			sendersName.y = 1;
			sendersName.height = ITEM_HEIGHT - 2;
			sendersName.width = 140;
			sendersName.selectable = false;
			
			
			unreadIcon = new TextMessageReadIcon();
			unreadIcon.open = !textMessage.getUnread();
			unreadIcon.y = 1;
			unreadIcon.x = TextMessageListItem.MAX_WIDTH - GAP_SIZE - unreadIcon.width;
			
			var stubTF:TextFormat = new TextFormat();
			stubTF.color = 0x000000;
			stubTF.size = 12;
			stubTF.font = "Arial";
			stubTF.align = TextFormatAlign.LEFT;  
			var messageStub:TextField = new TextField;
			messageStub.defaultTextFormat = stubTF;
			var stubText:String = textMessage.getTextMessage();
			if(stubText.length > STUB_LENGTH){
				stubText = stubText.slice(0, STUB_LENGTH - 3) + "...";
			}
			messageStub.text = stubText;
			messageStub.x = sendersName.x + sendersName.width + GAP_SIZE;
			messageStub.y = 1;
			messageStub.height = ITEM_HEIGHT - 2;
			messageStub.width =  MAX_WIDTH - (GAP_SIZE * 4) - sendersName.width - unreadIcon.width;
			messageStub.selectable = false;
			
			this.addChild(sendersName);
			this.addChild(messageStub);
			this.addChild(unreadIcon);
		}
	}
}
