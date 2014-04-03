/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.events.*;
	import flash.text.*;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class GameRadioButton extends MovieClip {
		public static const VALUE_CHANGED:String = "RadioButtonMCValueChanged";
		
		private static const GAP_SIZE:Number = 3;
		private static const DISABLED_TEXT_COLOUR:uint = 0x565656;
		private static const ENABLED_TEXT_COLOUR:uint = 0x000000;
		
		private var radio:RadioButtonMC;
		private var label:TextField;
		private var myValue:String;
		
		public function GameRadioButton() {
			radio = new RadioButtonMC();
			
			label = new TextField();
			label.selectable = false;
			label.height = 16;
			label.x = radio.width + GAP_SIZE;
			
			this.addChild(radio);
			this.addChild(label);
			
			radio.y = (this.height - radio.height) /2;
			label.y = (this.height - label.height) /2;
			
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
		}
		override public function set height(newHeight:Number):void{
			label.height = newHeight;
			if(newHeight<radio.height){
				radio.height = newHeight;
			}
			radio.y = newHeight/2 - radio.height/2;
		}
		override public function set width(newWidth:Number):void {
			var labelWidth:Number = newWidth - radio.width;
			label.width = labelWidth;
		}
		override public function set enabled(enabled:Boolean):void{
			super.enabled = enabled;
			if(enabled){
				this.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
				this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				this.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
				this.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
				label.textColor = ENABLED_TEXT_COLOUR;
				label.alpha = 1;
			} else {
				this.removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
				this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				this.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
				this.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
				label.textColor = DISABLED_TEXT_COLOUR;
				label.alpha = 0.8;
			}
			radio.enabled = enabled;
		}
		public function set selected(isSelected:Boolean):void{
			radio.selected = isSelected;
		}
		public function set labelText(labelText:String):void {
			label.text = labelText;
		}
		public function get value():String {
			return myValue;
		}
		public function set value(newValue:String):void {
			myValue = newValue;
		}
		public function setLabelFormat(newFormat:TextFormat):void {
			label.setTextFormat(newFormat);
		}
		private function mouseOver(e:MouseEvent):void {
			radio.mouseOver();
		}
		private function mouseDown(e:MouseEvent):void {
			radio.mouseDown();
		}
		private function mouseUp(e:MouseEvent):void {
			
			radio.selected = !radio.selected;
			dispatchEvent(new Event(VALUE_CHANGED));
			radio.mouseUp();
		}
		private function mouseOut(e:MouseEvent):void {
			radio.mouseOut();
		}
	}
}
