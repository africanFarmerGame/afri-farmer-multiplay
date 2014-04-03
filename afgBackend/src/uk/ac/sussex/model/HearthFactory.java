/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

/**
 * 
 */
package uk.ac.sussex.model;

import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.base.BaseFactory;
import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.model.base.RestrictionList;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.utilities.Logger;

/**
 * @author em97
 *
 */
public class HearthFactory extends BaseFactory {

	/**
	 * @param args
	 */
	public HearthFactory() {
		super(new Hearth());
	}
	public Set<Hearth> createHearths(Double numFamilies, Game game) throws Exception{

		Set<Hearth> hearths = new HashSet<Hearth>();
		Set<String> names = this.possibleNames();
		Iterator<String> nameIterator = names.iterator();
		for (Integer housenumber= 0; housenumber < numFamilies; housenumber++){
			Hearth hearth = new Hearth();
			hearth.setName(nameIterator.next());
			hearth.setGame(game);
			hearth.setHousenumber(housenumber);
			hearth.save();
			
			Logger.Log("Internal", "Created hearth "+hearth.getName()+ " for game "+game.getGameName());
			hearths.add(hearth);
		}
		return hearths;
	}
	public Hearth fetchHearth(Integer id) throws Exception{
		return (Hearth) this.fetchSingleObject(id);
	}
	public Set<Hearth> fetchGameHearths(Game game) throws Exception{
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("game", game);
		List<BaseObject> objects = this.fetchManyObjects(restrictions);
		Set<Hearth> hearths = new HashSet<Hearth>();
		for (BaseObject object : objects ) {
			hearths.add((Hearth) object);
		}
		return hearths;
	}
	private Set<String> possibleNames(){
		Set<String> names = new HashSet<String>();
		
		names.add("Karoti");
		names.add("Mahindi");
		names.add("Tango");
		names.add("Kitunguu-Saumu");
		names.add("Mboga-Ya_Saladi");
		names.add("Uyoga");
		names.add("Njegere");
		names.add("Kitunguu");
		names.add("Viazi");
		names.add("Nyanya");
		names.add("Limau");
		names.add("Tofaa");
		names.add("Ndizi");
		names.add("Chungwa");
		names.add("Hindi");
		names.add("Zabibu");
		names.add("Kiazi");
		names.add("Nanasi");
		names.add("Kabichi");
		names.add("Boga");
		names.add("Matunda");
		names.add("Mboga");
		names.add("Wali");
		
		return names;
	}
}
