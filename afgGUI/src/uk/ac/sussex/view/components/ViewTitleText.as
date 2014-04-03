/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.text.*;
	//import flash.filters.*;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class ViewTitleText extends MovieClip {
		private var titleTxt:TextField;
		private var titleBorder:ViewTitleBorder;
		//private var titleTxtShadow:DropShadowFilter;
		//private var glowFilter:GlowFilter;
		
		public function ViewTitleText() {
			//this.setupFilter();
			this.setupTitleTxt();
			titleBorder = new ViewTitleBorder();
			titleBorder.width = 230;
			titleBorder.height = 36.5;
			this.addChild(titleBorder);
			this.addChild(titleTxt);
		}
		public function newTitleText (newTxt:String) : void {
			trace("ViewTitleText sez: We're trying to display title text - " + newTxt);
			titleTxt.text = newTxt;
			//titleTxt.x = 272 + (416 - titleTxt.width)/2;
		}
		private function setupTitleTxt():void {
			var titleFormat:TextFormat = new TextFormat();
			/*titleFormat.font = "Calibri";
			titleFormat.size = 22;
			titleFormat.bold = false;
			titleFormat.align = TextFormatAlign.CENTER;
			titleFormat.leftMargin = 20;
			titleFormat.rightMargin = 20;
			
			
			titleTxt.defaultTextFormat = titleFormat;	
			titleTxt.textColor = 0x000000;
			titleTxt.background = true;
			titleTxt.backgroundColor = 0xFFCC00;
			titleTxt.border = true;
			titleTxt.borderColor = 0x000000;
			titleTxt.wordWrap = false;
			titleTxt.autoSize = TextFieldAutoSize.CENTER;
			titleTxt.y = 103;
			titleTxt.selectable = false;
			//titleTxt.filters = [glowFilter, titleTxtShadow];
			titleTxt.text = "";*/
			
			titleFormat.font = "Arial";
			titleFormat.size = 16;
			titleFormat.bold = true;
			titleFormat.align = TextFormatAlign.CENTER;
			titleFormat.leftMargin = 20;
			titleFormat.rightMargin = 20;
			
			titleTxt = new TextField();
			titleTxt.defaultTextFormat = titleFormat;	
			titleTxt.textColor = 0x09063A;
			titleTxt.background = false;
			titleTxt.border = false;
			titleTxt.wordWrap = false;
			titleTxt.y = 7;
			titleTxt.selectable = false;
			titleTxt.width = 230;
			titleTxt.height = 25;
			//titleTxt.filters = [glowFilter];
			titleTxt.text = "";
		}
		/*private function setupFilter():void {
			titleTxtShadow = new DropShadowFilter();
			titleTxtShadow.distance = 0;
			titleTxtShadow.angle = 225;
			titleTxtShadow.color = 0x0099FF;
			titleTxtShadow.alpha = 1;
			titleTxtShadow.blurX = 2;
			titleTxtShadow.blurY = 2;
			titleTxtShadow.strength = 2;
			titleTxtShadow.quality = 15;
			titleTxtShadow.inner = false;
			titleTxtShadow.knockout = false;
			titleTxtShadow.hideObject = false;
			
			glowFilter = new GlowFilter();
			glowFilter.color = 0x000000;
			glowFilter.alpha = 0.6;
			glowFilter.blurX = 4;
			glowFilter.blurY = 4;
			glowFilter.strength = 1;
			glowFilter.quality = 15;
			glowFilter.inner = true;	
		}*/
	}
}
