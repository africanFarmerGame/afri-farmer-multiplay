/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components  {
	/*
	DietContentList displays a list of diet contents 
	 */
	 
	import flash.display.*;
	import flash.text.*;
	
	public class DietContentList extends MovieClip {
	
		private var textBg:MovieClip;
		private var dietContentTxt:TextField = new TextField();
		private var contentLabel:TextField = new TextField();
		private static const xPos:int = 2;
		private static const yPos:int = 2;
		
		public function DietContentList() {	
			this.setupDietContentsLabel(contentLabel,xPos,yPos);
			this.setupDietTxt(dietContentTxt,xPos,yPos + 30);
			contentLabel.text = "Contents";
			dietContentTxt.text = "";
			displayDietContent();
		}
		public function reset():void {
			updateContents("");
		}
		public function cleanUp():void {
			reset();
			if(contentLabel.parent!=null){
				contentLabel.parent.removeChild (contentLabel);			
			}
			if(dietContentTxt.parent!=null){
				dietContentTxt.parent.removeChild(dietContentTxt);
			}
		}
		public function updateContents(newTxt:String):void {
			dietContentTxt.text = newTxt;
			textBg.graphics.clear();
			textBg.graphics.beginFill(0x000000, 0.15);
			textBg.graphics.drawRect(0, 0, 98, dietContentTxt.textHeight + 40);
			textBg.graphics.endFill();
		}
		private function setupDietContentsLabel(tField:TextField,xPos:int,yPos:int):void {			
			var tFormat:TextFormat = new TextFormat();
			tFormat.font = "Calibri";
			tFormat.size = 22;
			tFormat.bold = true;
			tFormat.align = TextFormatAlign.LEFT;
			tField.defaultTextFormat = tFormat;	
			tField.textColor = 0xffffff;
			tField.background = false;
			tField.border = false;
			tField.wordWrap = false;
			tField.x = xPos;
			tField.y = yPos;
			tField.selectable = false;
		}
		private function setupDietTxt(tField:TextField,xPos:int,yPos:int):void {	
			var tFormat:TextFormat = new TextFormat();
			tFormat.font = "Calibri";
			tFormat.size = 13;
			tFormat.bold = false;
			tFormat.align = TextFormatAlign.LEFT;
			tFormat.leading = -1;
			tField.defaultTextFormat = tFormat;	
			tField.textColor = 0xffffff;
			tField.background = false;
			tField.border = false;
			tField.wordWrap = true;
			tField.x = xPos;
			tField.y = yPos;
			tField.width = 95;
			tField.selectable = false;
		}
		private function displayDietContent():void {
			textBg = new MovieClip();
			textBg.graphics.beginFill(0x000000, 0.15);
			textBg.graphics.drawRect(0, 0, 98, 30);
			textBg.graphics.endFill();	
			this.addChild(textBg);
			this.addChild (contentLabel);
			this.addChild(dietContentTxt);
		}
	}
}