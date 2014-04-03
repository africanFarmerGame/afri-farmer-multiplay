package uk.ac.sussex.model;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.base.BaseFactory;
import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.model.base.RestrictionList;

public class AllocationItemFactory extends BaseFactory {
	public AllocationItemFactory(){
		super(new AllocationItem());
	}
	public Set<AllocationItem> fetchAllocationItems(Allocation allocation) throws Exception {
		RestrictionList rl = new RestrictionList();
		rl.addEqual("allocation", allocation);
		List<BaseObject> objects = this.fetchManyObjects(rl);
		Set<AllocationItem> assets = new HashSet<AllocationItem>();
		for (BaseObject object: objects){
			assets.add((AllocationItem) object);
		}
		return assets;
	}
	public Set<AllocationItem> fetchCharacterAllocationItems(Allocation allocation, AllChars character) throws Exception {
		RestrictionList rl = new RestrictionList();
		rl.addEqual("allocation", allocation);
		rl.addEqual("character", character);
		List<BaseObject> objects = this.fetchManyObjects(rl);
		Set<AllocationItem> items = new HashSet<AllocationItem>();
		for (BaseObject object: objects){
			items.add((AllocationItem) object);
		}
		return items;
	}
	public Set<AllocationItem> fetchFoodAllocationItems(Allocation allocation, AssetFood food) throws Exception {
		RestrictionList rl = new RestrictionList();
		rl.addEqual("allocation", allocation);
		rl.addEqual("asset", food);
		List<BaseObject> objects = this.fetchManyObjects(rl);
		Set<AllocationItem> items = new HashSet<AllocationItem>();
		for (BaseObject object: objects){
			items.add((AllocationItem) object);
		}
		return items;
	}
	public Set<AllocationItem> createChildAllocationItems(AllChars character, Allocation allocation) throws Exception {
		NPC npcChar = (NPC) character;
		if(npcChar==null){
			//This is a problem, no none NPCs should be passed to this. 
			throw new Exception("Problem creating Child Allocation Items. Character " + character.getId() + " is not a child.");
		}
		Asset maize = new Asset();
		maize.setId(2);
		Asset beans = new Asset();
		beans.setId(7);
		Asset horticulture = new Asset();
		horticulture.setId(11);
		AllocationItem myMaize = new AllocationItem();
		myMaize.setAsset(maize);
		myMaize.setCharacter(character);
		myMaize.setAllocation(allocation);
		AllocationItem myBeans = new AllocationItem();
		myBeans.setAsset(beans);
		myBeans.setCharacter(character);
		myBeans.setAllocation(allocation);
		AllocationItem myHorti = new AllocationItem();
		myHorti.setAsset(horticulture);
		myHorti.setAllocation(allocation);
		myHorti.setCharacter(character);
		myHorti.setAmount(0);
		if(npcChar.getAge() >= NPC.CHILD_AGE){
			myMaize.setAmount(1);
			myBeans.setAmount(1);
		} else {
			myMaize.setAmount(1);
			myBeans.setAmount(0);
		}
		try{
			myMaize.save();
			myBeans.save();
			myHorti.save();
		} catch (Exception e) {
			throw new Exception("Problem saving allocation item for character " + character.getId() + " in allocation " + allocation.getId() + ": " + e.getMessage() );
		}
		Set<AllocationItem> allocItems = new HashSet<AllocationItem>();
		allocItems.add(myBeans);
		allocItems.add(myMaize);
		allocItems.add(myHorti);
		return allocItems;
	}
	public Set<AllocationItem> createAdultAllocationItems(AllChars character, Allocation allocation) throws Exception {
		Asset maize = new Asset();
		maize.setId(2);
		Asset beans = new Asset();
		beans.setId(7);
		Asset horticulture = new Asset();
		horticulture.setId(11);
		AllocationItem myMaize = new AllocationItem();
		myMaize.setAsset(maize);
		myMaize.setCharacter(character);
		myMaize.setAllocation(allocation);
		AllocationItem myBeans = new AllocationItem();
		myBeans.setAsset(beans);
		myBeans.setCharacter(character);
		myBeans.setAllocation(allocation);
		AllocationItem myHorti = new AllocationItem();
		myHorti.setAsset(horticulture);
		myHorti.setAllocation(allocation);
		myHorti.setCharacter(character);
		if(character.getRole().getId().equals(Role.MAN)){
			myMaize.setAmount(2);
			myBeans.setAmount(1);
			myHorti.setAmount(1);
		} else {
			myMaize.setAmount(1);
			myBeans.setAmount(1);
			myHorti.setAmount(1);
		}
		try {
			myMaize.save();
			myBeans.save();
			myHorti.save();
		} catch (Exception e) {
			throw new Exception("Problem saving allocation item for character " + character.getId() + " in allocation " + allocation.getId() + ": " + e.getMessage() );
		}
		Set<AllocationItem> allocItems = new HashSet<AllocationItem>();
		allocItems.add(myBeans);
		allocItems.add(myMaize);
		allocItems.add(myHorti);
		return allocItems;
	}
	public void removeCharAllocationItems(AllChars character, Allocation allocation) throws Exception {
		Set<AllocationItem> characterItems = fetchCharacterAllocationItems(allocation, character);
		for (AllocationItem charItem: characterItems){
			charItem.delete();
		}
	}
}
