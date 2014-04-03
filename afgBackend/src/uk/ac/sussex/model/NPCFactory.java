package uk.ac.sussex.model;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Random;
import java.util.Set;

import uk.ac.sussex.model.base.BaseFactory;
import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.model.base.RestrictionList;
import uk.ac.sussex.utilities.NameGenerator;

public class NPCFactory extends BaseFactory {

	public NPCFactory() {
		super(new NPC());
	}
	/**
	 * Creates a child aged between 0 and 7 of a random gender.
	 * Baby needs a mother! 
	 * @param parent
	 * @return
	 */
	public NPC createBaby(AllChars parent) throws Exception {
		NPC child = new NPC();
		
		Random generator = new Random();
		Integer age = generator.nextInt(8);
		child.setAge(age);
		Integer avatarBody = generator.nextInt(4) + 1;
		child.setAvatarBody(avatarBody);
		
		RoleFactory rf = new RoleFactory();
		Role childRole = rf.fetchRandomRole();
		
		child.setRole(childRole);
		child.setName(this.generateUniqueFirstName(childRole, parent.getHearth()));
		child.setFamilyName(parent.getFamilyName());
		child.setParent(parent);
		
		child.setSchool(0);
		
		child.save();
		
		return child;
	}
	/**
	 * Creates a child aged between 8 and 14 of a random gender.
	 * These children need assigning to a hearth.
	 * @param hearth
	 * @return
	 */
	public NPC createChild(Hearth hearth) throws Exception {
		NPC child = new NPC();
		
		Random generator = new Random();
		Integer age = generator.nextInt(7) + 7;
		child.setAge(age);
		
		Integer avatarBody = generator.nextInt(4) + 1;
		child.setAvatarBody(avatarBody);
		
		RoleFactory rf = new RoleFactory();
		Role childRole = rf.fetchRandomRole();
		
		child.setRole(childRole);
		child.setName(this.generateUniqueFirstName(childRole, hearth));
		child.setFamilyName(hearth.getName());
		child.setHearth(hearth);
		
		child.setSchool(0);
		
		child.save();
		
		return child;
	}
	public NPC createAdult(Hearth hearth) throws Exception {
		NPC adult = new NPC();
		
		Random generator = new Random();
		Integer age = generator.nextInt(7) + NPC.ADULT_AGE + 1;
		adult.setAge(age);
		
		Integer avatarBody = generator.nextInt(4) + 1;
		adult.setAvatarBody(avatarBody);
		
		RoleFactory rf = new RoleFactory();
		Role adultRole = rf.fetchRandomRole();
		adult.setRole(adultRole);
		
		adult.setFamilyName(hearth.getName());
		adult.setName(this.generateUniqueFirstName(adultRole, hearth));
		adult.setHearth(hearth);
		adult.setSchool(0);
		adult.save();
		return adult;
	}
	public Set<NPC> fetchPCBabies(PlayerChar pc) throws Exception{
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("parent", pc);
		List<BaseObject> objects = this.fetchManyObjects(restrictions);
		Set<NPC> babies = new HashSet<NPC>();
		for (BaseObject object : objects ) {
			babies.add((NPC) object);
		}
		return babies;
	}
	public Set<NPC> fetchNPCBabies(NPC npc) throws Exception{
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("parent", npc);
		List<BaseObject> objects = this.fetchManyObjects(restrictions);
		Set<NPC> babies = new HashSet<NPC>();
		for (BaseObject object : objects ) {
			babies.add((NPC) object);
		}
		return babies;
	}
	public Set<NPC> fetchHearthChildren(Hearth hearth) throws Exception {
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("hearth", hearth);
		List<BaseObject> objects = this.fetchManyObjects(restrictions);
		Set<NPC> offspring = new HashSet<NPC>();
		for (BaseObject object : objects ) {
			offspring.add((NPC) object);
		}
		return offspring;
	}
	public Set<NPC> fetchHearthWomen(Hearth hearth) throws Exception {
		RoleFactory rf = new RoleFactory();
		Role woman = rf.fetchRole("WOMAN");
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("hearth", hearth);
		restrictions.addEqual("role", woman);
		restrictions.addGTInt("age", NPC.ADULT_AGE);
		
		List<BaseObject> objects = this.fetchManyObjects(restrictions);
		Set<NPC> women = new HashSet<NPC>();
		for (BaseObject object : objects ){
			women.add((NPC) object);
		}
		return women;
	}
	public NPC fetchNPC(Integer id) throws Exception {
		NPC npc = (NPC) this.fetchSingleObject(id);
		return npc;
	}
	private String generateUniqueFirstName(Role role, Hearth hearth) throws Exception {
		PlayerCharFactory pcFactory = new PlayerCharFactory();
		NPCFactory npcFactory = new NPCFactory();
		Set<PlayerChar> pcs = pcFactory.fetchHearthPCs(hearth);
		List<String> currentNames = new ArrayList<String>();
		for(PlayerChar pc: pcs){
			if(pc.getName()!=null){
				currentNames.add(pc.getName());
			}
			if(pc.getBabyCount()>0){
				Set<NPC> babies = npcFactory.fetchPCBabies(pc);
				for(NPC baby: babies){
					currentNames.add(baby.getName());
				}
			}
		}
		Set<NPC> npcs = npcFactory.fetchHearthChildren(hearth);
		for(NPC npc: npcs){
			currentNames.add(npc.getName());
			if(npc.getBabyCount()>0){
				Set<NPC> babies = npcFactory.fetchNPCBabies(npc);
				for(NPC baby: babies){
					currentNames.add(baby.getName());
				}
			}
		}
		String name = NameGenerator.generateName(role, currentNames);
		return name;
	}
}
