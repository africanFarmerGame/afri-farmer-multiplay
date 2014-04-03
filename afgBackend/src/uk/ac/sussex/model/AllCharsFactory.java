package uk.ac.sussex.model;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.base.BaseFactory;
import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.model.base.RestrictionList;

public class AllCharsFactory extends BaseFactory {
	public AllCharsFactory(){
		super(new AllChars());
	}
	public Set<AllChars> fetchHearthMembers(Hearth hearth) throws Exception {
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("hearth", hearth);
		List<BaseObject> objects = this.fetchManyObjects(restrictions);
		Set<AllChars> members = new HashSet<AllChars>();
		for (BaseObject object : objects ) {
			members.add((AllChars) object);
		}
		return members;
	}
	public AllChars fetchAllChar(Integer charId) throws Exception {
		AllChars allChar = (AllChars) this.fetchSingleObject(charId);
		return allChar;
	}
	public Set<NPC> fetchAnyBabies(AllChars parent) throws Exception{
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("parent", parent);
		List<BaseObject> objects = this.fetchManyObjects(restrictions);
		Set<NPC> babies = new HashSet<NPC>();
		for (BaseObject object : objects ) {
			babies.add((NPC) object);
		}
		return babies;
	}
	public Integer countLivingHearthMembers(Hearth hearth) throws Exception {
		Set<AllChars> members = fetchHearthMembers(hearth);
		Integer memberCount = 0;
		for(AllChars member : members){
			if(!member.getAlive().equals(AllChars.DEAD)){
				memberCount ++;
			}
			if(member.getRole().equals(Role.WOMAN)){
				//Check for babies. 
				if(member.getBabyCount()>0){
					Set<NPC> babies = this.fetchAnyBabies(member);
					for(NPC baby: babies){
						if(!baby.getAlive().equals(AllChars.DEAD)){
							memberCount ++;
						}
					}
				}
			}
		}
		return memberCount;
	}
}
