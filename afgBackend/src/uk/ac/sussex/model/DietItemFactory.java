package uk.ac.sussex.model;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.base.BaseFactory;
import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.model.base.RestrictionList;

public class DietItemFactory extends BaseFactory {

	public DietItemFactory() {
		super(new DietItem());
	}
	
	public Set<DietItem> fetchDietItems(Diet diet) throws Exception {
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("diet", diet);
		List<BaseObject> objects = this.fetchManyObjects(restrictions);
		Set<DietItem> dietItems = new HashSet<DietItem>();
		for (BaseObject object : objects ) {
			dietItems.add((DietItem) object);
		}
		return dietItems;
	}
}
