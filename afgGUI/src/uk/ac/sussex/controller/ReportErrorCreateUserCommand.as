﻿/**This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	**/package uk.ac.sussex.controller {	import org.puremvc.as3.multicore.interfaces.*;	import org.puremvc.as3.multicore.patterns.command.*;	import uk.ac.sussex.model.ServerProxy;	import uk.ac.sussex.model.valueObjects.IncomingData;	public class ReportErrorCreateUserCommand extends SimpleCommand{		override public function execute(note:INotification):void {			var server:ServerProxy = facade.retrieveProxy(ServerProxy.NAME) as ServerProxy;			server.logout();						var incomingData:IncomingData = note.getBody() as IncomingData;			trace('Generated by ReportErrorCreateUserCommand: ' + incomingData.getParamValue('message'));					}	}	}