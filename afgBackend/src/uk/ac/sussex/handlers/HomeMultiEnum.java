package uk.ac.sussex.handlers;

public enum HomeMultiEnum {
	GET_MEMBER_DETAILS, 
	GET_HEARTH_ASSETS, 
	GET_GAME_ASSETS, 
	GET_DIETS, 
	GET_DIETARY_REQS, 
	SAVE_DIET, 
	DELETE_DIET,
	GET_ALLOCATIONS,
	SAVE_ALLOCATION,
	DELETE_ALLOCATION,
	SET_ACTIVE_ALLOCATION,
	GM_FETCH_FOOD_OVERVIEW,
	NOVALUE;
	
	public static HomeMultiEnum toOption(String input){
		try {
			return valueOf(input.toUpperCase());
		} catch (Exception e) {
			return NOVALUE;
		}
	}
}
