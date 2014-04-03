/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.grading;

import uk.ac.sussex.model.PlayerChar;

public interface ICriterion {
	/**
	 * 
	 * @param pc
	 * @param gameYear
	 */
	public void calculateValue(PlayerChar pc, Integer gameYear);
	/**
	 * Orders the result for this criterion into a human-readable string on a per-year basis. 
	 * @param pc - the playerChar that the results relate to.
	 * @param gameYear - the game year for which we are calculating a result.
	 * @return String
	 */
	public String displayYearEndOutput(PlayerChar pc, Integer gameYear);
	
	/**
	 * This needs to pull in all of the detail from the years of the game, and work it into a 
	 * final report. 
	 * @param pc
	 * @return
	 */
	public String displayFinalReckoning(PlayerChar pc);
}
