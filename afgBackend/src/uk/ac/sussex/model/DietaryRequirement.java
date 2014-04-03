package uk.ac.sussex.model;

public class DietaryRequirement {
	private Integer protein;
	private Integer carbohydrate;
	private Integer nutrients;
	private DietaryTypes dietaryType;
	private DietaryLevels dietaryLevel;
	/**
	 * 
	 * @param type
	 * @param level
	 * @param protein
	 * @param carbs
	 * @param nutrients
	 */
	public DietaryRequirement(DietaryTypes type, DietaryLevels level, Integer protein, Integer carbs, Integer nutrients){
		this.setDietaryType(type);
		this.setDietaryLevel(level);
		this.setProtein(protein);
		this.setCarbohydrate(carbs);
		this.setNutrients(nutrients);
	}
	/**
	 * @param protein the protein to set
	 */
	private void setProtein(Integer protein) {
		this.protein = protein;
	}
	/**
	 * @return the protein
	 */
	public Integer getProtein() {
		return protein;
	}
	/**
	 * @param carbohydrate the carbohydrate to set
	 */
	private void setCarbohydrate(Integer carbohydrate) {
		this.carbohydrate = carbohydrate;
	}
	/**
	 * @return the carbohydrate
	 */
	public Integer getCarbohydrate() {
		return carbohydrate;
	}
	/**
	 * @param nutrients the nutrients to set
	 */
	private void setNutrients(Integer nutrients) {
		this.nutrients = nutrients;
	}
	/**
	 * @return the nutrients
	 */
	public Integer getNutrients() {
		return nutrients;
	}
	/**
	 * @param dietaryType the dietaryType to set
	 */
	private void setDietaryType(DietaryTypes dietaryType) {
		this.dietaryType = dietaryType;
	}
	/**
	 * @return the dietaryType
	 */
	public DietaryTypes getDietaryType() {
		return dietaryType;
	}
	/**
	 * @param dietaryLevel the dietaryLevel to set
	 */
	private void setDietaryLevel(DietaryLevels dietaryLevel) {
		this.dietaryLevel = dietaryLevel;
	}
	/**
	 * @return the dietaryLevel
	 */
	public DietaryLevels getDietaryLevel() {
		return dietaryLevel;
	}
	
	
}
