/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class Proposal {
		private var id:int;
		private var proposerId:int;
		private var proposerName:String;
		private var proposerHearthId:int;
		private var targetId:int;
		private var targetName:String;
		private var currentHearthId:int;
		private var currentHearthName:String;
		private var targetHearthId:int;
		private var targetHearthName:String;
		private var status:int;
		private var deleted:Boolean;
		
		public static const PENDING:int = 0;
		public static const ACCEPTED:int = 1;
		public static const DECLINED:int = 2;
		public static const RETRACTED:int = 3;
		
		public function Proposal():void {
			
		}
		public function getId():int{
			return this.id;
		}
		public function setId(newId:int):void {
			this.id = newId;
		}
		public function getProposerId():int {
			return this.proposerId;
		}
		public function setProposerId(newPropId:int):void {
			this.proposerId = newPropId;
		}
		public function getProposerName():String {
			return this.proposerName;
		}
		public function setProposerName(newPropName:String):void {
			this.proposerName = newPropName;
		}
		public function getProposerHearthId():int{
			return this.proposerHearthId;
		}
		public function setProposerHearthId(hearthId:int):void {
			this.proposerHearthId = hearthId;
		}
		public function getTargetId():int {
			return this.targetId;
		}
		public function setTargetId(newId:int):void {
			this.targetId = newId;
		}
		public function getTargetName():String {
			return this.targetName;
		}
		public function setTargetName(newName:String):void {
			this.targetName = newName;
		}
		public function getCurrentHearthId():int {
			return this.currentHearthId;
		}
		public function setCurrentHearthId(hearthId:int):void {
			this.currentHearthId = hearthId;
		}
		public function getCurrentHearthName():String {
			return this.currentHearthName;
		}
		public function setCurrentHearthName(newName:String):void {
			this.currentHearthName = newName;
		}
		public function getTargetHearthId():int {
			return this.targetHearthId;
		}
		public function setTargetHearthId(newId:int):void {
			this.targetHearthId = newId;
		}
		public function getTargetHearthName():String {
			return this.targetHearthName;
		}
		public function setTargetHearthName(newName:String):void {
			this.targetHearthName = newName;
		}
		public function getStatus():int {
			return this.status;
		}
		public function setStatus(newStatus:int):void {
			this.status = newStatus;
		}
		public function getDeleted():Boolean {
			return this.deleted;
		}
		public function setDeleted(deleted:Boolean):void {
			this.deleted = deleted;
		}
		
	}
}
