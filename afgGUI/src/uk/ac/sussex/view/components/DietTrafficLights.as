/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.text.*;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class DietTrafficLights extends MovieClip {
		private var carbLevelIcon:DietLevelIcon_mc; // coloured squares
		private var proteinLevelIcon:DietLevelIcon_mc; 
		private var nutrientLevelIcon:DietLevelIcon_mc;	
		private var background:MovieClip;
		
		//private static var ICON_SIZE:uint = 9;
		private static var TEXT_XPOS:uint = 2;
		
		public function DietTrafficLights() {
			background = new MovieClip();
			sizePosDietLevelIcons();
		}
		public function updateDietLevelIcons(carbLevel:String, proteinLevel:String, nutrientLevel:String):void {
			carbLevelIcon.gotoAndStop(carbLevel);
			proteinLevelIcon.gotoAndStop(proteinLevel);
			nutrientLevelIcon.gotoAndStop(nutrientLevel);
		}
		private function sizePosDietLevelIcons():void {	
			
			var carbField:TextField = new TextField();
			setupDietNutTxt(carbField);
			carbField.x = TEXT_XPOS; 
			carbField.y = 2;
			carbField.text = "Carb";
			
			var lightXPos:Number = carbField.x + carbField.width + 2;
			carbLevelIcon = new DietLevelIcon_mc();		
			carbLevelIcon.width = carbField.height;
			carbLevelIcon.height = carbField.height;
			carbLevelIcon.x = lightXPos;
			carbLevelIcon.y = carbField.y;
			background.addChild(carbField);
			background.addChild(carbLevelIcon);
			
			var proteinField:TextField = new TextField();
			setupDietNutTxt(proteinField);
			proteinField.x = TEXT_XPOS;
			proteinField.y = carbField.y + carbField.height + 2;
			proteinField.text = "Prot";
			
			proteinLevelIcon = new DietLevelIcon_mc();
			proteinLevelIcon.width = proteinField.height;
			proteinLevelIcon.height = proteinField.height;
			proteinLevelIcon.x = lightXPos;
			proteinLevelIcon.y = proteinField.y;
			background.addChild(proteinField);
			background.addChild(proteinLevelIcon);
			
			var nutField:TextField = new TextField();
			setupDietNutTxt(nutField);
			nutField.x = TEXT_XPOS;
			nutField.y = proteinField.y + proteinField.height + 2;
			nutField.text = "Nutn";
			
			nutrientLevelIcon = new DietLevelIcon_mc();
			nutrientLevelIcon.width = nutField.height;
			nutrientLevelIcon.height = nutField.height;
			nutrientLevelIcon.x = lightXPos;
			nutrientLevelIcon.y = nutField.y;
			background.addChild(nutField);
			background.addChild(nutrientLevelIcon);
			
			background.graphics.lineStyle(1, 0x000000);
			background.graphics.beginFill(0xffffff);
			background.graphics.drawRect(0, 0, nutrientLevelIcon.x + nutrientLevelIcon.width + 2, nutrientLevelIcon.y + nutrientLevelIcon.height + 2);
			this.addChild(background);
		}
		private function setupDietNutTxt(tField:TextField):void {	
			var tFormat:TextFormat = new TextFormat();
			tFormat.font = "Arial";
			tFormat.size = 11;
			tFormat.bold = false;
			tFormat.align = TextFormatAlign.LEFT;
			tFormat.leading = -3;
			tFormat.leftMargin = 0;
			tFormat.rightMargin = 0;
			
			tField.defaultTextFormat = tFormat;	
			tField.textColor = 0x000000;
			tField.background = false;
			tField.border = false;
			tField.wordWrap = false;
			tField.selectable = false;
			tField.width = 35;
			tField.height = 14;
		}
	}
}
