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
