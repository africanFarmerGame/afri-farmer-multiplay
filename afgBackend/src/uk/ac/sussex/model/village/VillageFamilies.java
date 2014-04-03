/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.village;

import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

public class VillageFamilies {
	private Set<VillageFamily> families;
	
	public VillageFamilies(){
	}
	public int getTotalFamilies() {
		return families.size();
	}
	public Set<VillageFamily> getFamilies() {
		return families;
	}
	public void addFamilies(Integer familySize, Integer numAdults, int numFamilies){
		if(families == null){
			families = new HashSet<VillageFamily>();
		}
		for (int i = 0; i<numFamilies; i++){
			families.add(new VillageFamily(familySize, numAdults));
		}
	}
	
	public Iterator<VillageFamily> getIterator() {
		return families.iterator();
	}
}
