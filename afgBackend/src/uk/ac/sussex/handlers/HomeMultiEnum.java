/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.handlers;

public enum HomeMultiEnum {
	GET_MEMBER_DETAILS, 
	GET_HEARTH_ASSETS, 
	GET_GAME_ASSETS, 
	GET_DIETS, 
	GET_DIETARY_REQS, 
	SAVE_DIET, 
	DELETE_DIET,
	GET_ALLOCATIONS,
	SAVE_ALLOCATION,
	DELETE_ALLOCATION,
	SET_ACTIVE_ALLOCATION,
	GM_FETCH_FOOD_OVERVIEW,
	NOVALUE;
	
	public static HomeMultiEnum toOption(String input){
		try {
			return valueOf(input.toUpperCase());
		} catch (Exception e) {
			return NOVALUE;
		}
	}
}
