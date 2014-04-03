/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import uk.ac.sussex.model.base.BaseFactory;
import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.model.base.OrderList;
import uk.ac.sussex.model.base.RestrictionList;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;
import uk.ac.sussex.utilities.Logger;

public class FieldFactory extends BaseFactory {

	public FieldFactory() {
		super(new Field());
	}
	public Field createField(PlayerChar owner, String fieldName) throws Exception {
		Field newfield = new Field();
		newfield.setOwner(owner);
		newfield.setQuality(this.generateFieldQuality());
		newfield.setName(fieldName);
		newfield.save();
		
		//this.createPCFieldHistory(newfield, owner);
		
		return newfield;
	}
	public Field createField(Hearth hearth, String fieldName) throws Exception {
		Field newfield = new Field();
		newfield.setHearth(hearth);
		newfield.setQuality(this.generateFieldQuality());
		newfield.setName(fieldName);
		newfield.save();
		
		//this.createHearthFieldHistory(newfield, hearth);
		
		return newfield;
	}
	public List<Field> getHearthFields(Hearth hearth) throws Exception {
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("hearth", hearth);
		OrderList order = new OrderList();
		order.addAscending("id");
		List<BaseObject> objects = this.fetchManyObjects(restrictions, order);
		List<Field> fields = new ArrayList<Field>();
		for (BaseObject object : objects ) {
			fields.add((Field) object);
		}
		return fields;
	}
	/**
	 * This takes an allChar not just a PC, and will just return an empty List if nothing there.
	 * @param pc
	 * @return
	 * @throws Exception
	 */
	public List<Field> getPCFields(AllChars pc) throws Exception {
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("owner", pc);
		OrderList order = new OrderList();
		order.addAscending("id");
		List<BaseObject> objects = this.fetchManyObjects(restrictions, order);
		List<Field> fields = new ArrayList<Field>();
		for (BaseObject object : objects ) {
			fields.add((Field) object);
		}
		return fields;
	}
	public Field getFieldById(Integer locationId) throws Exception {
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("id", locationId);
		BaseObject object = this.fetchSingleObjectByRestrictions(restrictions);
		Field field = (Field) object;
		return field;
	}
	public void createFields(int numberOfFields, Hearth owner) throws Exception {
		Integer currentFields = owner.fetchFieldCount();
		for (int field = 0; field < numberOfFields; field ++){
			this.createField(owner, "Field " + (currentFields + field + 1));
		}
	}
	public void createFields(int numberOfFields, PlayerChar owner) throws Exception {
		Integer currentFields = owner.getFieldCount();
		Logger.ErrorLog("FieldFactory.createFields", "Asked to create " + numberOfFields + " for man " + owner.getId());
		for (int field = 0; field < numberOfFields; field ++){
			this.createField(owner, "Field " + (currentFields + field + 1));
		}
	}
	public FieldHistory createHearthFieldHistory(Field field, Hearth hearth) throws Exception {
		FieldHistory fieldHistory = null;
		
		try {
			GameFactory gameFactory = new GameFactory();
			Game game = gameFactory.fetchGame(hearth.getGame().getId());
			Integer gameYear = game.getGameYear();
			fieldHistory = new FieldHistory();
			fieldHistory.setField(field);
			fieldHistory.setGameYear(gameYear);
			fieldHistory.setHearth(hearth);
			fieldHistory.setFieldName(field.getName());
			fieldHistory.save();
		} catch (Exception e) {
			throw new Exception("Problem generating field history for field " + field.getId() + ": " + e.getMessage() );
		}
		return fieldHistory;
	}
	public FieldHistory createPCFieldHistory(Field field, PlayerChar owner) throws Exception {
		FieldHistory fieldHistory = null;
		
		try {
			GameFactory gameFactory = new GameFactory();
			Game game = gameFactory.fetchGame(owner.getGame().getId());
			Integer gameYear = game.getGameYear();
			fieldHistory = new FieldHistory();
			fieldHistory.setField(field);
			fieldHistory.setGameYear(gameYear);
			fieldHistory.setOwner(owner);
			fieldHistory.setFieldName(field.getName());
			fieldHistory.save();
		} catch (Exception e) {
			throw new Exception("Problem generating field history for field " + field.getId() + ": " + e.getMessage() );
		}
		return fieldHistory;
	}
	public FieldHistory fetchSpecificFieldHistory(Field field, Integer gameYear) throws Exception {
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("field", field);
		restrictions.addEqual("gameYear", gameYear);
		List<BaseObject> objects = null;
		try {
			objects = this.fetchManySubclassObjects(new FieldHistory(), restrictions);
		} catch (Exception e) {
			throw new Exception ("Unable to fetch the field histories for field " + field.getId() + ": " + e.getMessage());
		}
		FieldHistory fieldHistory = null;
		if(objects.size()>1){
			throw new Exception("Too many field histories for field " + field.getId() + " in year " + gameYear + ": " + objects.size());
		} else if (objects.size()<1) {
			throw new Exception("No field history found for field " + field.getId() + " in year " + gameYear);
		} else {
			fieldHistory = (FieldHistory) objects.get(0);
		}
		return fieldHistory;
	}
	private Integer generateFieldQuality(){
		Random generator = new Random();
		return generator.nextInt(3) + 1;
	}
}
