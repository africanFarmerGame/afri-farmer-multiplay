package uk.ac.sussex.handlers;

public enum VillageMultiEnum {
	GET_HEARTH_DETAILS, 
	GET_VILLAGE_OVERVIEW, 
	GET_HEARTH_ASSETS, 
	GET_GIVE_ASSETS, 
	GIVE_ASSET,
	FETCH_HEARTHS_OVERVIEW,
	FETCH_HEARTHLESS,
	FETCH_VILLAGE_MEMBERS,
	SUBMIT_PROPOSAL,
	REQUEST_PROPOSALS,
	UPDATE_PROPOSAL,
	FETCH_DEAD,
	RESURRECT,
	NOVALUE;
	
	public static VillageMultiEnum toOption(String input){
		try {
			return valueOf(input.toUpperCase());
		} catch (Exception e) {
			return NOVALUE;
		}
	}
}
