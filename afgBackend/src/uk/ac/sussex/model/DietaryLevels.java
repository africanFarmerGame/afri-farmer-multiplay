package uk.ac.sussex.model;

public enum DietaryLevels {
	A, B, C, X;
	
	public static DietaryLevels toOption(String input){
		try {
			return valueOf(input.toUpperCase());
		} catch (Exception e) {
			return X;
		}
	}
}
