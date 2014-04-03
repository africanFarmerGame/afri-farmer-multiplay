/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.events.Event;
	/*
	DirectoryMgr generates a scrollpanel containing a directory list of players for communication.
	The list os either a list of all players signed up to the game or the players  located in the 
	currently displayed view (when the "talk" button is selected).
	 */
	
	import flash.display.*;
	
	import uk.ac.sussex.model.valueObjects.PlayerChar;
	
	public class DirectoryMgr extends Sprite{

		private var phoneDirectory:Array; // list of all players located in current game
		private var talkDirectory:Array; // list of all players in view
		private var workingDir:int; // current contents of workingDirectory[], defaults to talkDirectory[]
		private var scrollingList:ScrollingList;
		
		public static const DIR_TALK:uint = 0;
		public static const DIR_PHONE:uint = 1;
		
		public static const PLAYER_SELECTED:String = "DirectoryPlayerSelected";
		
		public function DirectoryMgr():void {
			workingDir = DIR_TALK;
			setupDirectoryPanel();
			scrollingList.addEventListener(ScrollingList.ITEM_SELECTED, playerSelected);
		}
		public function updatePhoneDirectory(playersList:Array):void {
			// familyName, firstName, Gender, relation (0 = none, 1 = family, 2 = relative), online, location
			phoneDirectory = new Array();
			for each (var player:PlayerChar in playersList){
				phoneDirectory.push(player);
			}
			phoneDirectory = phoneDirectory.sort(sortOnSurname);
		}
		public function updateTalkDirectory(playersList:Array):void {
			// the talk directory is a filtered version of the phone directory.
			talkDirectory = new Array();
			for each (var player:PlayerChar in playersList){
				talkDirectory.push(player);
			}
			talkDirectory = talkDirectory.sort(sortOnSurname);
		}
		public function updateDirectory(list:int):void {			
			workingDir = list;
			scrollingList.resetToTop();
			scrollingList.clearList();
			fillDirectory();
		}
		public function getSelectedPlayer():PlayerChar {
			var selectedItem:DirectoryListItem =  scrollingList.getItemWithID(scrollingList.getCurrentValue()) as DirectoryListItem;
			return selectedItem.getPlayerChar();
		}
		public function getSelectedPlayerId():int {
			var selectedStringID:String = this.scrollingList.getCurrentValue();
			if(selectedStringID== null){
				return -1;
			} else {
				var selectedId:int = int(selectedStringID);		
				return selectedId;
			}
		}
		public function clearSelectedPlayer():void {
			this.scrollingList.clearCurrentSelection();
		}

		/**
		 * fillDirectory adds the entries  to the directory container.
		 */ 
		private function fillDirectory():void {
			var playerChar:PlayerChar;
			if(workingDir == DIR_TALK){
				for each (playerChar in talkDirectory){
					this.addListItem(playerChar);
				}
			} else {
				for each (playerChar in phoneDirectory){
					this.addListItem(playerChar);
				}
			}
		}
		private function addListItem(player:PlayerChar):void {
			var thisEntry:DirectoryListItem = new DirectoryListItem(player);
			scrollingList.addItem(thisEntry);
		}
		/**
		 * setupDirectoryPanel creates a new scrolling list object of the right size 
		 * and adds it to the screen at the right place.
		 */
		private function setupDirectoryPanel():void {
			var baseY:int = 13;
			var panelWidth:int = 245;
			var maskHeight:int = 187;
			
			scrollingList = new ScrollingList(panelWidth, maskHeight);
			scrollingList.y = baseY;
			scrollingList.setBorderColour(0xCDCDCD);
			scrollingList.showBackgroundFilter(false);

			this.addChild(this.scrollingList);
		}
		private function playerSelected(e:Event):void {
			dispatchEvent(new Event(PLAYER_SELECTED));
		}
		private function sortOnSurname(a:PlayerChar, b:PlayerChar):int{
			var aName:String = a.getFamilyName().toLowerCase();
			var bName:String = b.getFamilyName().toLowerCase();
			if(aName>bName){
				return 1;
			} else if (aName<bName) {
				return -1;
			} else {
				return 0;
			}
		}
	}
	
}
