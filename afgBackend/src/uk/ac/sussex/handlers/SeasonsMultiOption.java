package uk.ac.sussex.handlers;

public enum SeasonsMultiOption {
	GET_SEASONS, CURRENT_SEASON, CHANGE_STAGE, GET_WEATHER, FETCH_GM_STAGE_INFO, NOVALUE;
	
	public static SeasonsMultiOption toOption(String input){
		try {
			return valueOf(input.toUpperCase());
		} catch (Exception e) {
			return NOVALUE;
		}
	}
}
