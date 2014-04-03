/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;
	import uk.ac.sussex.model.valueObjects.TextMessage;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class TextMessageDisplayItem extends MovieClip {
		private var myTextMessage:TextMessage;
		private var senderDetail:TextField;
		private var textMessage:ScrollingTextBox;
		private var sentDetails:TextField;
		
		private static const MAX_WIDTH:uint = 500;
		private static const BORDER:uint = 20;
		private static const SENDER_PRECURSOR:String = "FROM: ";
		
		public static const DELETE_CLICKED:String = "DeleteTextMessageClicked";
		
		public function TextMessageDisplayItem(textMessage:TextMessage) {
			myTextMessage = textMessage;
			this.setUp();
		}
		public function getTextMessage():TextMessage{
			return this.myTextMessage;
		}
		private function setUp():void{

			var nameTF:TextFormat = new TextFormat();
			nameTF.color = 0x000000;
			nameTF.size = 14;
			nameTF.font = "Arial";
			nameTF.align = TextFormatAlign.LEFT;  
			nameTF.bold = true;
			senderDetail = new TextField();
			senderDetail.defaultTextFormat = nameTF;
			senderDetail.x = BORDER;
			senderDetail.y = BORDER;
			senderDetail.text = SENDER_PRECURSOR + myTextMessage.getSenderName();
			senderDetail.selectable = false;
			senderDetail.width = MAX_WIDTH - 2*BORDER;
			senderDetail.height = 21;
			
			var deleteButton:DeleteButtonMC = new DeleteButtonMC();
			deleteButton.scaleX = deleteButton.scaleY = 30/deleteButton.width;
			deleteButton.x = MAX_WIDTH - BORDER - deleteButton.width;
			deleteButton.y = BORDER; 
			deleteButton.addEventListener(MouseEvent.CLICK, deleteClicked);
			
			textMessage = new ScrollingTextBox(MAX_WIDTH - 2 * BORDER, 100);
			textMessage.x = BORDER;
			textMessage.y = deleteButton.y + deleteButton.height + BORDER;
			textMessage.setText(myTextMessage.getTextMessage());
			
			var date:Date = new Date();
			date.setTime(myTextMessage.getTimeStamp()*1000);
			var dateString:String = date.getUTCDate() + "-" + date.getUTCMonth() + "-" + date.getFullYear(); 
			
			sentDetails = new TextField();
			sentDetails.x = BORDER;
			sentDetails.y = textMessage.y + textMessage.height + BORDER;
			sentDetails.text = "Sent: " + dateString;
			sentDetails.selectable = false;
			
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0, 0, MAX_WIDTH, sentDetails.y + sentDetails.height + BORDER);
			this.graphics.endFill();
			
			this.addChild(senderDetail);
			this.addChild(deleteButton);
			this.addChild(textMessage);
			this.addChild(sentDetails);
		}
		private function deleteClicked(e:MouseEvent):void {
			trace("TextMessageDisplayItem sez: I got clicked. Yes sirree.");
			dispatchEvent(new Event(DELETE_CLICKED));
		}
	}
}
