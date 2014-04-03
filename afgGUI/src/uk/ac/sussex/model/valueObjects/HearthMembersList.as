package uk.ac.sussex.model.valueObjects {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * @author em97
	 */
	public class HearthMembersList extends EventDispatcher{
		private var pcMembers:Array;
		private var npcMembers:Array;
		private var deadMembers:Array;
		
		public static const PC_MEMBERS_UPDATED:String = "HML.PCs_updated";
		public static const NPC_MEMBERS_UPDATED:String = "HML.NPCs_updated";
		public static const DEAD_MEMBERS_UPDATED:String = "HML.DEAD_updated";
		
		public function HearthMembersList(){
			pcMembers = new Array();
			npcMembers = new Array();
			deadMembers = new Array();
		}
		public function addNPCMembers(newMembers:Array):void {
			var changeToDead:Array = new Array();
			for each (var npc:HearthMember in newMembers){
				var currentMember:HearthMember =  this.getMember(npc.getId()) as HearthMember;
				if(currentMember == null){
					npcMembers.push(npc);
				} else {
					if(npc.getAlive()==0){
						changeToDead.push(npc);
					} else {
						currentMember.setAge(npc.getAge());
						currentMember.setAlive(npc.getAlive());
						currentMember.setAvatarBody(npc.getAvatarBody());
						currentMember.setFirstName(npc.getFirstName());
						currentMember.setCurrentDiet(npc.getCurrentDiet());
						currentMember.setDietTarget(npc.getDietTarget());
						currentMember.setHealthHazard(npc.getHealthHazard());
						currentMember.setRelationship(npc.getRelationship());
					}
				}
			}
			addDeadMembers(changeToDead);
			npcMembers = npcMembers.sort(sortOnAge);
			dispatchEvent(new Event(NPC_MEMBERS_UPDATED));
		}
		public function addPCMembers(newMembers:Array):void {
			var changeToDead:Array = new Array();
			for each (var pc:PlayerChar in newMembers){
				var currentMember:PlayerChar = this.getMember(pc.getId()) as PlayerChar;
				if(currentMember == null){
					pcMembers.push(pc);
				} else {
					if(pc.getAlive()==0){
						changeToDead.push(pc);
					} else {
						currentMember.setAlive(pc.getAlive());
						currentMember.setAvatarBody(pc.getAvatarBody());
						currentMember.setFirstName(pc.getFirstName());
						currentMember.setCurrentDiet(pc.getCurrentDiet());
						currentMember.setDietTarget(pc.getDietTarget());
						currentMember.setHealthHazard(pc.getHealthHazard());
						currentMember.setOnlineStatus(pc.getOnlineStatus());
						currentMember.setRelationship(pc.getRelationship());
					}
				}
			}
			addDeadMembers(changeToDead);
			pcMembers = pcMembers.sort(sortOnId);
			dispatchEvent(new Event(PC_MEMBERS_UPDATED));
		}
		public function addDeadMembers(newMembers:Array):void {
		  	for each (var anychar:AnyChar in newMembers){
				trace("HearthMembersList sez: deadmember being added.");
				var currentMember:AnyChar = this.getMember(anychar.getId()) as AnyChar;
				if(currentMember == null){
					deadMembers.push(anychar);
					trace("HearthMembersList sez: deadMembers should be " + deadMembers.length);
				} else {
					//It's going to matter where they used to be, I think. Hm. 
					if(currentMember.getAlive()!=0){
						if(currentMember is HearthMember){
							npcMembers = removeAnyChar(npcMembers, currentMember);	
						} else if(currentMember is PlayerChar){
							pcMembers = removeAnyChar(pcMembers, currentMember);
						}
						deadMembers.push(anychar);
					} else {
						//What do I update for people who were already dead?!
					}
				}
			}
			deadMembers = deadMembers.sort(sortDeadChars);
			dispatchEvent(new Event(DEAD_MEMBERS_UPDATED));
		}
		public function getMembers():Array {
			return livingMembers;
		}
		public function getAllMembers():Array {
		  return allMembers;
		}
		public function getPCMembers(hearthId:int):Array {
			var hearthPCs:Array = new Array();
			for each (var pc:PlayerChar in pcMembers){
				if(pc.getHearthId()==hearthId){
					hearthPCs.push(pc);
				}
			}
			return hearthPCs;
		}
		public function getNPCMembers(hearthId:int):Array {
			var hearthNPCs:Array = new Array();
			for each (var npc:HearthMember in npcMembers){
				if(npc.getHearthId()==hearthId){
					hearthNPCs.push(npc);
				}
			}
			return hearthNPCs;
		}
		public function getDeadMembers(hearthId:int):Array {
		  var deadPeople:Array = new Array();
		  for each (var dead:AnyChar in deadMembers){
			if(dead.getHearthId() == hearthId){
		      deadPeople.push(dead);
		    }
		  }
		  return deadPeople;
		}
		public function resurrectDeadMember(memberId:int):void {
			var dead:AnyChar = getMember(memberId);
			if(dead!=null){
				dead.setAlive(1);
				deadMembers = removeAnyChar(deadMembers, dead);
				
				if(dead is PlayerChar){
					pcMembers.push(dead);
					dispatchEvent(new Event(PC_MEMBERS_UPDATED));
				} else {
					npcMembers.push(dead);
					dispatchEvent(new Event(NPC_MEMBERS_UPDATED));
				}
				dispatchEvent(new Event(DEAD_MEMBERS_UPDATED));
			}
		}
		public function getMember(memberId:int):AnyChar{
			for each(var member:AnyChar in allMembers){
				if(memberId == member.getId()){
					return member;
				}
			}
			return null;
		}
		private function get livingMembers():Array {
		  return pcMembers.concat(npcMembers);
		}
		private function get allMembers():Array {
			return livingMembers.concat(deadMembers);
		}
		private function removeAnyChar(charArray:Array, removeChar:AnyChar):Array {
			var returnArray:Array = new Array;
			var removeId:int = removeChar.getId();
			for each (var person:AnyChar in charArray){
				if(person.getId()!=removeId){
					returnArray.push(person);
				}
			}
			return returnArray;
		}
		private function sortOnAge(npc1:HearthMember, npc2:HearthMember):int {
			if(npc1==null||npc2==null){
				return 0;
			}
			var age1:int = npc1.getAge();
			var age2:int = npc2.getAge();
			if (age1<age2){
				return 1;
			} else if (age1>age2){
				return -1;
			} else {
				return 0;
			}
		}
		private function sortOnId(pc1:PlayerChar, pc2:PlayerChar):int {
			if(pc1==null||pc2== null){
				return 0;
			}
			var id1:int = pc1.getId();
			var id2:int = pc2.getId();
			if(id1>id2){
				return 1;
			} else if (id1<id2){
				return -1;
			} else {
				return 0;
			}
		}
		private function sortDeadChars(anyChar1:AnyChar, anyChar2:AnyChar):int {
			if(anyChar1 is PlayerChar && anyChar2 is HearthMember){
				return -1;
			} else if(anyChar1 is HearthMember && anyChar2 is PlayerChar){
				return 1;
			} else {
				if(anyChar1 is PlayerChar && anyChar2 is PlayerChar){
					return sortOnId(anyChar1 as PlayerChar, anyChar2 as PlayerChar);
				} else {
					return sortOnAge(anyChar1 as HearthMember, anyChar2 as HearthMember);
				}
			}
		}
	}
}
