/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class GameLogo extends MovieClip {
		private var logo:Logo_mc;
		private static const BORDER_GAP:int = 3;
		private static const BORDER_WIDTH:int = 2;
		private static const BORDER_COLOUR:Number = 0x09063A;
		
		public static const GAME_LOGO_PRESSED:String = "GameLogoPressed";
		
		public function GameLogo() {
			logo = new Logo_mc();
			
			var backgroundWidth:Number = 2*BORDER_GAP + logo.width + 2* BORDER_WIDTH;
			var backgroundHeight:Number = 2*BORDER_GAP + logo.height + 2*BORDER_WIDTH;
			var background:MovieClip = new MovieClip();
			background.graphics.moveTo(0, 0);
			background.graphics.lineStyle(BORDER_WIDTH, BORDER_COLOUR);
			background.graphics.lineTo(backgroundWidth, 0);
			background.graphics.lineTo(backgroundWidth, backgroundHeight);
			background.graphics.lineTo(0, backgroundHeight);
			background.graphics.lineTo(0, 0);
			this.addChild(background);
			
			logo.x = BORDER_WIDTH + BORDER_GAP;
			logo.y = BORDER_WIDTH + BORDER_GAP;
			logo.buttonMode = true;
			logo.addEventListener(MouseEvent.CLICK, logoClicked);
			this.addChild(logo);
		}
		private function logoClicked (event:MouseEvent):void {
			trace("GameLogo sez: More info please?");
			dispatchEvent(new Event(GAME_LOGO_PRESSED));
		}
	}
}
