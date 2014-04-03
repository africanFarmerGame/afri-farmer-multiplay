package uk.ac.sussex.handlers;

public enum RoomMultiEnum {
	MOVE_ROOM, GET_ROOMTITLE, GET_ROOM_STATUS, GET_GAME_ROOM_STATUS, NOVALUE;
	
	public static RoomMultiEnum toOption(String input){
		try {
			return valueOf(input.toUpperCase());
		} catch (Exception e) {
			return NOVALUE;
		}
	}
}
