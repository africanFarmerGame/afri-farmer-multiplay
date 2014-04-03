/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.text.*;
	import uk.ac.sussex.model.valueObjects.CallHistoryItem;
	import uk.ac.sussex.view.components.ListItem;

	/**
	 * @author em97
	 */
	public class CallHistoryListItem extends ListItem {
		private var callHistory:CallHistoryItem;
		
		private static const MAX_WIDTH:uint = 540;
		private static const ITEM_HEIGHT:uint = 23;
		private static const GAP_SIZE:uint = 3;
		private static const Y_POS:uint = 1;
		private static const BORDER_COLOUR:uint = 0x454545;
		
		public function CallHistoryListItem(callHistory:CallHistoryItem) {
			super();
			this.callHistory = callHistory;
			this.setItemID(callHistory.getId().toString());
			setup();
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
			sendersName.text = callHistory.getCallerName();
			sendersName.x = GAP_SIZE;
			sendersName.y = Y_POS;
			sendersName.height = ITEM_HEIGHT - 2;
			sendersName.width = 140;
			sendersName.selectable = false;
			
			var receiversName:TextField = new TextField;
			receiversName.defaultTextFormat = nameTF;
			receiversName.text = callHistory.getReceiverName();
			receiversName.x = sendersName.x + sendersName.width + GAP_SIZE;
			receiversName.y = Y_POS;
			receiversName.height = ITEM_HEIGHT - 2;
			receiversName.width = 140;
			receiversName.selectable = false;
			
			var normalTF:TextFormat = new TextFormat();
			normalTF.color = 0x000000;
			normalTF.size = 12;
			normalTF.font = "Arial";
			normalTF.align = TextFormatAlign.LEFT;  
			
			var startedDate:Date = new Date();
			startedDate.setTime(callHistory.getStarted()*1000);
			
			var startedText:TextField = new TextField;
			startedText.defaultTextFormat = normalTF;
			startedText.text = startedDate.toDateString();
			startedText.x = receiversName.x + receiversName.width + GAP_SIZE;
			startedText.y = Y_POS;
			startedText.height = ITEM_HEIGHT -2;
			startedText.width = 100;
			startedText.selectable = false;
			
			this.addChild(sendersName);
			this.addChild(receiversName);
			this.addChild(startedText);
		}
	}
}
