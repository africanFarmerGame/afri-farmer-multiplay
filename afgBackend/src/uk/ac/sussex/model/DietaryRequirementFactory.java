/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model;

import java.util.HashMap;

public class DietaryRequirementFactory {
	
	private HashMap<DietaryTypes, HashMap<DietaryLevels, DietaryRequirement>> stuff;
	
	public DietaryRequirementFactory(){
		setupStuff();
	}
	public HashMap<DietaryLevels, DietaryRequirement> fetchDietaryRequirements(PlayerChar pc){
		HashMap<DietaryLevels, DietaryRequirement> drs = stuff.get(this.fetchPCDietaryType(pc));
		return drs;
	}
	public HashMap<DietaryLevels, DietaryRequirement> fetchDietaryRequirements(NPC npc){
		HashMap<DietaryLevels, DietaryRequirement> drs = stuff.get(this.fetchNPCDietaryType(npc));
		return drs;
	}
	public DietaryTypes fetchPCDietaryType(PlayerChar pc){
		if(pc.getRole().getId().equals(Role.MAN)){
			return DietaryTypes.ADULT_MALE;
		} else {
			return DietaryTypes.ADULT_FEMALE;
		}
	}
	public DietaryTypes fetchNPCDietaryType(NPC npc){
		if(npc.isAdult()){
			if(npc.getRole().getId().equals(Role.MAN)){
				return DietaryTypes.ADULT_MALE;
			} else {
				return DietaryTypes.ADULT_FEMALE;
			}
		} else {
			Integer age = npc.getAge();
			if(age < NPC.CHILD_AGE){
				return DietaryTypes.BABY;
			} else {
				return DietaryTypes.CHILD;
			}
		}
	}
	public HashMap<DietaryTypes, HashMap<DietaryLevels, DietaryRequirement>> fetchAllDietaryRequirements(){
		return stuff;
	}
	private void setupStuff(){
		stuff = new HashMap<DietaryTypes, HashMap<DietaryLevels, DietaryRequirement>>();
		
		//Adult male
		HashMap<DietaryLevels, DietaryRequirement> adultMale = new HashMap<DietaryLevels, DietaryRequirement>();
		adultMale.put(DietaryLevels.A, new DietaryRequirement(DietaryTypes.ADULT_MALE, DietaryLevels.A, 9, 8, 7));
		adultMale.put(DietaryLevels.B, new DietaryRequirement(DietaryTypes.ADULT_MALE, DietaryLevels.B, 7, 7, 4));
		adultMale.put(DietaryLevels.C, new DietaryRequirement(DietaryTypes.ADULT_MALE, DietaryLevels.C, 4, 5, 3));
		stuff.put(DietaryTypes.ADULT_MALE, adultMale);
		
		//Adult female
		HashMap<DietaryLevels, DietaryRequirement> adultFemale = new HashMap<DietaryLevels, DietaryRequirement>();
		adultFemale.put(DietaryLevels.A, new DietaryRequirement(DietaryTypes.ADULT_FEMALE, DietaryLevels.A, 7, 7, 4));
		adultFemale.put(DietaryLevels.B, new DietaryRequirement(DietaryTypes.ADULT_FEMALE, DietaryLevels.B, 6, 5, 4));
		adultFemale.put(DietaryLevels.C, new DietaryRequirement(DietaryTypes.ADULT_FEMALE, DietaryLevels.C, 3, 3, 3));
		stuff.put(DietaryTypes.ADULT_FEMALE, adultFemale);
		
		//Child
		HashMap<DietaryLevels, DietaryRequirement> child = new HashMap<DietaryLevels, DietaryRequirement>();
		child.put(DietaryLevels.A, new DietaryRequirement(DietaryTypes.CHILD, DietaryLevels.A, 6, 5, 4));
		child.put(DietaryLevels.B, new DietaryRequirement(DietaryTypes.CHILD, DietaryLevels.B, 3, 3, 3));
		child.put(DietaryLevels.C, new DietaryRequirement(DietaryTypes.CHILD, DietaryLevels.C, 3, 2, 1));
		stuff.put(DietaryTypes.CHILD, child);
		
		//Baby
		HashMap<DietaryLevels, DietaryRequirement> baby = new HashMap<DietaryLevels, DietaryRequirement>();
		baby.put(DietaryLevels.A, new DietaryRequirement(DietaryTypes.BABY, DietaryLevels.A, 3, 3, 3));
		baby.put(DietaryLevels.B, new DietaryRequirement(DietaryTypes.BABY, DietaryLevels.B, 3, 2, 1));
		baby.put(DietaryLevels.C, new DietaryRequirement(DietaryTypes.BABY, DietaryLevels.C, 1, 2, 0));
		stuff.put(DietaryTypes.BABY, baby);
	}
}
