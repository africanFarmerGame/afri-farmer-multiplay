/**
 * 
 */
package uk.ac.sussex.model;

import java.util.List;

import uk.ac.sussex.utilities.XmlParser;

import com.smartfoxserver.v2.api.CreateRoomSettings;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.entities.variables.RoomVariable;
import com.smartfoxserver.v2.entities.variables.SFSRoomVariable;
import com.smartfoxserver.v2.exceptions.SFSCreateRoomException;
import com.smartfoxserver.v2.exceptions.SFSVariableException;

/**
 * @author em97
 *
 */
public class RoomGenerator {
	/**
	 * Limit on room name length plus need for unique identifier means using this static function to generate.
	 * @param roomType
	 * @param pc
	 * @return
	 */
	//TODO: sort out what happens if the name length is greater than 10.
	public static String generateRoomName(RoomTypes roomType, PlayerChar pc, String roomId){

		switch(roomType){
		case HOME:
		case FARM:
			return RoomGenerator.generateRoomName(roomType, roomId);
		case BANK:
		case MARKET:
		case VILLAGE:
			return RoomGenerator.generateRoomName(roomType, pc.getGame().getId().toString());
		default:
			return RoomGenerator.generateRoomName(roomType, roomId);
		}


	}
	/**
	 * 
	 * @param roomType
	 * @param roomId - should be either the hearthId or the gamename.
	 * @return
	 */
	public static String generateRoomName(RoomTypes roomType, String roomId){
		String output = null;
		switch(roomType){
		case HOME:
			output = roomId + "H"; 
			break;
		case FARM:
			output = roomId + "F";
			break;
		case BANK:
			output = roomId + "B";
			break;
		case MARKET:
			output = roomId + "M";
			break;
		case VILLAGE:
			output = roomId + "V";
			break;
		default:
			output = "Lobby";
		}
		if(output.length() < 3){
			output = "0" + output;
		}
		return output;
	}
	public static Room fetchRoom(String roomName, Zone currentZone, User user, String gamename, String gameType) throws Exception{
		Room joinRoom = currentZone.getRoomByName(roomName);
		if(joinRoom == null){
			CreateRoomSettings roomSettings = new CreateRoomSettings();
			roomSettings.setName(roomName);
			roomSettings.setGroupId(gamename);
			try {
				joinRoom = currentZone.createRoom( roomSettings, user);
			} catch (SFSCreateRoomException e) {
				e.printStackTrace();
				throw new Exception(e.getMessage());
			}
			
			String roomType = getRoomTypeFromName(roomName);
			
			//Get the room title from an xml file. 
			XmlParser xmlParser = new XmlParser();
			xmlParser.readXMLFile(roomType);
			String roomTitle = xmlParser.fetchTagValue("title", "view");
			
			List<RoomVariable> roomVariables = joinRoom.getVariables();
			RoomVariable roomTitleVariable = new SFSRoomVariable("title", roomTitle, false, true, false);
			roomVariables.add(roomTitleVariable);
			RoomVariable gameTypeVariable = new SFSRoomVariable("gametype", gameType, false, true, false);
			roomVariables.add(gameTypeVariable);
			try {
				joinRoom.setVariable(roomTitleVariable);
				joinRoom.setVariable(gameTypeVariable);
			} catch (SFSVariableException e) {
				throw new Exception (e.getMessage());
			}
		}
		return joinRoom;
	}
	
	private static String getRoomTypeFromName(String roomName){
		//Take the last character of the roomname and decode it to room type. 
		char lastChar = roomName.charAt(roomName.length() - 1);
		if(lastChar == 'H'){return "Home";}
		if(lastChar == 'V'){return "Village";}
		if(lastChar == 'M'){return "Market";}
		if(lastChar == 'F'){return "Farm";}
		return "Bank";
	}
}
