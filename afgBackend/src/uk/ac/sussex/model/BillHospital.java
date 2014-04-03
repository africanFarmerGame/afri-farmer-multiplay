/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
