package uk.ac.sussex.model;

public class BillHospital extends Bill {
	public static String NAME = "BILL_HOSPITAL";
	public BillHospital () {
		this.setBillType(NAME);
		this.setDuration(ANNUAL);
	}
	@Override
	public void payBill() throws Exception {
		//When this bill is paid I need to find the corresponding individual and make them well. 
		
		//Start by finding the hazard history entry.
		HealthHazardFactory hhf = new HealthHazardFactory();
		CharHealthHazard chh = hhf.fetchHealthHazardByBill(this);
		
		//That gives me the person to find (uh, do I need to know if they are pc or npc?)
		AllChars person = chh.getCharacter();
		//I need to fetch the full person. 
		AllCharsFactory acf = new AllCharsFactory();
		person = acf.fetchAllChar(person.getId());
		
		//Update them to full health
		person.setAlive(AllChars.ALIVE);
		person.save();
				
		//call super to actually pay the fine. 
		super.payBill();
	}
}
