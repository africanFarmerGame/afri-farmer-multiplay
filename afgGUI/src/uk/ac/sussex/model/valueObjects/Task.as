﻿/**This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	**/package uk.ac.sussex.model.valueObjects {	/**	 * @author em97	 */	public class Task {		private var id:int;		private var hearthId:int;		private var type:String;		private var typeDisplay:String ;		private var actor:AnyChar;		private var asset:GameAsset;		private var assetAmount:int;		private var location:TaskLocation;		private var notes:String;		private var status:int;		private var deleted:Boolean = false;		private var taskNumber:int;		private var readonly:Boolean = false;		private var seasonId:int;				public static const PENDING:int = 0;		public static const COMPLETED:int = 1;		public static const ERROR:int = -1;				public function getId():int {			return id;		}		public function setId(newId:int):void {			this.id = newId;		}		public function getType():String {			return type;		}		public function setType(newType:String):void {			this.type = newType;		}		public function getTypeDisplay():String {			return this.typeDisplay;		}		public function setTypeDisplay(newTypeDisplay:String):void {			this.typeDisplay = newTypeDisplay;		}		public function getActor():AnyChar {			return this.actor;		}		public function setActor(newActor:AnyChar) :void {			this.actor = newActor;		}		public function getAsset():GameAsset {			return this.asset;		}		public function setAsset(newAsset:GameAsset):void {			this.asset = newAsset;		}		public function getAssetAmount():int {			return this.assetAmount;		}		public function setAssetAmount(newAmount:int):void {			this.assetAmount = newAmount;		}		public function getLocation():TaskLocation {			return this.location;		}		public function setLocation(newLocation:TaskLocation):void {			this.location = newLocation;		}		public function getStatus():int {			return this.status;		}		public function setStatus(newStatus:int):void {			this.status = newStatus;		}		public function getNotes():String {			return notes;		}		public function setNotes(newNotes:String ):void {			this.notes = newNotes;		}		public function getDeleted():Boolean {			return deleted;		}		public function setDeleted(deleted:Boolean):void{			this.deleted = deleted;		}		public function getHearthId():int {			return hearthId;		}		public function setHearthId(newHearthId:int):void {			this.hearthId = newHearthId;		}		public function getTaskNumber():int {			return this.taskNumber;		}		public function setTaskNumber(newNumber:int):void {			this.taskNumber = newNumber;		}		public function getReadonly():Boolean {		  return this.readonly;		}		public function setReadonly(readonly:Boolean):void {		  this.readonly = readonly;		}		public function getSeasonId():int {			return this.seasonId;		}		public function setSeasonId(newId:int):void {			this.seasonId = newId;		}	}}