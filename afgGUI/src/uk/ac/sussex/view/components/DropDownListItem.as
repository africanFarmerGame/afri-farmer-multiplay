/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.events.MouseEvent;
	import uk.ac.sussex.model.valueObjects.FormFieldOption;
	import uk.ac.sussex.view.components.ListItem;

	/**
	 * @author em97
	 */
	public class DropDownListItem extends ListItem {
		var textField:GameTextField;
		var noteField:MouseoverTextField;
		
		public function DropDownListItem() {
			super();
			setupItem();
		}
		public function setText(newText:String):void {
			textField.text = newText;
		}
		public function getText():String {
			return textField.text;
		}
		public function setStatus(optionStatus:int):void {
			switch (optionStatus) {
				case FormFieldOption.VALID:
					textField.setTextColour(0x000000);
					break;
				case FormFieldOption.INVALID:
					textField.setTextColour(0xFF0000);
					break;
			}
		}
		public function setNotes(newNotes:String):void {
			if (newNotes!=null){
				noteField.text = newNotes;
				this.addEventListener(MouseEvent.MOUSE_OVER, showNotes);
				this.addEventListener(MouseEvent.MOUSE_OUT, hideNotes);
			} else {
				noteField.text = "";
				this.removeEventListener(MouseEvent.MOUSE_OVER, showNotes);
				this.removeEventListener(MouseEvent.MOUSE_OUT, hideNotes);
			}
		}
		override public function destroy():void {
			if(noteField!=null){
				noteField.removeFromScreen();
			}
		}
		override public function set width(newWidth:Number):void {
			textField.width = newWidth;
		}
		private function setupItem():void {
			textField = new GameTextField();
			textField.readonly = true;
			this.addChild(textField);
			noteField = new MouseoverTextField();
		}
		private function showNotes(e:MouseEvent):void {
			if(this.parent != null){
				this.parent.addChild(this);
			}
			noteField.addToScreen(this, this.width - 10, this.height/2);
		}
		private function hideNotes(e:MouseEvent):void {
			noteField.removeFromScreen();
		}
	}
}
