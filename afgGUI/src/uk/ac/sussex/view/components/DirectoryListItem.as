/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.text.*;
	import flash.display.MovieClip;
	import uk.ac.sussex.model.valueObjects.PlayerChar;

	/**
	 * @author em97
	 */
	public class DirectoryListItem extends ListItem {
		private var myPlayerChar:PlayerChar;
		private var playerName:TextField;
		private var onlineIcon:onlineIcon_mc;
		
		public function DirectoryListItem(playerChar:PlayerChar) {
			super();
			this.myPlayerChar = playerChar;
			this.setItemID(playerChar.getId().toString());
			setupItem();
		}
		public function changeOnlineStatus():void {
			onlineIcon.gotoAndStop((myPlayerChar.getOnlineStatus()?1:2));
		}
		public function changePlayerName():void {
			//TODO implement the changePlayerName;
			trace("DirectoryListItem sez: Not done yet");
		}
		public function getPlayerChar():PlayerChar{
			return this.myPlayerChar;
		}
		private function setupItem():void {
			var posX:Number = 0;
			var posY:Number = 0;
			
			var personIcon:PersonIconBorder = new PersonIconBorder();
			personIcon.gotoAndStop(1);
			personIcon.width = 21;
			personIcon.height = 21;
			personIcon.x = posX;
			personIcon.y = posY;		
				
			// Online status
			onlineIcon = new onlineIcon_mc();
			onlineIcon.gotoAndStop((myPlayerChar.getOnlineStatus()?1:2));
			onlineIcon.width = 21;
			onlineIcon.height = 21;
			onlineIcon.x = 200;
			onlineIcon.y = posY;
			
			// Name
			var tf:TextFormat = new TextFormat();
			tf.color = 0x000000;
			tf.size = 12;
			tf.font = "Arial";
			tf.align = TextFormatAlign.LEFT;  
			playerName = new TextField();
			playerName.defaultTextFormat = tf;
			playerName.text = myPlayerChar.getFirstName() + " " + myPlayerChar.getFamilyName();	
			playerName.autoSize = "left";
			playerName.x = posX + 28;	
			playerName.border = false;
			playerName.y = posY + 1;
			playerName.height = 19;
			playerName.selectable = false;
	
			var textBorder:TextBorder_mc = new TextBorder_mc();
			textBorder.height = 21;
			textBorder.width = 180;
			textBorder.x = posX;
			textBorder.y = posY;
				
			// overlay for Listener object 
			var entryOverlay:MovieClip = new MovieClip();
			entryOverlay.graphics.beginFill(0x000000, 1);
			entryOverlay.graphics.drawRect(0, 0, 233, 21);
			entryOverlay.graphics.endFill();
			entryOverlay.x = posX;
			entryOverlay.y = posY;
			entryOverlay.alpha = 0;
				
			this.addChild(textBorder);
			this.addChild(personIcon);
			this.addChild(onlineIcon);
			this.addChild(playerName);
			this.addChild(entryOverlay);
		}
	}
}
