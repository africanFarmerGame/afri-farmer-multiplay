/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.village;

import java.util.HashSet;

public class CoreVillage extends Village {

	public CoreVillage() {
		super(6, 12);
	}
	@Override
	public Integer calculateProportionMen(Integer totalFamilies) {
		Integer numMen = (totalFamilies - 1);
		return numMen;
	}

	@Override
	protected void setupFamilies() {
		villageFamilies = new HashSet<VillageFamilies>();
		
		VillageFamilies six = new VillageFamilies();
		six.addFamilies(5, 2, 1);
		six.addFamilies(6, 2, 3);
		six.addFamilies(8, 4, 1);
		six.addFamilies(9, 5, 1);
		villageFamilies.add(six);
		
		VillageFamilies seven = new VillageFamilies();
		seven.addFamilies(5, 2, 2);
		seven.addFamilies(6, 2, 1);
		seven.addFamilies(7, 3, 2);
		seven.addFamilies(9, 5, 1);
		seven.addFamilies(10, 6, 1);
		villageFamilies.add(seven);
		
		VillageFamilies eight = new VillageFamilies();
		eight.addFamilies(5, 2, 1);
		eight.addFamilies(6, 2, 2);
		eight.addFamilies(7, 3, 1);
		eight.addFamilies(8, 4, 2);
		eight.addFamilies(9, 5, 1);
		eight.addFamilies(10, 6, 1);
		villageFamilies.add(eight);
		
		VillageFamilies nine = new VillageFamilies();
		nine.addFamilies(5, 2, 1);
		nine.addFamilies(6, 2, 1);
		nine.addFamilies(7, 3, 3);
		nine.addFamilies(8, 4, 1);
		nine.addFamilies(9, 5, 2);
		nine.addFamilies(10, 6, 1);
		villageFamilies.add(nine);
		
		VillageFamilies ten = new VillageFamilies();
		ten.addFamilies(5, 2, 1);
		ten.addFamilies(6, 2, 1);
		ten.addFamilies(7, 3, 2);
		ten.addFamilies(8, 4, 2);
		ten.addFamilies(9, 5, 2);
		ten.addFamilies(10, 6, 2);
		villageFamilies.add(ten);
		
		VillageFamilies eleven = new VillageFamilies();
		eleven.addFamilies(5, 2, 1);
		eleven.addFamilies(6, 2, 3);
		eleven.addFamilies(7, 3, 1);
		eleven.addFamilies(8, 4, 2);
		eleven.addFamilies(9, 5, 2);
		eleven.addFamilies(10, 6, 2);
		villageFamilies.add(eleven);
		
		VillageFamilies twelve = new VillageFamilies();
		twelve.addFamilies(5, 2, 1);
		twelve.addFamilies(6, 2, 2);
		twelve.addFamilies(7, 3, 3);
		twelve.addFamilies(8, 4, 3);
		twelve.addFamilies(9, 5, 1);
		twelve.addFamilies(10, 6, 2);
		villageFamilies.add(twelve);
	}
	@Override
	protected void setupFarms() {
		villageFarms = new HashSet<VillageFarms>();
		
		VillageFarms six = new VillageFarms();
		six.addFarms(3, 4);
		six.addFarms(4, 1);
		six.addFarms(6, 1);
		villageFarms.add(six);
		
		VillageFarms seven = new VillageFarms();
		seven.addFarms(3, 4);
		seven.addFarms(4, 1);
		seven.addFarms(5, 1);
		seven.addFarms(7, 1);
		villageFarms.add(seven);
		
		VillageFarms eight = new VillageFarms();
		eight.addFarms(3, 4);
		eight.addFarms(4, 1);
		eight.addFarms(5, 1);
		eight.addFarms(6, 1);
		eight.addFarms(7, 1);
		villageFarms.add(eight);
		
		VillageFarms nine = new VillageFarms();
		nine.addFarms(3, 3);
		nine.addFarms(4, 4);
		nine.addFarms(6, 1);
		nine.addFarms(8, 1);
		villageFarms.add(nine);
		
		VillageFarms ten = new VillageFarms();
		ten.addFarms(3, 3);
		ten.addFarms(4, 3);
		ten.addFarms(5, 1);
		ten.addFarms(6, 2);
		ten.addFarms(8, 1);
		villageFarms.add(ten);
		
		VillageFarms eleven = new VillageFarms();
		eleven.addFarms(3, 4);
		eleven.addFarms(4, 4);
		eleven.addFarms(5, 1);
		eleven.addFarms(6, 1);
		eleven.addFarms(9, 1);
		villageFarms.add(eleven);
		
		VillageFarms twelve = new VillageFarms();
		twelve.addFarms(3, 5);
		twelve.addFarms(4, 4);
		twelve.addFarms(5, 1);
		twelve.addFarms(7, 1);
		twelve.addFarms(9, 1);
		villageFarms.add(twelve);
	}
	
}
