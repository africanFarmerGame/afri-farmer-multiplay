/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class PlayerCharDetailPanel extends MovieClip {
		private var pcName:GameDisplayText;
		private var gameName:GameDisplayText;
		private var roleIndicator:MovieClip;
		
		public function PlayerCharDetailPanel() {
			//Eeep. Right. Need the player char name, the user name and the game name?
			pcName = new GameDisplayText();
			pcName.setDisplayText("Pending...");
			pcName.x = 10;
			pcName.y = 10;
			this.addChild(pcName);
			gameName = new GameDisplayText();
			gameName.setDisplayText("Pending...");
			gameName.x = pcName.width + 20;
			gameName.y = 10;
			this.addChild(gameName);
			roleIndicator = new Unknown();
			roleIndicator.x = gameName.x + gameName.width + 20;
			roleIndicator.y = 10;
			this.addChild(roleIndicator);
		}
		public function displayPCName(newPCName:String):void{
			pcName.setDisplayText(newPCName);
		}
		public function displayGameName(newGameName:String):void{
			gameName.setDisplayText(newGameName);
		}
		public function displayRole(roleID:String):void{
			roleIndicator.parent.removeChild(roleIndicator);
			roleID = roleID.toUpperCase();
			switch (roleID){
				case "MAN":
					roleIndicator = new Man();
					break;
				case "WOMAN":
					roleIndicator = new Woman();
					break;
				case "BANKER":
					roleIndicator = new Bank();
					break;
				default:
					roleIndicator = new MovieClip();
			}
			roleIndicator.x = gameName.x + gameName.width;
			roleIndicator.y = 10;
			this.addChild(roleIndicator);
		}
	}
}
