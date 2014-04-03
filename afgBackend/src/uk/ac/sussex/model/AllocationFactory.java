/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.base.BaseFactory;
import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.model.base.RestrictionList;
import uk.ac.sussex.model.game.Game;

public class AllocationFactory extends BaseFactory {
	public AllocationFactory(){
		super(new Allocation());
	}
	public Set<Allocation> fetchHearthAllocations(Hearth hearth, Integer year) throws Exception {
		RestrictionList rl = new RestrictionList();
		rl.addEqual("household", hearth);
		rl.addEqual("gameYear", year);
		rl.addEqual("deleted", 0);
		List<BaseObject> objects = this.fetchManyObjects(rl);
		Set<Allocation> assets = new HashSet<Allocation>();
		for (BaseObject object: objects){
			assets.add((Allocation) object);
		}
		return assets;
	}
	public Allocation fetchAllocation(Integer allocationId) throws Exception {
		Allocation allocation = (Allocation) this.fetchSingleObject(allocationId);
		return allocation;
	}
	public Set<Allocation> fetchSelectedAllocations(Hearth hearth) throws Exception {
		RestrictionList rl = new RestrictionList();
		rl.addEqual("household", hearth);
		rl.addEqual("selected", 1);
		List<BaseObject> objects = this.fetchManyObjects(rl);
		Set<Allocation> allocations = new HashSet<Allocation>();
		for (BaseObject object: objects){
			allocations.add((Allocation) object);
		}
		return allocations;
	}
	public Allocation createOrUpdateAllocation(Integer allocationId, 
											String allocationName, 
											Integer allocationSelected, 
											Hearth hearth, 
											Game currentGame, 
											Integer actual) throws Exception{
		Allocation allocation; 
		if (allocationId > -1){
			AllocationFactory af = new AllocationFactory();
			allocation = af.fetchAllocation(allocationId);
		} else {
			allocation = new Allocation();
		}
		allocation.setHousehold(hearth);
		allocation.setName(allocationName);
		allocation.setSelected(allocationSelected);
		allocation.setGameYear(currentGame.getGameYear());
		allocation.setActual(actual);
		allocation.save();
		return allocation;
	}
	public Allocation fetchCurrentHearthAllocation(Hearth hearth, Integer year) throws Exception {
		RestrictionList rl = new RestrictionList();
		Allocation allocation = null;
		rl.addEqual("household", hearth);
		rl.addEqual("selected", 1);
		rl.addEqual("gameYear", year);
		List<BaseObject> objects = this.fetchManyObjects(rl);
		if(objects.size()>1){
			throw new Exception("Too many selected allocations for this year " + year.toString() + " for household " + hearth.getId());
		} else if (objects.size()<1) {
			throw new Exception ("No selected allocation for this year " + year.toString() + " for household " + hearth.getId());
		} else {
			allocation = (Allocation) objects.get(0);
		}
		return allocation;
	}
	public Allocation fetchActualHearthAllocation(Hearth hearth, Integer year) throws Exception {
		RestrictionList rl = new RestrictionList();
		Allocation allocation = null;
		rl.addEqual("household", hearth);
		rl.addEqual("actual", 1);
		rl.addEqual("gameYear", year);
		List<BaseObject> objects = this.fetchManyObjects(rl);
		if(objects.size()>1){
			throw new Exception("Too many actual allocations for this year " + year.toString() + " for household " + hearth.getId());
		} else if (objects.size()<1) {
			throw new Exception ("No actual allocation for this year " + year.toString() + " for household " + hearth.getId());
		} else {
			allocation = (Allocation) objects.get(0);
		}
		return allocation;
	}
}
