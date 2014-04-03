﻿/**This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	**/package uk.ac.sussex.model.valueObjects.requestParams {	import com.smartfoxserver.v2.entities.data.SFSObject;		public class DataParamString extends DataParam {		public function DataParamString(paramName:String) {			super(paramName);			this.paramType = DataParam.STRING;		}		override public function getParamValue() {			var value:String = this.paramValue as String;			return value;		}		override public function setParamValue(paramValue) {			var value:String = paramValue as String;			this.paramValue = value;		}		override public function addToServerParam(existingObject:SFSObject):SFSObject {			existingObject.putUtfString(this.getParamName(), this.getParamValue());			return existingObject;		}		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {			var myValue:String = existingObject.getUtfString(this.getParamName());			this.setParamValue(myValue);			return existingObject;		}	}}