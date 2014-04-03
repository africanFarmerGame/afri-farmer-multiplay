/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model;

import java.util.HashMap;

import uk.ac.sussex.model.base.BaseObject;

public class AllChars extends BaseObject {
	private Integer id;
	private String name;
	private String familyName;
	private Role role;
	private Hearth hearth;
	private Integer alive = 1;
	private DietaryLevels diet = DietaryLevels.C;
	private Integer avatarBody;
	private Integer babyCount;
	
	public static Integer ALIVE = 1;
	public static Integer DEAD = 0;
	public static Integer ILL = 2;
	
	
	public AllChars(){
		super();
		this.addOptionalParam("Id");
		this.addOptionalParam("Hearth");
	}
	/**
	 * @param id the id to set
	 */
	public void setId(Integer id) {
		this.id = id;
	}
	/**
	 * @return the id
	 */
	public Integer getId() {
		return id;
	}
	/**
	 * @param name the name to set
	 */
	public void setName(String name) {
		this.name = name;
	}
	/**
	 * @return the name
	 */
	public String getName() {
		return name;
	}
	/**
	 * @param familyName the familyName to set
	 */
	public void setFamilyName(String familyName) {
		this.familyName = familyName;
	}
	/**
	 * @return the familyName
	 */
	public String getFamilyName() {
		return familyName;
	}
	public String getDisplayName() {
		return name + " " + familyName;
	}
	/**
	 * @param role the role to set
	 */
	public void setRole(Role role) {
		this.role = role;
	}
	/**
	 * @return the role
	 */
	public Role getRole() {
		return role;
	}
	/**
	 * @param hearth the hearth to set
	 */
	public void setHearth(Hearth hearth) {
		this.hearth = hearth;
	}

	/**
	 * @return the hearth
	 */
	public Hearth getHearth() {
		return hearth;
	}
	/**
	 * @return the alive
	 */
	public Integer getAlive() {
		return alive;
	}
	/**
	 * @param alive the alive to set
	 */
	public void setAlive(Integer alive) {
		this.alive = alive;
	}
	/**
	 * @return the diet level as a string
	 */
	public String getDiet() {
		return diet.toString();
	}
	/**
	 * @param diet the diet to set as string.
	 */
	public void setDiet(String diet) {
		this.diet = DietaryLevels.toOption(diet);
	}
	/**
	 * @param dietaryLevel - parameter as dietary level enum.
	 */
	public void setDiet(DietaryLevels dietaryLevel) {
		diet = dietaryLevel;
	}
	/**
	 * This should be overridden on the NPC class. 
	 * @return true
	 */
	public Boolean isAdult() {
		return true;
	}

	/**
	 * @param avatarBody the avatarBody to set
	 */
	public void setAvatarBody(Integer avatarBody) {
		this.avatarBody = avatarBody;
	}

	/**
	 * @return the avatarBody
	 */
	public Integer getAvatarBody() {
		return avatarBody;
	}
	public Integer getBabyCount() {
		return this.babyCount;
	}
	public void setBabyCount(Integer babyCount) {
		this.babyCount = babyCount; 
	}
	public HashMap<DietaryLevels, DietaryRequirement> fetchDietaryRequirements(){
		return null; //Needs implementing on the different char types.
	}
}
