package uk.ac.sussex.handlers;

public enum FarmMultiEnum {
	GET_FIELD_DETAILS, 
	GET_POSSIBLE_TASKS, 
	SAVE_TASK, 
	GET_HOUSEHOLD_TASKS, 
	DELETE_TASK,
	GM_FETCH_PENDING_TASKS,
	NOVALUE;
	
	public static FarmMultiEnum toOption(String input){
		try {
			return valueOf(input.toUpperCase());
		} catch (Exception e) {
			return NOVALUE;
		}
	}
}
