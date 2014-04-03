/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model {
	import uk.ac.sussex.states.*;
	import com.smartfoxserver.v2.entities.variables.RoomVariable;
	import com.smartfoxserver.v2.entities.Room;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	/**
	 * @author em97
	 */
	public class ServerRoomProxy extends Proxy implements IProxy {
		public static const NAME:String = "ServerRoomProxy";
		
		public function ServerRoomProxy(room:Room) {
			super(NAME, room);
		}
		public function getRoomDisplayTitle():String {
			var titleVar:RoomVariable = serverRoom.getVariable("title");
			
			return titleVar.getStringValue();
		}
		public function getGameType():String {
			var gameTypeVar:RoomVariable = serverRoom.getVariable("gametype");
			return gameTypeVar.getStringValue();
		}
		public function getRoomType(banker:Boolean = false):String {
			var roomname:String = serverRoom.name;
			var roomID:String = roomname.charAt(roomname.length-1).toLowerCase();
			trace("ServerRoomProxy sez: We're trying to strip a " + roomID + " from " + roomname);
			var roomType:String;
			switch (roomID){
				case "h":
					//This is someone's homeview.
					if(banker){
						if(checkVisiting(roomname)){
							roomType = HomeGameState.NAME;
						} else {
							roomType = HomeManagerGameState.NAME;
						}
					} else {
						roomType = HomeGameState.NAME;
					}
					break;
				case "f":
					if(banker){
						if(checkVisiting(roomname)){
							roomType = FarmGameState.NAME;
						} else {
							roomType = FarmManagerGameState.NAME;
						}
					} else {
						roomType = FarmGameState.NAME;
					}
					break;
				case "m":
					if(banker){
						roomType = MarketManagerGameState.NAME;					
					} else {
						roomType = MarketGameState.NAME;
					}
					break;
				case "v":
					if(banker){
						roomType = VillageManagerGameState.NAME;
					} else {
						roomType = VillageGameState.NAME;
					}
					break;
				case "b":
					//This is the bank.
					trace("ServerRoomProxy sez: We're trying to get to the bank. The banker is " + banker);
					if(banker){ 
						roomType = BankManagerGameState.NAME;
					} else {
						roomType = BankGameState.NAME;
					}
					break;
				default:
					trace("ServerRoomProxy sez: We're not sure where you were trying to get to."); 	
				}
			return roomType;
		}
		public function getRoomLocation():String {
			var roomname:String = serverRoom.name;
			var roomID:String = roomname.charAt(roomname.length-1).toLowerCase();
			switch (roomID){
				case "h":
					//This is someone's homeview.
					return HomeGameState.LOCATION_NAME;
				case "f":
					return FarmGameState.LOCATION_NAME;
				case "m":
					return MarketGameState.LOCATION_NAME;
				case "v":
					return VillageGameState.LOCATION_NAME;
				case "b":
					return BankGameState.LOCATION_NAME;
				default:
					throw new Error("Not a known room identifier: " + roomID);
				}
		}
		/**
		 * The naming convention I use includes the room Id (e.g. 18H - Hearth id = 18). 
		 */
		public function getRoomId():String {
			var roomName:String = serverRoom.name;
			//The type is always the last digit. The rest is the id. 
			var roomId:String = roomName.slice(0, -1);
			trace("ServerRoomProxy sez: The room id is " + roomId);
			return roomId;
		}
		public function updateRoom(room:Room):void {
			this.data = room;
		}
		protected function get serverRoom():Room {
			return data as Room;
		}
		private function checkVisiting(roomname:String):Boolean{
			trace("ServerRoomProxy sez: The roomname is " + roomname);
			var roomIdString:String = roomname.slice(0, -1);
			trace("ServerRoomProxy sez: The room id we are entering is " + roomIdString);
			var roomId:int = int(roomIdString);
			trace("ServerRoomProxy sez: The id is therefore " + roomId);
			return roomId>0;
		}
	}
}
