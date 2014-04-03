/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
