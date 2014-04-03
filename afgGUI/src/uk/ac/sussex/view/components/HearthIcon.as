/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;
	import flash.filters.DropShadowFilter;
	import flash.display.MovieClip;

	/**
	 * This is the display for the hearth. Initially it sets up the hut, the click through on the door and the name of the 
	 * hearth. Eventually it may extend to include indicators of wealth, deaths etc. 
	 * @author em97
	 */
	public class HearthIcon extends MovieClip {
		//private var houseShadow:DropShadowFilter;
		private var dropShdwHighlight:DropShadowFilter; 
		
		private var hearthId:int;
		private var houseIcon:HutMC;
		private var doorIcon:MovieClip;
		private var hearthName:TextField;
		private var mouseOver:MouseoverTextField;
		private var selected:Boolean;
		
		public static const HOUSE_CLICKED:String = "houseClicked";
		public static const DOOR_CLICKED:String = "doorClicked";
		
		private static const HOUSE_SCALE:Number = 0.28;
		private static const DOOR_OFFSET_X:Number = 20;
		private static const DOOR_OFFSET_Y:Number = 35;
		private static const NAME_OFFSET_X:Number = 30;
		private static const NAME_OFFSET_Y:Number = 60;
		
		public function HearthIcon() {
			this.setupFilters();
			this.selected = false;
			// door icons req no scaling
			// sets house and door icons - used in VillageView. The door icon gives access to the interior of family homes.
			houseIcon = new HutMC();
			//houseIcon.filters = [houseShadow];
			houseIcon.addEventListener(MouseEvent.CLICK, houseClick);
			houseIcon.buttonMode = true;
			houseIcon.scaleX = houseIcon.scaleY = HOUSE_SCALE;
			this.addChild(houseIcon);
				
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.font = "Calibri";
			txtFormat.size = 12;
			hearthName = new TextField();
			hearthName.defaultTextFormat = txtFormat;	
			hearthName.textColor = 0x000000;
			hearthName.background = true;
			hearthName.backgroundColor = 0xFFFFFF;
			hearthName.border = true;
			hearthName.borderColor = 0x000000;
			hearthName.selectable = false;
			hearthName.autoSize = TextFieldAutoSize.LEFT;
			hearthName.x = NAME_OFFSET_X;
			hearthName.y = NAME_OFFSET_Y; 
			this.addChild(hearthName);
			
			mouseOver = new MouseoverTextField();
			
		}
		public function showDoors():void {
			doorIcon = new MovieClip();
			doorIcon.graphics.beginFill(0x000000);
			doorIcon.graphics.drawRect(0, 0, 20, 23);
			doorIcon.alpha = 0; // make door button invisible
			doorIcon.addEventListener(MouseEvent.CLICK, doorClick);
			doorIcon.addEventListener(MouseEvent.MOUSE_OVER, doorMouseOver);
			doorIcon.addEventListener(MouseEvent.MOUSE_OUT, doorMouseOut);
			doorIcon.x = DOOR_OFFSET_X;
			doorIcon.y = DOOR_OFFSET_Y;		
			doorIcon.buttonMode = true;
			this.addChild(doorIcon);
		}
		public function setHearthId(newId:int):void {
			this.hearthId = newId;
		}
		public function getHearthId():int {
			return this.hearthId;
		}
		/**
		 * Changes the name of the hearth. 
		 */
		public function setHearthName(newName:String):void {
			hearthName.text = newName;
			mouseOver.text = "Enter " + newName + " household";
		}
		public function setHearthNameBgColour(newColour:uint):void{
			this.hearthName.backgroundColor = newColour;
		}
		public function getSelected():Boolean{
			return this.selected;
		}
		public function setSelected(selected:Boolean):void {
			this.selected = selected;
			if(selected){
				houseIcon.filters = [dropShdwHighlight];
			} else {
				houseIcon.filters = [];
			}
		}
		public function destroy():void {
			if(mouseOver!=null){
				mouseOver.removeFromScreen();
			}
		}
		private function setupFilters ():void {
			//houseShadow = new DropShadowFilter();
			
			dropShdwHighlight = new DropShadowFilter();
			dropShdwHighlight.distance = 0;
			dropShdwHighlight.angle = 0;
			dropShdwHighlight.color = 0xFFFFFF;
			dropShdwHighlight.alpha = 0.8;
			dropShdwHighlight.blurX = 6;
			dropShdwHighlight.blurY = 6;
			dropShdwHighlight.strength = 3;
			dropShdwHighlight.quality = 15;
			dropShdwHighlight.inner = false;
			dropShdwHighlight.knockout = false;
			dropShdwHighlight.hideObject = false;
		}
		private function houseClick(e:MouseEvent):void {
			dispatchEvent(new Event(HOUSE_CLICKED));
		}
		private function doorClick(e:MouseEvent):void {
			dispatchEvent(new Event(DOOR_CLICKED));
		}
		private function doorMouseOver(e:MouseEvent):void {
			mouseOver.addToScreen(this, mouseX + 5, mouseY - mouseOver.height);
		}
		private function doorMouseOut(e:MouseEvent):void {
			mouseOver.removeFromScreen();
		}
	}
}
