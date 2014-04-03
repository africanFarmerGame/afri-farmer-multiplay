/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class AnyChar {
		private var id:int;
		private var firstName:String;
		private var familyName:String;
		private var role:String;
		private var avatarBody:uint;
		private var dietTarget:int;
		private var dietaryReqs:Array;
		private var relationship:int = NO_RELATION;
		private var hearthId:int;
		private var alive:int;
		private var healthHazard:String;
		private var currentDiet:String;
		
		public static const MALE:String = "MAN";
		public static const FEMALE:String = "WOMAN";
		public static const BANKER:String = "BANKER";
		
		public static const NO_RELATION:int = 0;
		public static const IMMEDIATE_FAMILY:int = 1;
		public static const RELATIVE:int = 2;
		public static const ME:int = 3;
		
		public function getId():int {
			return this.id;
		}
		public function setId(id:int):void {
			this.id = id;
		}
		public function getFirstName():String {
			return this.firstName;
		}
		public function setFirstName(firstname:String):void {
			this.firstName = firstname;
		}
		public function getFamilyName():String {
			return this.familyName; 
		}
		public function setFamilyName(famName:String):void {
			this.familyName = famName;
		}
		public function getRole():String {
			return this.role;
		}
		public function setRole(role:String):void {
			this.role = role;
		}
		public function getAvatarBody():uint {
			return this.avatarBody;
		}
		public function setAvatarBody(newAvatarBody:uint):void {
			this.avatarBody = newAvatarBody;
		}
		public function getDietTarget():int {
			return dietTarget;
		}
		public function setDietTarget(newTarget:int):void {
			this.dietTarget = newTarget;
		}
		public function getDietaryReqs():Array {
			return dietaryReqs;
		}
		public function setDietaryReqs(newReqs:Array):void {
			this.dietaryReqs = newReqs;
		}
		public function getRelationship():int {
			return this.relationship;
		}
		public function setRelationship(rel:int):void {
			this.relationship = rel;
		}
		public function setHearthId(newHearthId:int):void{
			this.hearthId = newHearthId;
		}
		public function getHearthId():int {
			return this.hearthId;
		}
		public function getAlive():int {
		  return this.alive;
		}
		public function setAlive(newAlive:int):void {
		  this.alive = newAlive;
		}
		public function getHealthHazard():String {
			return this.healthHazard;
		}
		public function setHealthHazard(newHazard:String):void {
			this.healthHazard = newHazard;
		}
		public function getCurrentDiet():String {
			return currentDiet;
		}
		public function setCurrentDiet(newDiet:String):void {
			this.currentDiet = newDiet;
		}
	}
	
}
