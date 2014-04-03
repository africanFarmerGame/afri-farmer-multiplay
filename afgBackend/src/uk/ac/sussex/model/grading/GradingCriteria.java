/**
 * 
 */
package uk.ac.sussex.model.grading;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import uk.ac.sussex.model.PlayerChar;

/**
 * @author eam31
 *
 */
public class GradingCriteria implements ICriterion {
	private List<ICriterion> criteria;
	
	/* (non-Javadoc)
	 * @see uk.ac.sussex.model.grading.ICriterion#calculateValue(uk.ac.sussex.model.PlayerChar)
	 */
	@Override
	public void calculateValue(PlayerChar pc, Integer gameYear) {
		for (ICriterion criterion : criteria){
			criterion.calculateValue(pc, gameYear);
		}
	}

	/* (non-Javadoc)
	 * @see uk.ac.sussex.model.grading.ICriterion#displayOutput(uk.ac.sussex.model.PlayerChar)
	 */
	@Override
	public String displayYearEndOutput(PlayerChar pc, Integer gameYear) {
		String returnString = "";
		for (ICriterion criterion : criteria){
			returnString += criterion.displayYearEndOutput(pc, gameYear) + "\n";
		}
		return returnString;
	}
	
	protected void addCriterion(ICriterion criterion){
		if(criteria==null){
			criteria = new ArrayList<ICriterion>();
		}
		this.criteria.add(criterion);
	}

	@Override
	public String displayFinalReckoning(PlayerChar pc) {
		String returnString = "";
		for (ICriterion criterion : criteria){
			returnString += criterion.displayFinalReckoning(pc) + "\n";
		}
		return returnString;
	}
	protected GradingCriterion fetchGameYearCriterion(List<GradingCriterion> criteria, Integer gameYear) {
		GradingCriterion gc = null;
		Boolean notFound = true;
		Iterator<GradingCriterion> iterator = criteria.iterator();
		
		while (notFound && iterator.hasNext()){
			gc = iterator.next();
			if(gc.getGameYear().equals(gameYear)){
				return gc;
			}
		}
		return null;
	}
	protected String padRight(String s, int n) {
	     return String.format("%1$-" + n + "s", s);  
	}
}
