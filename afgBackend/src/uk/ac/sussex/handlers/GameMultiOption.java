package uk.ac.sussex.handlers;

public enum GameMultiOption {
	CREATEGAME, FETCHACTIVEGAMES, FETCHGAMETYPES, JOINGAME, ENTERGAME, END_GAME, NOVALUE;
	
	/**
	 * Basically this is to allow me to do different things depending on which 
	 * method is called to the multihandler. Stupid switch not supporting strings. Pah.
	 * @param input
	 * @return
	 */
	public static GameMultiOption toOption(String input){
		try {
			return valueOf(input.toUpperCase());
		} catch (Exception e) {
			return NOVALUE;
		}
	}
}
