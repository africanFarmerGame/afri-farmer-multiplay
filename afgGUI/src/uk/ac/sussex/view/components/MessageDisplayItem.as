/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import uk.ac.sussex.model.valueObjects.Message;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class MessageDisplayItem extends MovieClip {
		private var myMessage:Message;
		private var subjectText:TextField;
		private var bodyText:ScrollingTextBox;
		private var sentDetails:TextField;
		
		private static const MAX_WIDTH:uint = 850;
		private static const BORDER:uint = 20;
		private static const BODY_TEXT_HEIGHT:Number = 460;
		
		public static const DELETE_CLICKED:String = "DeleteMessageClicked";
		
		public function MessageDisplayItem(message:Message) {
			myMessage = message;
			this.setUp();
		}
		public function getMessage():Message{
			return this.myMessage;
		}
		private function setUp():void{

			var nameTF:TextFormat = new TextFormat();
			nameTF.color = 0x000000;
			nameTF.size = 14;
			nameTF.font = "Arial";
			nameTF.align = TextFormatAlign.LEFT;  
			nameTF.bold = true;
			subjectText = new TextField();
			subjectText.defaultTextFormat = nameTF;
			subjectText.x = BORDER;
			subjectText.y = BORDER;
			subjectText.text = myMessage.getSubject();
			subjectText.selectable = false;
			subjectText.width = MAX_WIDTH - 2*BORDER;
			subjectText.height = 21;
			
			var deleteButton:DeleteButtonMC = new DeleteButtonMC();
			deleteButton.scaleX = deleteButton.scaleY = 30/deleteButton.width;
			deleteButton.x = MAX_WIDTH - BORDER - deleteButton.width;
			deleteButton.y = BORDER; 
			deleteButton.addEventListener(MouseEvent.CLICK, deleteClicked);
			
			bodyText = new ScrollingTextBox(MAX_WIDTH - 2 * BORDER, BODY_TEXT_HEIGHT);
			bodyText.x = BORDER;
			bodyText.y = deleteButton.y + deleteButton.height + BORDER;
			bodyText.setBorderColour(0x000000);
			bodyText.showBackgroundFilter(false);
			bodyText.setText(myMessage.getBody());
			
			sentDetails = new TextField();
			sentDetails.x = BORDER;
			sentDetails.y = bodyText.y + BODY_TEXT_HEIGHT + BORDER;
			sentDetails.height = 16;
			
			var date:Date = new Date();
			date.setTime(myMessage.getTimestamp()*1000);
			var dateString:String = date.getUTCDate() + "-" + date.getUTCMonth() + "-" + date.getFullYear(); 
			
			sentDetails.text = "Sent: " + dateString;
			sentDetails.selectable = false;
			
			trace("MessageDisplayItem sez: My height should be " + (sentDetails.y + sentDetails.height + BORDER));
			trace("MessageDisplayItem sez: My bodytext item is " + bodyText.height);
			this.graphics.clear();
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0, 0, MAX_WIDTH, sentDetails.y + sentDetails.height + BORDER);
			this.graphics.endFill();
			
			this.addChild(subjectText);
			this.addChild(deleteButton);
			this.addChild(bodyText);
			this.addChild(sentDetails);
			trace("MessageDisplayItem sez: My height is " + this.height);
		}
		override public function get height():Number{
			return sentDetails.y + sentDetails.height + BORDER;
		}
		private function deleteClicked(e:MouseEvent):void {
			dispatchEvent(new Event(DELETE_CLICKED));
		}
	}
}
