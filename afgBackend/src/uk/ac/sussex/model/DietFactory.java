package uk.ac.sussex.model;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.base.BaseFactory;
import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.model.base.RestrictionList;

public class DietFactory extends BaseFactory {

	public DietFactory(){
		super(new Diet());
	}
	public Set<Diet> fetchHouseholdDiets(Hearth hearth) throws Exception {
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("household", hearth);
		restrictions.addEqual("deleted", 0);
		List<BaseObject> objects = this.fetchManyObjects(restrictions);
		Set<Diet> diets = new HashSet<Diet>();
		for (BaseObject object : objects ) {
			diets.add((Diet) object);
		}
		return diets;
	}
	public Diet fetchDiet(Integer dietId) throws Exception {
		Diet diet = (Diet) this.fetchSingleObject(dietId);
		return diet;
	}
}
