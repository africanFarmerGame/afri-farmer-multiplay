/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model;

import java.util.ArrayList;
import java.util.List;

import uk.ac.sussex.model.base.BaseFactory;
import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.model.base.RestrictionList;

public class HazardFactory extends BaseFactory {

	public HazardFactory() {
		super(new CropHazard());
	}
	public List<CropHazard> fetchCropHazards() throws Exception{
		RestrictionList restrictions = new RestrictionList();
		List<BaseObject> baseobjects = this.fetchManyObjects(restrictions);
		List<CropHazard> cropHazards = new ArrayList<CropHazard>();
		for(BaseObject object: baseobjects){
			cropHazards.add((CropHazard) object);
		}
		return cropHazards;
	}
	public CropHazardEffect fetchCropHazardEffect(CropHazard hazard, Asset crop, Integer planting, Integer cropage) throws Exception {
		CropHazardEffect effect = null;
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("cropHazard", hazard);
		restrictions.addEqual("crop", crop);
		restrictions.addEqual("planting", planting);
		restrictions.addEqual("cropAge", cropage);
		effect = (CropHazardEffect) this.fetchSingleSubclassObjectByRestrictions(new CropHazardEffect(), restrictions);
		return effect;
	}
	public CropHazardEffect fetchCropHazardEffect(Integer id) throws Exception{
		CropHazardEffect effect = null;
		RestrictionList rl = new RestrictionList();
		rl.addEqual("id", id);
		effect = (CropHazardEffect) this.fetchSingleSubclassObjectByRestrictions(new CropHazardEffect(), rl);
		return effect;
	}
	public FieldHazardHistory fetchCurrentFieldHazard(Field field, SeasonDetail seasonDetail) throws Exception {
		FieldHazardHistory fieldHazard = null;
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("field", field);
		restrictions.addEqual("seasonDetail", seasonDetail);
		fieldHazard = (FieldHazardHistory) this.fetchSingleSubclassObjectByRestrictions(new FieldHazardHistory(), restrictions);
		return fieldHazard;
	}
	public CropHazard fetchCropHazard(Integer cropHazardId) throws Exception {
		return (CropHazard) this.fetchSingleObject(cropHazardId);
	}
}
