package uk.ac.sussex.model {
	import uk.ac.sussex.model.valueObjects.HearthMembersList;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.interfaces.IProxy;

	/**
	 * @author em97
	 */
	public class VillageMembersListProxy extends Proxy implements IProxy {
		public static const NAME:String = "VillageMembersListProxy";
		public static const PC_MEMBER_ADDED:String = "VillagePCMemberAdded";
		public static const NPC_MEMBER_ADDED:String = "VillageNPCMemberAdded";
		public static const DEAD_MEMBER_ADDED:String = "VillageDeadMemberAdded";
		
		public function VillageMembersListProxy() {
			super(NAME, null);
		}
		public function addPCHearthMembers(newHearthMembers:Array):void {
			villageMemberList.addPCMembers(newHearthMembers);
			sendNotification(PC_MEMBER_ADDED);
			trace("VillageMembersListProxy sez: After adding the PCs I have " + villageMemberList.getAllMembers().length + " people in this village.");
		}
		public function addNPCHearthMembers(newHearthMembers:Array):void {
			villageMemberList.addNPCMembers(newHearthMembers);
			sendNotification(NPC_MEMBER_ADDED);
			trace("VillageMembersListProxy sez: After adding the NPCs I have " + villageMemberList.getAllMembers().length + " people in this village.");
		}
		public function addDeadHearthMembers(deadMembers:Array):void {
			villageMemberList.addDeadMembers(deadMembers);
			sendNotification(DEAD_MEMBER_ADDED);
		}
		public function getHearthPCs(hearthId:int):Array {
			var hearthPCs:Array = villageMemberList.getPCMembers(hearthId);
			return hearthPCs;
		}
		public function getHearthNPCs(hearthId:int):Array {
			var hearthNPCs:Array = villageMemberList.getNPCMembers(hearthId);
			return hearthNPCs;
		}
		public function getHearthlessPCs():Array {
			var hearthlessPCs:Array = villageMemberList.getPCMembers(null);
			return hearthlessPCs;
		}
		protected function get villageMemberList():HearthMembersList {
			return data as HearthMembersList;
		}
		override public function onRegister():void{
			this.data = new HearthMembersList();
		}
	}
}
