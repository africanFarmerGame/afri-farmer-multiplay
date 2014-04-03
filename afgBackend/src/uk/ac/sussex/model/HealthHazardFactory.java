package uk.ac.sussex.model;

import java.util.List;
import java.util.Random;

import uk.ac.sussex.model.base.BaseFactory;
import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.model.base.OrderList;
import uk.ac.sussex.model.base.RestrictionList;
import uk.ac.sussex.utilities.Logger;

public class HealthHazardFactory extends BaseFactory {
	public HealthHazardFactory() {
		super(new HealthHazard());
	}
	public HealthHazard fetchHealthHazardById(Integer hhId) throws Exception {
		
		return (HealthHazard) this.fetchSingleObject(hhId);
		
	}
	public HealthHazard fetchRandomHealthHazard(DietaryLevels dietLevel) throws Exception{
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("dietLevel", dietLevel.toString());
		List<BaseObject> objects = this.fetchManyObjects(restrictions);
		int rnd = new Random().nextInt(objects.size());
		return (HealthHazard) objects.get(rnd);
	}
	public CharHealthHazard fetchHealthHazardByBill(Bill bill) throws Exception {
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("bill", bill);
		List<BaseObject> objects = this.fetchManySubclassObjects(new CharHealthHazard(), restrictions);
		//There should only be one. 
		if(objects.size() == 1){
			return (CharHealthHazard) objects.get(0);
		} else {
			Logger.ErrorLog("HealthHazardFactory.fetchHealthHazard", "Expecting 1 record, got " + objects.size() + " for bill id " + bill.getId());
			return null;
		}
	}
	public CharHealthHazard fetchHealthHazardByCharacter(AllChars character) throws Exception {
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("character", character);
		//Hm. This is more difficult than it first appeared. 
		//Can I assume it is enough to return the latest one?
		//For now, yes. 
		OrderList orders = new OrderList();
		orders.addDescending("id");
		List<BaseObject> objects = this.fetchManySubclassObjects(new CharHealthHazard(), restrictions, orders);
		if(objects.size()>0){
			return (CharHealthHazard) objects.get(0);
		}
		return null;
	}
	
}
