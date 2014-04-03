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
