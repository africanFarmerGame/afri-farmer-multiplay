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
	public class SeasonStageMC extends MovieClip {
		//private var highlightFormat:TextFormat;
		private var timelineFormat:TextFormat;
		private var background:MovieClip;
		private var highlightBackground:MovieClip;
		private var timelineText:TextField;
		private var currentHighlight:Boolean;
		
		private static const NORMAL_WIDTH:Number = 120;
		private static const NORMAL_HEIGHT:Number = 21;
		private static const BACKGROUND_COLOUR:uint = 0x09063A;
		private static const TEXT_COLOUR:uint = 0xF4EFA5;
		
		public function SeasonStageMC() {
			this.setup();
		}
		public function set label(newLabel:String):void {
			if(newLabel!=null){
				timelineText.text = newLabel.toUpperCase();
			}
		}
		public function set highlight(highlight:Boolean):void {
			
			if(highlight!=currentHighlight){
				//Clear all the current children.
				var maxChildren:int = this.numChildren -1;
				
				for (var child:int = maxChildren; child>=0; child--){
					this.removeChildAt(child);
				}
				var text:String = timelineText.text;
				/*if(highlight){
					this.addChild(highlightBackground);
					timelineText.x = (highlightBackground.width - timelineText.width)/2 - 3;
					timelineText.y = 0;
					timelineText.defaultTextFormat = highlightFormat;
					this.addChild(timelineText);
				} else {*/
					this.addChild(background);
					timelineText.x = (background.width - timelineText.width)/2;
					timelineText.y = 0;
					timelineText.defaultTextFormat = timelineFormat;
					this.addChild(timelineText); 
			//	}
				timelineText.text = text;
				currentHighlight = highlight;
			}
			
		}
		private function setup():void {
			background = new MovieClip(); 
			//background.graphics.lineStyle(1, 0x000000);
			background.graphics.beginFill(BACKGROUND_COLOUR); 
			background.graphics.drawRect(0,0,NORMAL_WIDTH,NORMAL_HEIGHT);
			background.graphics.endFill();
			
			highlightBackground = new MovieClip();
			highlightBackground.graphics.lineStyle(2, 0xffffff);
			highlightBackground.graphics.beginFill(BACKGROUND_COLOUR);
			highlightBackground.graphics.drawRect(-4, -2, NORMAL_WIDTH + 4, NORMAL_HEIGHT + 4);
			highlightBackground.graphics.endFill();
			
			/*highlightFormat = new TextFormat();
			highlightFormat.font = "Calibri";
			highlightFormat.size = 16;
			highlightFormat.color = 0x000000;
			highlightFormat.align = TextFormatAlign.CENTER;
			*/
			timelineFormat = new TextFormat();
			timelineFormat.font = "Calibri";
			timelineFormat.size = 14;
			timelineFormat.color = TEXT_COLOUR;
			timelineFormat.align = TextFormatAlign.CENTER;
			
			timelineText = new TextField();
			timelineText.selectable = false;
			timelineText.autoSize = TextFieldAutoSize.CENTER;
			//timelineText.border = true;
			
			currentHighlight = true;
			this.highlight = false;
		}
		
		
	}
}
