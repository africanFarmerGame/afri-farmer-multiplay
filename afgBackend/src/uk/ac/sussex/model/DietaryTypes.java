package uk.ac.sussex.model;

public enum DietaryTypes {
	ADULT_MALE(0), ADULT_FEMALE(1), CHILD(2), BABY(3);
	private DietaryTypes(int fValue){
		eValue = fValue;
	}
	public int getIntValue(){
		return eValue;
	}
	private int eValue;
}
