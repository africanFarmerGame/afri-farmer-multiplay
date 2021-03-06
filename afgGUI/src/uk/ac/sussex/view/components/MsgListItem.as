/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
