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
