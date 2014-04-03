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
