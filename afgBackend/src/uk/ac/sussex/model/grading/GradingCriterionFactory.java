package uk.ac.sussex.model.grading;

import java.util.ArrayList;
import java.util.List;

import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.base.BaseFactory;
import uk.ac.sussex.model.base.BaseObject;

public class GradingCriterionFactory extends BaseFactory {
	public GradingCriterionFactory() {
		super(new GradingCriterion());
	}
	public GradingCriterion fetchSpecificAnnualCriterion(String type, PlayerChar pc, Integer gameYear) throws Exception {
		String query = "select gc from GradingCriterion gc "
			+ "where gc.pc = " + pc.getId().toString() 
			+ " and gc.class = '" + type + "'" 
			+ " and gc.gameYear = " + gameYear.toString();
		
		List<BaseObject> objects = this.fetchManyByQuery(query);
		if(objects.size()>1){
			throw new Exception ("Query returned too many results");
		} else if (objects.size()<1){
			throw new Exception ("Query returned no results");
		} else {
			return (GradingCriterion) objects.get(0);
		}
	}
	public List<GradingCriterion> fetchAllSpecificCriterion(String type, PlayerChar pc) throws Exception {
		String query = "select gc from GradingCriterion gc "
			+ "where gc.pc = " + pc.getId().toString() 
			+ " and gc.class = '" + type + "'" 
			+ " order by gc.gameYear asc";
		List<BaseObject> objects = this.fetchManyByQuery(query);
		List<GradingCriterion> criteria = new ArrayList<GradingCriterion>();
		for (BaseObject object: objects) {
			criteria.add((GradingCriterion) object);
		}
		return criteria;
	}
}
