﻿/**This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	**/package uk.ac.sussex.model.valueObjects {		public class Server {				private var username:String;		private var password:String;		private var receivedParams:Object;		private var requestName:String;				public function Server():void {			this.receivedParams = new Array();		}					public function getUsername():String {			return username;		}		public function setUsername(newName:String):void {			this.username = newName;		}		public function setPassword(newPassword:String):void {			this.password = newPassword;		}		public function getPassword():String {			return this.password;		}		public function setReceivedParams(params:Object):void {			this.receivedParams = params;		}		public function getReceivedParams():Object {			return this.receivedParams;		}		public function getRequestName():String {			return this.requestName;		}		public function setRequestName(name:String):void {			this.requestName = name;		}	}	}