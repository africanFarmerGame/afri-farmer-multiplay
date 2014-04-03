/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.village;

import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

public class VillageFarms {
	private Set<VillageFarm> farms;
	private int smallestFarm = 100;
	
	public int getTotalFarms(){
		return farms.size();
	}
	
	public void addFarms(Integer farmsize, int numFarms){
		if(farms == null){
			farms = new HashSet<VillageFarm>();
		}
		if(farmsize<smallestFarm){
			smallestFarm = farmsize;
		}
		for (int i = 0; i<numFarms; i++){
			farms.add(new VillageFarm(farmsize));
		}
	}
	public int smallestFarmSize() {
		return smallestFarm;
	}
	public VillageFarm fetchSmallestFarm() {
		Iterator<VillageFarm> farmIterator = this.getIterator();
		VillageFarm smallest = null;
		while(farmIterator.hasNext() && smallest == null){
			VillageFarm nextFarm = farmIterator.next();
			if(nextFarm.getFarmSize()==this.smallestFarm){
				smallest = nextFarm;
			}
		}
		return smallest;
	}
	public Iterator<VillageFarm> getIterator() {
		return farms.iterator();
	}
}
