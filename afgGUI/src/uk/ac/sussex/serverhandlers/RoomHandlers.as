/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.serverhandlers {
	/**
	 * @author em97
	 */
	public class RoomHandlers {
		public static const ROOM_ERROR:String = "roomError";
		public static const MOVE_ROOM:String = "room.move_room";
		public static const MOVE_ROOM_ERROR:String = "move_room_error";
		public static const GET_ROOM_STATUS:String = "room.get_room_status";
		public static const GET_ROOM_STATUS_ERROR:String = "get_room_status_error";
		public static const ROOM_STATUS_DETAIL:String = "RoomStatusDetail";
		public static const VIEW_DETAILS:String = "ViewDetails";
		
		//GM Constants
		public static const GET_GAME_STATUSES:String = "room.get_game_room_status";
		public static const GET_GAME_STATUSES_ERROR:String = "get_game_room_status_error";
		public static const GAME_STATUSES_RECEIVED:String = "AllViewDetails";
	}
}
