/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.text.*;
	import flash.events.*;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class SubMenuButton extends MovieClip {
		public static const SUB_MENU_BUTTON_CLICKED:String = "subMenuButtonClicked";
		private var buttonName:String;
		private var buttonText:TextField;
		private var blankBtn:BlankBtn;
		
		private const TEXT_COLOUR:uint = 0xF4EFA5;
		
		public function SubMenuButton() {
			var tFormat:TextFormat = new TextFormat();
			tFormat.font = "Arial";
			tFormat.size = 14;
			tFormat.bold = true;
			tFormat.align = TextFormatAlign.CENTER;
			
			blankBtn = new BlankBtn();
			blankBtn.width = 93;
			blankBtn.height = 28;
			blankBtn.gotoAndStop("UP");
			this.addChild(blankBtn);
			
			buttonText = new TextField();
			buttonText.height = 20;
			buttonText.y = (blankBtn.height - buttonText.height) / 2;
			buttonText.selectable = false;
			buttonText.defaultTextFormat =  tFormat;
			buttonText.textColor = TEXT_COLOUR;
			buttonText.x = 2;
			buttonText.width = blankBtn.width - 4;
			this.addChild(this.buttonText);
			
			//buttonText.mouseChildren = false;
			this.buttonMode = true;
			
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			
		}
		public function setButtonName(newName:String):void {
			this.buttonName = newName;
		}
		public function getButtonName():String {
			return this.buttonName;
		}
		public function setButtonText(newText:String):void {
			if(newText!=null){
				this.buttonText.text = newText.toUpperCase();
			}
		}
		private function mouseUp(e:MouseEvent):void {
			this.dispatchEvent(new Event(SUB_MENU_BUTTON_CLICKED));
			blankBtn.gotoAndStop("OVER");
		}
		private function mouseDown(e:MouseEvent):void {
			blankBtn.gotoAndStop("DOWN");
		}
		private function mouseOver(e:MouseEvent):void {
			blankBtn.gotoAndStop("OVER");
		}
		private function mouseOut(e:MouseEvent):void {
			blankBtn.gotoAndStop("UP");
		}
	}
}
