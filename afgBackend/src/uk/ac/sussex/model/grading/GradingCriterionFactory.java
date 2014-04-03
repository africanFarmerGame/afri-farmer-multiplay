/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
