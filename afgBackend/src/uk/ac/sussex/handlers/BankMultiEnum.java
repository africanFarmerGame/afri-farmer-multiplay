package uk.ac.sussex.handlers;

public enum BankMultiEnum {
	GET_HEARTH_FINES, PAY_FINE, FETCH_FINANCIAL_DETAIL, FETCH_MANAGER_FINES, FETCH_MANAGER_OVERVIEW, NOVALUE;
	
	public static BankMultiEnum toOption(String input){
		try {
			return valueOf(input.toUpperCase());
		} catch (Exception e) {
			return NOVALUE;
		}
	}
}
