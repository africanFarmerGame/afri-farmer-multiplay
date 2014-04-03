package uk.ac.sussex.model;

import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.utilities.Logger;

public class Allocation extends BaseObject {
	private Integer id;
	private String name;
	private Hearth household;
	private Integer selected;
	private Integer deleted = 0;
	private Integer gameYear;
	private Integer actual = 0;
	private Set<AssetFood> foods;
	
	public Allocation(){
		super();
		addOptionalParam("Id");
		this.setSelected(0);
	}
	/**
	 * @return the id
	 */
	public Integer getId() {
		return id;
	}
	/**
	 * @param id the id to set
	 */
	public void setId(Integer id) {
		this.id = id;
	}
	/**
	 * @return the name
	 */
	public String getName() {
		return name;
	}
	/**
	 * @param name the name to set
	 */
	public void setName(String name) {
		this.name = name;
	}
	/**
	 * @return the household
	 */
	public Hearth getHousehold() {
		return household;
	}
	/**
	 * @param household the household to set
	 */
	public void setHousehold(Hearth household) {
		this.household = household;
	}
	/**
	 * @return the selected
	 */
	public Integer getSelected() {
		return selected;
	}
	/**
	 * @param selected the selected to set
	 */
	public void setSelected(Integer selected) {
		this.selected = selected;
	}
	/**
	 * @return the deleted
	 */
	public Integer getDeleted() {
		return deleted;
	}
	/**
	 * @param deleted the deleted to set
	 */
	public void setDeleted(Integer deleted) {
		this.deleted = deleted;
	}
	/**
	 * @return the gameYear
	 */
	public Integer getGameYear() {
		return gameYear;
	}
	/**
	 * @param gameYear the gameYear to set
	 */
	public void setGameYear(Integer gameYear) {
		this.gameYear = gameYear;
	}
	public void setActual(Integer actual) {
		this.actual = actual;
	}
	public Integer getActual() {
		return actual;
	}
	public DietaryLevels calculateAllocationDietLevel(AllChars character) throws Exception{
		AllocationItemFactory aif = new AllocationItemFactory();
		Set<AllocationItem> allocationItems = null;
		try {
			allocationItems = aif.fetchCharacterAllocationItems(this, character);
		} catch (Exception e) {
			throw new Exception("Unable to fetch allocationItems for " + character.getId() + ": " + e.getMessage());
		}
		
		Integer totalCarbs = 0;
		Integer totalProtein = 0;
		Integer totalNutrients = 0;
		
		//Calculate total levels of each type of nutrient for this allocation.
		for (AllocationItem item: allocationItems){
			AssetFood food = fetchFoodAsset(item.getAsset().getId());
			if(food!=null){
				totalCarbs += item.getAmount()*food.getCarbs();
				totalProtein += item.getAmount()*food.getProtein();
				totalNutrients += item.getAmount()*food.getNutrients();
			}
		}
		
		Map<DietaryLevels, DietaryRequirement> requirements = character.fetchDietaryRequirements();
		
		DietaryLevels carbLevel = calculateLevel(totalCarbs, 
												 requirements.get(DietaryLevels.A).getCarbohydrate(), 
												 requirements.get(DietaryLevels.B).getCarbohydrate(), 
												 requirements.get(DietaryLevels.C).getCarbohydrate());
		DietaryLevels proteinLevel = calculateLevel(totalProtein, 
				 									requirements.get(DietaryLevels.A).getProtein(), 
				 									requirements.get(DietaryLevels.B).getProtein(), 
				 									requirements.get(DietaryLevels.C).getProtein());
		DietaryLevels nutrientLevel = calculateLevel(totalNutrients, 
													 requirements.get(DietaryLevels.A).getNutrients(), 
													 requirements.get(DietaryLevels.B).getNutrients(), 
													 requirements.get(DietaryLevels.C).getNutrients());
		
		if (carbLevel.equals(DietaryLevels.A) && proteinLevel.equals(DietaryLevels.A) && nutrientLevel.equals(DietaryLevels.A)) {
			return DietaryLevels.A;
		} else if (!carbLevel.equals(DietaryLevels.X) 
				&& !carbLevel.equals(DietaryLevels.C) 
				&& !proteinLevel.equals(DietaryLevels.X) 
				&& !proteinLevel.equals(DietaryLevels.C) 
				&& !nutrientLevel.equals(DietaryLevels.X) 
				&& !nutrientLevel.equals(DietaryLevels.C)) {
			return DietaryLevels.B;
		} else if (!carbLevel.equals(DietaryLevels.X) && !proteinLevel.equals(DietaryLevels.X) && !nutrientLevel.equals(DietaryLevels.X)) {
			return DietaryLevels.C;
		} else {
			return DietaryLevels.X;
		}
	}
	public Integer calculateFoodTotal(AssetFood food) throws Exception{
		AllocationItemFactory aif = new AllocationItemFactory();
		Set<AllocationItem> foodItems = null;
		try {
			foodItems = aif.fetchFoodAllocationItems(this, food);
		} catch (Exception e) {
			throw new Exception("Unable to fetch food items for " + food.getName() + ": " + e.getMessage());
		}
		Integer total = 0;
		for (AllocationItem item: foodItems){
			total += item.getAmount();
		}
		return total;
	}
	private AssetFood fetchFoodAsset(Integer assetId){
		if(foods==null){
			AssetFactory assetFactory = new AssetFactory();
			try {
				foods = assetFactory.fetchFoodAssets();
			} catch (Exception e) {
				Logger.ErrorLog("Allocation.fetchFoodAsset", "The food asset array was null and fetching them caused this problem: " + e.getMessage());
				return null;
			}
		}
		Iterator<AssetFood> foodIterator = foods.iterator();
		while(foodIterator.hasNext()){
			AssetFood food = foodIterator.next();
			if(food.getId().equals(assetId)){
				return food;
			}
		}
		return null;
	}
	private DietaryLevels calculateLevel(Integer currentAmount, Integer reqALevel, Integer reqBLevel, Integer reqCLevel){
		DietaryLevels currentLevel = DietaryLevels.X;
		if (currentAmount >= reqALevel) {
			currentLevel = DietaryLevels.A;					
		} else if (currentAmount >= reqBLevel) {
			currentLevel = DietaryLevels.B;
		} else if (currentAmount >= reqCLevel) {
			currentLevel = DietaryLevels.C;
		} 
		return currentLevel;	
	}
}
