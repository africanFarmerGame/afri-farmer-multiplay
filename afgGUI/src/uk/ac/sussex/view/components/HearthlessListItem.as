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
