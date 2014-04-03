/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.events.*;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class HearthMemberListMC extends MovieClip {
		private var PCList:MovieClip;
		private var NPCList:MovieClip;
		//private var scrollingContainer:ScrollingContainer;
		private var nextXPos:Number = 5;
		private var selectedChild:Avatar = null;
		
		public static const AVATAR_SELECTED:String = "AvatarSelected";
		public static const AVATAR_DESELECTED:String = "AvatarDeselected";
		
		private static const Y_POS:Number = 274;
		
		public function HearthMemberListMC() {
			PCList = new MovieClip;
			NPCList = new MovieClip;
			
			this.addChild(PCList);
			this.addChild(NPCList);
		}
		public function addPC(avatar:MovieClip):void {
			avatar.x = PCList.width;
			//avatar.x = nextXPos;
			avatar.y = Y_POS;
			avatar.addEventListener(MouseEvent.CLICK, avatarClicked);
			PCList.addChild(avatar);
			this.reposition();
			//nextXPos += avatar.width;
		}
		public function addNPC(avatar:MovieClip):void {
			avatar.x = NPCList.width;
			//avatar.x = nextXPos;
			avatar.y = Y_POS;
			avatar.addEventListener(MouseEvent.CLICK, avatarClicked);
			NPCList.addChild(avatar);
			nextXPos += avatar.width;
		}
		public function getSelectedAvatar():MovieClip {
		  return selectedChild;
		}
		private function avatarClicked(e:MouseEvent):void {
		  var currentTarget:Avatar = e.currentTarget as Avatar;
		  if(currentTarget==null){
		    throw new Error("Current target wasn't an avatar. Not sure what it was.");
		  } else {
		    	trace("HearthMemberList sez: an avatar got clicked " + currentTarget.getAvatarId() );
		    	if(currentTarget.isSelected){
		    	  currentTarget.isSelected = false;
		    	  selectedChild = null;
		    	  dispatchEvent(new Event(AVATAR_DESELECTED));
		    	} else {
		    	  if(selectedChild!=null){
		    	    selectedChild.isSelected = false;
		    	  }
		    	  currentTarget.isSelected = true;
		    	  selectedChild = currentTarget;
		    	  dispatchEvent(new Event(AVATAR_SELECTED));
		    	}
	    	}
		}
		private function reposition():void {
 			NPCList.x = PCList.width;
		}
	}
}
