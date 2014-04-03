/**
 * 
 */
package uk.ac.sussex.model;

import java.util.HashSet;
import java.util.List;
import java.util.Random;
import java.util.Set;

//import uk.ac.sussex.general.Logger;
import uk.ac.sussex.model.base.BaseFactory;
import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.model.base.RestrictionList;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.utilities.NameGenerator;

/**
 * @author em97
 *
 */
public class PlayerCharFactory extends BaseFactory {
	public PlayerCharFactory() {
		super(new PlayerChar());
	}
	public PlayerChar fetchPlayerChar(Integer pcID) throws Exception{
		PlayerChar pc = null;
		try {
			pc = (PlayerChar) this.fetchSingleObject(pcID);
		} catch (Exception e){
			String eMessage = e.getMessage();
			if(eMessage.contains("identifier")){
				throw new Exception ("No game found with that name.");
			} else {
				throw new Exception ("Problem getting player character: " + eMessage);
			}
		}
		return pc;
	}
	/**
	 * Please use this one from now on. 
	 * @param game
	 * @return Set of PlayerChar
	 * @throws Exception
	 */
	public Set<PlayerChar> fetchGamePCs(Game game) throws Exception {
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("game", game);
		List<BaseObject> objects = this.fetchManyObjects(restrictions);
		Set<PlayerChar> pcs = new HashSet<PlayerChar>();
		for (BaseObject object : objects ) {
			pcs.add((PlayerChar) object);
		}
		return pcs;
	}
	public PlayerChar createBanker(Game game) throws Exception {
		PlayerChar banker = new PlayerChar();
		RoleFactory rf = new RoleFactory();
		banker.setRole(rf.fetchRole("BANKER"));
		banker.setGame(game);
		banker.setName("Game");
		banker.setFamilyName("Manager");
		banker.setAvatarBody(1);
		banker.setSocialStatus(5);
		banker.save();
		return banker;
	}
	public Set<PlayerChar> createWomen(Integer numWomen, Game game) throws Exception {
		Set<PlayerChar> women = new HashSet<PlayerChar>();
		RoleFactory rf = new RoleFactory();
		Role womanRole = rf.fetchRole("WOMAN");
		NPCFactory npcf = new NPCFactory();
		Random generator = new Random();
		
		for (Integer i =0; i<numWomen; i++){
			PlayerChar woman = new PlayerChar();
			woman.setRole(womanRole);
			woman.setGame(game);
			woman.setFamilyName(NameGenerator.generateFamilyName());
			woman.setName("Auto" + i.toString());
			woman.setSocialStatus(5);
			//This may be temporary, not sure. 
			woman.setAvatarBody(generator.nextInt(4) + 1);
			woman.save();
			//Generate babies. 
			Integer numBabies = generator.nextInt(2);
			for (Integer babyCount=0;babyCount<numBabies;babyCount++){
				npcf.createBaby(woman);
			}
			women.add(woman);
			}
		return women;
	}
	public Set<PlayerChar> createMen(Integer numMen, Game game) throws Exception{
		Set<PlayerChar> men = new HashSet<PlayerChar>();
		RoleFactory rf = new RoleFactory();
		Role manRole = rf.fetchRole("MAN");
		for (Integer i =0; i<numMen; i++){
			PlayerChar man = new PlayerChar();
			man.setRole(manRole);
			man.setGame(game);
			man.setFamilyName(NameGenerator.generateFamilyName());
			man.setName("Auto" + i.toString());
			//This may be temporary, not sure. 
			Random generator = new Random();
			man.setAvatarBody(generator.nextInt(4) + 1);
			man.setSocialStatus(5);
			man.save();
			
			men.add(man);
		}
		return men;
	}
	public Set<PlayerChar> fetchMen(Game game) throws Exception {
		Set<PlayerChar> men = new HashSet<PlayerChar>();
		RoleFactory rf = new RoleFactory();
		Role manRole = rf.fetchRole("MAN");
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("game", game);
		restrictions.addEqual("role", manRole);
		List<BaseObject> objects = this.fetchManyObjects(restrictions);
		for (BaseObject object : objects ) {
			men.add((PlayerChar) object);
		}
		return men;
	}
	public Set<PlayerChar> fetchWomen(Game game) throws Exception {
		Set<PlayerChar> women = new HashSet<PlayerChar>();
		RoleFactory rf = new RoleFactory();
		Role womanRole = rf.fetchRole("WOMAN");
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("game", game);
		restrictions.addEqual("role", womanRole);
		List<BaseObject> objects = this.fetchManyObjects(restrictions);
		for (BaseObject object : objects ) {
			women.add((PlayerChar) object);
		}
		return women;
	}
	/**
	 * Deprecated in favour of the better-named fetchGamePCs 
	 * @param game
	 * @return
	 * @throws Exception
	 */
	public Set<PlayerChar> fetchAll(Game game) throws Exception {
		Set<PlayerChar> all = new HashSet<PlayerChar>();
		RestrictionList rl = new RestrictionList();
		rl.addEqual("game", game);
		List<BaseObject> objects = this.fetchManyObjects(rl);
		for( BaseObject object : objects ){
			all.add((PlayerChar) object);
		}
		return all;
	}
	public Set<PlayerChar> fetchHearthPCs(Hearth hearth) throws Exception {
		Set<PlayerChar> hearthPCs = new HashSet<PlayerChar>();
		RestrictionList rl = new RestrictionList();
		rl.addEqual("hearth", hearth);
		List<BaseObject> objects = this.fetchManyObjects(rl);
		for( BaseObject object: objects ) {
			hearthPCs.add((PlayerChar) object);
		}
		return hearthPCs;
	}
	public Set<PlayerChar> fetchHearthlessPCs(Game game) throws Exception {
		Set<PlayerChar> hearthlessPCs = new HashSet<PlayerChar>();
		
		RestrictionList rl = new RestrictionList();
		rl.addEqual("game", game);
		rl.addNotEqual("alive", 0);
		List<BaseObject> objects = this.fetchManyObjects(rl);
		for( BaseObject object: objects){
			PlayerChar pcObject = (PlayerChar) object;
			if(!pcObject.getRole().getId().equals(Role.BANKER) && pcObject.getHearth()==null){
				hearthlessPCs.add(pcObject);
			}
		}
		
		return hearthlessPCs;
	}
}
