package uk.ac.sussex.model {
	import flash.events.Event;
	import uk.ac.sussex.model.valueObjects.PlayerChar;
	import uk.ac.sussex.model.valueObjects.AnyChar;
	import uk.ac.sussex.model.valueObjects.HearthMembersList;
	import uk.ac.sussex.model.valueObjects.HearthMember;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	
	/**
	 * @author em97
	 */
	public class HearthMembersListProxy extends Proxy implements IProxy {
		public static const NAME:String = "HearthMembersListProxy";
		public static const HEARTH_PC_MEMBER_ADDED:String = "HearthPCMemberAdded";
		public static const HEARTH_NPC_MEMBER_ADDED:String = "HearthNPCMemberAdded";
		public static const DEAD_MEMBER_ADDED:String = "DeadMemberAdded";
		
		public function HearthMembersListProxy() {
			super(NAME, new HearthMembersList());
		}
		public function addPCHearthMembers(newHearthMembers:Array):void {
			hearthMemberList.addPCMembers(newHearthMembers);
		}
		public function addNPCHearthMembers(newHearthMembers:Array):void {
			hearthMemberList.addNPCMembers(newHearthMembers);	
		}
		public function addDeadHearthMembers(deadMembers:Array):void {
			hearthMemberList.addDeadMembers(deadMembers);
		}
		public function getPCMembers(hearthId:int):Array {
			return hearthMemberList.getPCMembers(hearthId);
		}
		public function getNPCMembers(hearthId:int):Array {
			return hearthMemberList.getNPCMembers(hearthId);
		}
		public function getDeadMembers(hearthId:int):Array {
		  return hearthMemberList.getDeadMembers(hearthId);
		}
		public function getHearthMemberIds():Array{
			var idList:Array = new Array();
			var totalList:Array = hearthMemberList.getMembers();
			for each (var hearthMember:HearthMember in totalList){
				idList.push(hearthMember.getId());
			}
			return idList;
		}
		public function getHearthMemberCount():int {
			return hearthMemberList.getMembers().length;
		}
		public function getMembers():Array {
			return hearthMemberList.getMembers();
		}
		public function getMember(memberId:int):AnyChar {
			return hearthMemberList.getMember(memberId);
		}
		public function updateMember(member:AnyChar):void {
			var memberArray:Array = new Array();
			memberArray.push(member);
			if(member is PlayerChar) {
				hearthMemberList.addPCMembers(memberArray);
			} else {
				hearthMemberList.addNPCMembers(memberArray);
			}
		}
		public function resurrectMember(charId:int):void {
			hearthMemberList.resurrectDeadMember(charId);
		}
		private function deadUpdated(e:Event):void{
			sendNotification(DEAD_MEMBER_ADDED);
		}
		private function npcUpdated(e:Event):void {
			sendNotification(HEARTH_NPC_MEMBER_ADDED);
		}
		private function pcUpdated(e:Event):void {
			sendNotification(HEARTH_PC_MEMBER_ADDED);
		}
		protected function get hearthMemberList():HearthMembersList {
			return data as HearthMembersList;
		}
		override public function onRegister():void{
			hearthMemberList.addEventListener(HearthMembersList.DEAD_MEMBERS_UPDATED, deadUpdated);
			hearthMemberList.addEventListener(HearthMembersList.NPC_MEMBERS_UPDATED, npcUpdated);
			hearthMemberList.addEventListener(HearthMembersList.PC_MEMBERS_UPDATED, pcUpdated);
		}
	}
}
