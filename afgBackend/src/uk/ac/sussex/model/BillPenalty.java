package uk.ac.sussex.model;

public class BillPenalty extends Bill {
	public static final String NAME = "BILL_PENALTY";
	
	public BillPenalty(){
		this.setBillType(NAME);
		this.setDuration(SEASONAL);
		this.addOptionalParam("Character");
	}
}
