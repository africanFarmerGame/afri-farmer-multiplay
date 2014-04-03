package uk.ac.sussex.model;

public class BillDeathDuty extends Bill{
	public static String NAME = "BILL_DEATHDUTY";
	public BillDeathDuty(){
		this.setBillType(NAME);
		this.setDuration(ANNUAL);
		this.setEarlyRate(20.00);
		this.setLateRate(20.00);
	}
}
