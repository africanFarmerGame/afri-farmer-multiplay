/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.states.FarmGameState;
	import uk.ac.sussex.states.HomeGameState;
	import uk.ac.sussex.model.ServerRoomProxy;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.PlayerCharProxy;
	import org.puremvc.as3.multicore.patterns.command.*;
	import org.puremvc.as3.multicore.interfaces.*;

	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.serverhandlers.RoomHandlers;

	/**
	 * @author em97
	 */
	public class RequestLocationMoveCommand extends SimpleCommand {
		override public function execute( note:INotification ):void {
			var reqLocData:Array = note.getBody() as Array;
			var requestedLocation:String = reqLocData['location'];
			var requestedLocId:String = reqLocData['locId'];			
			var myChar:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;
			
			var serverRoomProxy:ServerRoomProxy = facade.retrieveProxy(ServerRoomProxy.NAME) as ServerRoomProxy;
			if(serverRoomProxy!=null){
				//This is a little tricky, unfortunately. 
				var currentRoom:String = serverRoomProxy.getRoomLocation();
				if(currentRoom==requestedLocation){
					sendNotification(ApplicationFacade.CHANGE_STATE, serverRoomProxy.getRoomType(myChar.isBanker()));
					return;
				}
			}
			
			//if this is null, pass through the hearth id for the individual.
			if(requestedLocId == null){ 	
				if(!myChar.isBanker()){
					if(myChar.getPCHearthId()>0){
						requestedLocId = myChar.getPCHearthId().toString();
					} else {
						requestedLocId = myChar.getPlayerId().toString() + "PC";
					}
				} else {
					//Let's see where they are at the moment. If they are visiting a hearth or farm they need that hearthId instead.
					var serverRoomProxy:ServerRoomProxy = facade.retrieveProxy(ServerRoomProxy.NAME) as ServerRoomProxy;
					var roomIdString:String = serverRoomProxy.getRoomId();
					var roomId:int = int(roomIdString);
					var roomType:String = serverRoomProxy.getRoomType();
					if((roomType==HomeGameState.NAME||roomType==FarmGameState.NAME)&&(roomId>0)){
						requestedLocId = roomIdString;
					} else {
						requestedLocId = myChar.getPlayerId().toString() + "PC";
					}
				}
			}
			
			//Sort out the server request 
			var moveRequest:RequestProxy = facade.retrieveProxy(RoomHandlers.MOVE_ROOM + RequestProxy.NAME) as RequestProxy;
			moveRequest.setParamValue("location", requestedLocation);
			moveRequest.setParamValue("locId", requestedLocId);
			
			//And send the message.
			moveRequest.sendRequest();
			
		}
	}
}
