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
