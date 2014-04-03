/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.text.*;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class GameYearDisplay extends MovieClip {
		private var yearLabel:TextField;
		private var yearNumber:TextField;
		public function GameYearDisplay() {
			var yearFormat:TextFormat = new TextFormat();
			yearFormat.font = "Arial";
			yearFormat.size = 25;
			yearFormat.color = 0x09063A;
			yearFormat.align = TextFormatAlign.CENTER;
			yearFormat.bold = true;
			
			yearLabel = new TextField();
			yearLabel.text = "YEAR";
			yearLabel.setTextFormat(yearFormat);
			yearLabel.height = 29;
			yearLabel.selectable = false;
			//yearLabel.x = 750;
			//yearLabel.y = 6;
			
			yearFormat.size = 42;
			yearNumber = new TextField();
			yearNumber.defaultTextFormat = yearFormat;
			yearNumber.text = "1";
			yearNumber.height = 45;
			yearNumber.x = yearLabel.x + (yearLabel.width - yearNumber.width)/2;
			//yearNumber.y = 35;
			yearNumber.y = yearLabel.y + 29;
			yearNumber.selectable = false;
			this.addChild(yearLabel);
			this.addChild(yearNumber);
		}
		public function setGameYearNumber(newNumber:int):void {
			yearNumber.text = newNumber.toString();
		}
	}
}
