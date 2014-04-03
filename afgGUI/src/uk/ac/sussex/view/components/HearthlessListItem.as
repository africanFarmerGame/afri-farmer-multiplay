/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.valueObjects.PlayerChar;
	import uk.ac.sussex.view.components.ListItem;

	/**
	 * @author em97
	 */
	public class HearthlessListItem extends ListItem {
		private var pc:PlayerChar;
		public function HearthlessListItem(pc:PlayerChar) {
			super();
			this.setItemID(pc.getId().toString());
			this.pc = pc;
			this.setup();
		}
		private function setup():void {
			var pcRole:String = pc.getRole();
			var avatar:Avatar;
			switch(pcRole){	
				case ApplicationFacade.MAN:		
					avatar = new Avatar(Avatar.MAN, pc.getAvatarBody());
					break;
				case ApplicationFacade.WOMAN:
					avatar = new Avatar(Avatar.WOMAN, pc.getAvatarBody());
					break;
				default:
					avatar = new Avatar(Avatar.BABY, pc.getAvatarBody());
			}
			var scale:Number = 40/avatar.width;
			avatar.scaleX = avatar.scaleY = scale;
			avatar.setIll(false);
			avatar.y = avatar.height;
			avatar.setMouseoverText(pc.getFirstName() + " " + pc.getFamilyName());
			this.addChild(avatar);
			
		}
	}
}
