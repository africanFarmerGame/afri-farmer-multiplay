package uk.ac.sussex.model.village;

public class VillageFamily {
	private Integer totalSize;
	private Integer numAdults;
	public VillageFamily(Integer familySize, Integer numAdults){
		this.totalSize = familySize;
		this.numAdults = numAdults;
	}
	public Integer getTotalSize() {
		return totalSize;
	}
	public Integer getNumAdults() {
		return numAdults;
	}
	
}
