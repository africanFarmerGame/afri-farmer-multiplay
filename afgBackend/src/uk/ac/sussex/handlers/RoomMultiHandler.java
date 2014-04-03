/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

 package uk.ac.sussex.handlers;

import java.util.Set;

import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.HearthFactory;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.RoomDetail;
import uk.ac.sussex.model.RoomGenerator;
import uk.ac.sussex.model.RoomTypes;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.utilities.GameHelper;
import uk.ac.sussex.utilities.Logger;
import uk.ac.sussex.utilities.UserHelper;

import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.extensions.SFSExtension;
import com.smartfoxserver.v2.annotations.MultiHandler;

@MultiHandler
public class RoomMultiHandler extends BaseClientRequestHandler {

	@Override
	public void handleClientRequest(User user, ISFSObject params) {
		 String requestId = params.getUtfString(SFSExtension.MULTIHANDLER_REQUEST_ID);
	     try {
		     switch(RoomMultiEnum.toOption(requestId)) {
		        case MOVE_ROOM:
		        	String roomString = params.getUtfString("location");
		        	String roomId = params.getUtfString("locId");
		        	
	        		Logger.Log(user.getName(), "Asked to move to roomtype " + roomString + " id " + roomId);
	        		
		        	RoomTypes room = RoomTypes.toOption(roomString);
		        	if(room != RoomTypes.NOVALUE){
		        		this.moveRoom(user, room, roomId);
		        	}
		        	break;
		        case GET_ROOMTITLE:
		        	String roomName = user.getLastJoinedRoom().getName();
		        	Logger.ErrorLog("RoomMultiHandler.handleClientRequest(get_roomtitle)", "This is deprecated. Why are they looking for " + roomName);
		        	break;
		        case GET_ROOM_STATUS:
		        	this.getRoomStatus(user);
		        	break; 
		        case GET_GAME_ROOM_STATUS:
		        	Logger.Log(user.getName(), user.getName() + " is looking for game status details");
		        	this.getAllRoomsStatus(user);
		        	break;
		        default:
		        	ISFSObject errObj = new SFSObject();
		        	errObj.putUtfString("message", "Unable to action request "+requestId);
		        	Logger.ErrorLog("RoomMultiHandler.handleClientRequest", "User asked for a strange thing: " + requestId);
		        	send("roomError", errObj, user);
		        	break;
		     }
	     } catch(Exception e) {
		   	String message = e.getMessage();
     		Logger.ErrorLog("RoomMultiHandler.handleClientRequest (" + requestId + ")", "Problem: " + message);
     		ISFSObject errObj = SFSObject.newInstance();
 	       	errObj.putUtfString("message", "Unable to action request "+requestId + " " + message);
 	       	send(requestId + "_error", errObj, user);  	
	     }
	     
	}
	private void moveRoom(User user, RoomTypes room, String roomId) throws Exception{
				
		PlayerChar pc = UserHelper.fetchUserPC(user);
		Game game = UserHelper.fetchUserGame(user);
		
		//Now I need to translate all the info to the room name I want.
		String roomName = RoomGenerator.generateRoomName(room, pc, roomId);
		String roomGroup = GameHelper.fetchGameRoomgroup(game);
		
		Zone currentZone = this.getParentExtension().getParentZone();
		Room joinRoom = RoomGenerator.fetchRoom(roomName, currentZone, user, roomGroup, game.getGameType());
		
		getApi().joinRoom(user, joinRoom);
		Logger.Log(user.getName(), "User joined room "+roomName);
	}
	private void getRoomStatus(User user) throws Exception {
		Logger.Log(user.getName(), "User asked for room status detail");
		//Actually need to get the status for each kind of room the user can visit in the game.
		Game game = UserHelper.fetchUserGame(user);
		PlayerChar pc = UserHelper.fetchUserPC(user);
		
		//Each view type needs a status of 0 (Green, all ok), 1 (Amber, sort of ok), 2 (Red - seriously wrong.)
		RoomDetail rd = new RoomDetail(game);
		SFSArray detailArray = SFSArray.newInstance();
		
		detailArray.addSFSObject(generateViewDetailObject(rd, RoomTypes.HOME, pc));
		detailArray.addSFSObject(generateViewDetailObject(rd, RoomTypes.FARM, pc));
		detailArray.addSFSObject(generateViewDetailObject(rd, RoomTypes.VILLAGE, pc));
		detailArray.addSFSObject(generateViewDetailObject(rd, RoomTypes.MARKET, pc));
		detailArray.addSFSObject(generateViewDetailObject(rd, RoomTypes.BANK, pc));
		
		SFSObject sendObj = SFSObject.newInstance();
		sendObj.putSFSArray("ViewDetails", detailArray);
		
		send("RoomStatusDetail", sendObj, user);
	}
	private void getAllRoomsStatus(User user) throws Exception {
		Game game = UserHelper.fetchUserGame(user);
		RoomDetail rd = new RoomDetail(game);
		HearthFactory hf = new HearthFactory();
		Set<Hearth> hearths = hf.fetchGameHearths(game);
		SFSArray householdArray = SFSArray.newInstance();
		for(Hearth hearth: hearths){
			SFSObject household = SFSObject.newInstance();
			household.putInt("HearthId", hearth.getId());
			household.putUtfString("HearthName", hearth.getName());
			household.putInt("HouseNumber", hearth.getHousenumber());
			SFSArray detailArray = SFSArray.newInstance();
			detailArray.addSFSObject(generateViewDetailObject(rd, RoomTypes.HOME, hearth));
			detailArray.addSFSObject(generateViewDetailObject(rd, RoomTypes.FARM, hearth));
			detailArray.addSFSObject(generateViewDetailObject(rd, RoomTypes.VILLAGE, hearth));
			detailArray.addSFSObject(generateViewDetailObject(rd, RoomTypes.MARKET, hearth));
			detailArray.addSFSObject(generateViewDetailObject(rd, RoomTypes.BANK, hearth));
			
			household.putSFSArray("ViewDetails", detailArray);
			householdArray.addSFSObject(household);
		}
		SFSObject sendObj = SFSObject.newInstance();
		sendObj.putSFSArray("AllViewDetails", householdArray);
		send ("AllViewDetails", sendObj, user);
	}
	private SFSObject generateViewDetailObject(RoomDetail rd, RoomTypes roomType, PlayerChar pc) throws Exception{
		try {
			SFSObject viewObj = SFSObject.newInstance();
			viewObj.putUtfString("view", roomType.toString());
			viewObj.putInt("value", rd.checkRoomState(pc, roomType));
			return viewObj;
		} catch (Exception e) {
			throw new Exception ("There was a problem generating the view status for room type " + roomType.toString() + ": " + e.getMessage());
		}
	}
	private SFSObject generateViewDetailObject(RoomDetail rd, RoomTypes roomType, Hearth hearth) throws Exception{
		try {
			SFSObject viewObj = SFSObject.newInstance();
			viewObj.putUtfString("view", roomType.toString());
			viewObj.putInt("value", rd.checkRoomState(hearth, roomType));
			return viewObj;
		} catch (Exception e) {
			throw new Exception ("There was a problem generating the view detail for room type " + roomType.toString() + ": " + e.getMessage());
		}
	}
}
