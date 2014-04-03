/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.utilities;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.Player;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.model.RoomGenerator;
import uk.ac.sussex.model.RoomTypes;
import uk.ac.sussex.model.game.Game;

import com.smartfoxserver.v2.api.ISFSApi;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Zone;

public class GameHelper {
	public static List<User> fetchGameUsers(Zone currentZone, Game game){
		List<Room> groupRooms = currentZone.getRoomListFromGroup(GameHelper.fetchGameRoomgroup(game));
		List<User> users = null;
		for (Room room : groupRooms){
			if(users==null){
				users = room.getUserList();
			} else {
				users.addAll(room.getUserList());
			}
		}
		return users;
	}
	public static List<User> fetchTaskListUsers(Zone currentZone, Integer hearthId){
		String hearthName = RoomGenerator.generateRoomName(RoomTypes.HOME, hearthId.toString());
		String farmName = RoomGenerator.generateRoomName(RoomTypes.FARM, hearthId.toString());
		Room hearthRoom = currentZone.getRoomByName(hearthName);
		Room farmRoom = currentZone.getRoomByName(farmName);
		List<User> users = null;
		if(hearthRoom!=null){
			users = hearthRoom.getUserList();
		}
		if(farmRoom!=null){
			if(users!=null){
				users.addAll(farmRoom.getUserList());
			} else {
				users = farmRoom.getUserList();
			}
		}
		return users;
	}
	public static List<User> fetchOnlineHearthUsers(ISFSApi isfsApi, Hearth hearth) throws Exception {
		PlayerCharFactory pcf = new PlayerCharFactory();
		List<User> users = new ArrayList<User>();
		Set<PlayerChar> pcs = pcf.fetchHearthPCs(hearth);
		for(PlayerChar pc: pcs){
			Player possible = pc.getPlayer();
			if(possible!=null){
				User possUser = isfsApi.getUserByName(possible.getLoginName());
				if(possUser!=null){
					users.add(possUser);
				}
			}
		}
		return users;
	}
	public static List<User> fetchMarketUsers(Zone currentZone, Game game){
		String gameName = GameHelper.fetchGameRoomgroup(game);
		String marketName = RoomGenerator.generateRoomName(RoomTypes.MARKET, gameName);
		Room marketRoom = currentZone.getRoomByName(marketName);
		List<User> users = null;
		if(marketRoom!=null){
			users = marketRoom.getUserList();
		}
		return users;
	}
	public static String fetchGameRoomgroup(Game game){
		return game.getId().toString();
	}
	public static User fetchBankerFromBank(ISFSApi isfsApi, Game game){
		try {
			User bankerUser = null;
			PlayerChar banker = game.fetchBanker();
			Player bankerPlayer = banker.getPlayer();
			//This is unusual, shouldn't happen, but might if I'm messing around backend.
			if(bankerPlayer!=null){
				bankerUser = isfsApi.getUserByName(bankerPlayer.getLoginName());
				if(bankerUser==null){
					return null; // No need to keep going if the user isn't online.
				} else {
					//We need to check if they are in the bank.
					Room room = bankerUser.getLastJoinedRoom();
					String roomName = room.getName();
					char lastChar = roomName.charAt(roomName.length() - 1);
					if(lastChar!='B'){
						return null;
					}
				}
			}
			return bankerUser;
		} catch (Exception e1) {
			Logger.ErrorLog("MarketMultiHandler.updateHouseholdBankOverview", "Problem with the banker." + e1.getMessage());
			return null;
		}
	}
	public static User fetchBankerFromHome(ISFSApi isfsApi, Game game){
		try {
			User bankerUser = null;
			PlayerChar banker = game.fetchBanker();
			Player bankerPlayer = banker.getPlayer();
			//This is unusual, shouldn't happen, but might if I'm messing around backend.
			if(bankerPlayer!=null){
				bankerUser = isfsApi.getUserByName(bankerPlayer.getLoginName());
				if(bankerUser==null){
					return null; // No need to keep going if the user isn't online.
				} else {
					//We need to check if they are in the bank.
					Room room = bankerUser.getLastJoinedRoom();
					String roomName = room.getName();
					if(!roomName.equals(banker.fetchHomeRoom())){
						return null;
					}
				}
			}
			return bankerUser;
		} catch (Exception e1) {
			Logger.ErrorLog("MarketMultiHandler.updateHouseholdBankOverview", "Problem with the banker." + e1.getMessage());
			return null;
		}
	}
}
