/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.display.Sprite;
	import flash.text.*;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class SplashScreen extends MovieClip {
		public function SplashScreen() {
			setupSplashScreen();
		}
		private function setupSplashScreen():void {
			var titleFormat:TextFormat = new TextFormat();
			titleFormat.color = 0x09063A;
			titleFormat.size = 68;
			titleFormat.size = 86;
			titleFormat.font = "Arial";
			titleFormat.bold = true;
			titleFormat.leftMargin = 0;
			titleFormat.rightMargin = 0;
			titleFormat.align = TextFormatAlign.CENTER;
			
			var title:TextField = new TextField();
			title.defaultTextFormat = titleFormat;								
			title.border = false;
			title.background = false;
			title.wordWrap = false;
			title.selectable = false;
			title.width = 640;
			title.height = 100;
			title.x = 130;
			title.y = 170;
			title.text = "African Farmer";
			this.addChild(title);
			
			var titleUL:Sprite = new Sprite();
			titleUL.graphics.beginFill(0xf26118);  // 0xf15100  0xff7733
			titleUL.graphics.drawRect(0, 0, 600, 5);
			titleUL.graphics.endFill();
			titleUL.x = 145;
			titleUL.y = 262;
			this.addChild(titleUL);
			
			var subFormat:TextFormat = new TextFormat();
			subFormat.color = 0x00665a;
			subFormat.size = 36;
			subFormat.font = "Arial";
			subFormat.bold = true;
			subFormat.leftMargin = 0;
			subFormat.rightMargin = 0;
			subFormat.align = TextFormatAlign.CENTER;
			
			var subTitleField:TextField = new TextField();
			subTitleField.defaultTextFormat = subFormat;								
			subTitleField.border = false;
			subTitleField.background = false;
			subTitleField.wordWrap = false;
			subTitleField.selectable = false;
			subTitleField.width = 640;
			subTitleField.height = 50;
			subTitleField.x = 130;
			subTitleField.y = 335;
			subTitleField.text = "A Farming Simulation Game";
			this.addChild(subTitleField);
			
			var familyGroup:FamilyGroup = new FamilyGroup();
			familyGroup.x = 820;
			familyGroup.y = 270;
			this.addChild(familyGroup);
			
			var adFormat:TextFormat = new TextFormat();
			adFormat.font = "Arial";
			adFormat.size = 12;
			adFormat.bold = true;
			adFormat.align = TextFormatAlign.CENTER;
			
			var smartFoxAd:TextField = new TextField();
			smartFoxAd.defaultTextFormat = adFormat;
			smartFoxAd.height = 34;
			smartFoxAd.width = 180;
			smartFoxAd.selectable = false;
			smartFoxAd.border = false;
			smartFoxAd.textColor = 0x09063A;
			smartFoxAd.wordWrap = false;
			smartFoxAd.x = 390;
			smartFoxAd.y = 600;
			smartFoxAd.text = "Powered by SmartFoxServer";
			
			this.addChild(smartFoxAd);
		}
	}
}
