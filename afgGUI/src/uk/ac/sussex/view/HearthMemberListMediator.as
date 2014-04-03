/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view {
  import uk.ac.sussex.model.valueObjects.PlayerChar;
  import flash.events.Event;
	import uk.ac.sussex.model.valueObjects.HearthMember;
	import uk.ac.sussex.model.valueObjects.AnyChar;
	import uk.ac.sussex.view.components.Avatar;
	import uk.ac.sussex.model.HearthMembersListProxy;
	import uk.ac.sussex.view.components.HearthMemberListMC;
	import uk.ac.sussex.general.ApplicationFacade;
	import org.puremvc.as3.multicore.interfaces.*;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	/**
	 * @author em97
	 */
	public class HearthMemberListMediator extends Mediator implements IMediator {
		public static const NAME:String = "HEARTH_LIST_MEDIATOR";
		public static const Y_POS:uint = 30;
		
		private var hearthId:int;
		private var hmlProxy:HearthMembersListProxy;
		
		public function HearthMemberListMediator(hearthId:int) {
			this.hearthId = hearthId;
			super(NAME, null);
		}
		override public function listNotificationInterests():Array {
			return [HearthMembersListProxy.HEARTH_NPC_MEMBER_ADDED, 
					HearthMembersListProxy.HEARTH_PC_MEMBER_ADDED 
					];
		}
		override public function handleNotification (note:INotification):void {
			switch (note.getName()){
				case HearthMembersListProxy.HEARTH_PC_MEMBER_ADDED:
					trace("HearthMemberListMediator sez: Should be updating the pc members now.");
					this.updatePCs();
					break;
				case HearthMembersListProxy.HEARTH_NPC_MEMBER_ADDED:
					trace("HearthMemberListMediator sez: Should be updating the npc members now.");
					this.updateNPCs();
					break;
			}
		}
		private function updatePCs():void {
			var pcs:Array = hmlProxy.getPCMembers(hearthId);
			for each (var pc:AnyChar in pcs){
				var pcMC:Avatar;
				if(pc.getRole() == ApplicationFacade.MAN){
					pcMC = new Avatar(Avatar.MAN, pc.getAvatarBody());					
				} else {
					pcMC = new Avatar(Avatar.WOMAN, pc.getAvatarBody());
				}
				
				pcMC.setAvatarId(pc.getId());
				pcMC.setAlive(pc.getAlive());
				pcMC.setIll((pc.getAlive()==2));
				if(pc.getAlive()==2){
					pcMC.setMouseoverText(pc.getFirstName() + " " + pc.getFamilyName() + "\n(" + pc.getHealthHazard() + ")");
				} else {
					pcMC.setMouseoverText(pc.getFirstName() + " " + pc.getFamilyName());
				}
				hearthMemberList.addPC(pcMC);
			}
			sendNotification(ViewAreaMediator.REFRESH_VIEW_COMPONENT);
		}
		private function updateNPCs():void {
			var npcs:Array = hmlProxy.getNPCMembers(hearthId);
			for each (var npc:HearthMember in npcs){
				var avatarType:String;
				var avatarScale:Number;
				var age:int = npc.getAge();
				if(age<2){
					avatarType = Avatar.BABY;
					avatarScale = 0.80 + 0.2 * (age/2);
				} else {
					if(npc.getRole()==ApplicationFacade.MAN){
						if(age>=14){
							avatarType = Avatar.MAN;
							avatarScale = Math.min(1, 0.85 + 0.1*((age-14)/(18-14)));
						} else {	
							avatarType = Avatar.BOY;
							avatarScale = 0.6 + 0.4*((age-2)/(14-2));
						}
					} else {
						if(age>=14){
							avatarType = Avatar.WOMAN;
							avatarScale = Math.min(1, 0.85 + 0.15*((age-14)/(18-14)));
						} else {
							avatarType = Avatar.GIRL;
							avatarScale = 0.6 + 0.4*((age-2)/(14-2));
						}
					}
				}
				var npcMC:Avatar = new Avatar(avatarType, npc.getAvatarBody());
				npcMC.setAvatarId(npc.getId());
				npcMC.setAlive(npc.getAlive());
				npcMC.setIll((npc.getAlive()==2));
				npcMC.scaleX = npcMC.scaleY = avatarScale;
				if(npc.getAlive()==2){
					npcMC.setMouseoverText(npc.getFirstName() + " " + npc.getFamilyName() + "\n(" + npc.getHealthHazard() + ")");
				} else {
					npcMC.setMouseoverText(npc.getFirstName() + " " + npc.getFamilyName());
				}
				hearthMemberList.addNPC(npcMC);
			}
			sendNotification(ViewAreaMediator.REFRESH_VIEW_COMPONENT);
		}
		private function deselectAvatar(e:Event):void {
		  trace("HearthMemberListMediator sez: Avatar deselected");
		  sendNotification(ApplicationFacade.REVERT_TEMP_INFO_TEXT);
		}
		private function selectAvatar(e:Event):void {
			sendNotification(ApplicationFacade.REVERT_TEMP_INFO_TEXT);
			var displayText:String = "Hearth Member: ";
		  	if(hmlProxy!=null){
				var member:Avatar = hearthMemberList.getSelectedAvatar() as Avatar;
				var memberId:int = member.getAvatarId();
				var memberDetails:AnyChar = hmlProxy.getMember(memberId);
				if(memberDetails!=null){
					displayText+="\n\nName: " + memberDetails.getFirstName() + " " + memberDetails.getFamilyName();
					displayText += "\nAge: ";
					if(memberDetails is PlayerChar){
						 displayText += "Adult";
					} else if(memberDetails is HearthMember) {
						var npc:HearthMember = memberDetails as HearthMember;
						var age:int = npc.getAge();
						if(age<14){
							displayText += age;
							displayText += (age<8)?" (Baby)":" (Child)";
						} else {
							displayText += "Adult";
						}
					}
					displayText += "\nGender: " ;
					if(memberDetails.getRole()=="MAN"){
						displayText += "Male";
					} else {
						displayText += "Female";
					}
					displayText+="\nDiet: " + memberDetails.getCurrentDiet();
					if(memberDetails.getHealthHazard()!=null){
						displayText+="\nCurrently in hospital with " + memberDetails.getHealthHazard();
					} else {
						//displayText+="\nTasks:";
					}
				}
			}
			sendNotification(ApplicationFacade.DISPLAY_TEMP_INFO_TEXT, displayText);
		}
		protected function get hearthMemberList():HearthMemberListMC {
			return viewComponent as HearthMemberListMC;
		}
		override public function onRegister():void {
			viewComponent = new HearthMemberListMC();
			var subMenu:SubMenuMediator = facade.retrieveMediator(SubMenuMediator.NAME) as SubMenuMediator;
			
			hearthMemberList.x = subMenu.getSubmenuWidth();
			hearthMemberList.y = Y_POS;
			
			hearthMemberList.addEventListener(HearthMemberListMC.AVATAR_DESELECTED, deselectAvatar);
			hearthMemberList.addEventListener(HearthMemberListMC.AVATAR_SELECTED, selectAvatar);
			
			hmlProxy = facade.retrieveProxy(HearthMembersListProxy.NAME) as HearthMembersListProxy;
			sendNotification(ViewAreaMediator.ADD_VIEW_COMPONENT, hearthMemberList);
		}
		override public function onRemove():void {
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, hearthMemberList);
		}
	}
}
