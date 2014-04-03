package uk.ac.sussex.model;

import java.util.HashMap;

public class NPC extends AllChars {
	
	private Integer age;
	private Integer school;
	private AllChars parent;
	
	public static Integer ADULT_AGE = 14;
	public static Integer CHILD_AGE = 7;
	
	public NPC(){
		super();
		this.addOptionalParam("School");
		this.addOptionalParam("Parent");
		this.addOptionalParam("Name");
		this.addOptionalParam("BabyCount");
	}
	
	/**
	 * @param age the age to set
	 */
	public void setAge(Integer age) {
		this.age = age;
	}
	/**
	 * @return the age
	 */
	public Integer getAge() {
		return age;
	}
	/**
	 * @param school the school to set
	 */
	public void setSchool(Integer school) {
		this.school = school;
	}
	/**
	 * @return the school
	 */
	public Integer getSchool() {
		return school;
	}
	/**
	 * @param parent the parent to set
	 */
	public void setParent(AllChars parent) {
		this.parent = parent;
	}
	/**
	 * @return the parent
	 */
	public AllChars getParent() {
		return parent;
	}
	public Boolean isAdult(){
		return (this.getAge() >= NPC.ADULT_AGE);
	}
	@Override
	public HashMap<DietaryLevels, DietaryRequirement> fetchDietaryRequirements(){
		DietaryRequirementFactory drf = new DietaryRequirementFactory();
		return drf.fetchDietaryRequirements(this); //Needs implementing on the different char types.
	}

}
