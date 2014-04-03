package uk.ac.sussex.model;

public class AssetFood extends AssetCrop {
	private Integer protein;
	private Integer carbs;
	private Integer nutrients;
	
	public static String MAIZE = "Maize";
	/**
	 * @param protein the protein to set
	 */
	public void setProtein(Integer protein) {
		this.protein = protein;
	}
	/**
	 * @return the protein
	 */
	public Integer getProtein() {
		return protein;
	}
	/**
	 * @param carbs the carbs to set
	 */
	public void setCarbs(Integer carbs) {
		this.carbs = carbs;
	}
	/**
	 * @return the carbs
	 */
	public Integer getCarbs() {
		return carbs;
	}
	/**
	 * @param nutrients the nutrients to set
	 */
	public void setNutrients(Integer nutrients) {
		this.nutrients = nutrients;
	}
	/**
	 * @return the nutrients
	 */
	public Integer getNutrients() {
		return nutrients;
	}
	
	
}
