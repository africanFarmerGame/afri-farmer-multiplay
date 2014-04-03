/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;


import org.junit.Test;

import uk.ac.sussex.model.village.*;


public class VillageTest {
	@Test
	public void fetchFarms(){
		Village village = new CoreVillage();
		//TODO test too many or too few.
		VillageFarms farms = village.getFarms(7);
		assertEquals(farms.getTotalFarms(), 7);
	}
	@Test
	public void fetchFamilies(){
		Village village = new CoreVillage();
		
		//TODO test too many or too few. 
		VillageFamilies vf = village.getFamilies(6);
		assertEquals(vf.getTotalFamilies(), 6);
	}
}
