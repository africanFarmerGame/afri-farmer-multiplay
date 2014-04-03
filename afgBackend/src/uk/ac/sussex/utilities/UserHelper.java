package uk.ac.sussex.utilities;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
import com.smartfoxserver.v2.entities.variables.UserVariable;

import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.model.Role;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;

public class UserHelper {
	public static Game fetchUserGame(User user) throws Exception {
		UserVariable pcObjVar = user.getVariable("pc");
		ISFSObject pcObj = pcObjVar.getSFSObjectValue();
		
		Integer pcId = pcObj.getInt("id");
		
		PlayerCharFactory pcf = new PlayerCharFactory();
		PlayerChar pc = pcf.fetchPlayerChar(pcId);
		if(pc == null){
			throw new Exception("UserHelper: unable to retrieve playerchar for user " + user.getName());
		}
		GameFactory gf = new GameFactory();
		Integer gameId = pc.getGame().getId();
		Game game = gf.fetchGame(gameId);
		if(game==null){
			throw new Exception("UserHelper: unable to retrieve game: " + gameId);
		}
		return game;
	}
	public static PlayerChar fetchUserPC(User user) throws Exception {
		UserVariable pcObjVar = user.getVariable("pc");
		ISFSObject pcObj = pcObjVar.getSFSObjectValue();
		
		Integer pcId = pcObj.getInt("id");
		
		PlayerCharFactory pcf = new PlayerCharFactory();
		PlayerChar pc = pcf.fetchPlayerChar(pcId);
		return pc;
	}
	/**
	 * This returns a 
	 * @param pc
	 * @return 
	 */
	public static SFSUserVariable fetchUserVarPC(PlayerChar pc){
		SFSObject pcObj = SFSObject.newInstance();
		pcObj.putInt("id", pc.getId());
		pcObj.putUtfString("firstname",pc.getName()); 
		pcObj.putUtfString("familyname", pc.getFamilyName());
		
		Hearth pcHearth = pc.getHearth();
		if(pcHearth != null){
			pcObj.putInt("hearthid", pcHearth.getId());
		} else {
			pcObj.putNull("hearthid");
		}
		
		pcObj.putInt("avatarbody", pc.getAvatarBody());
		
		Role role = pc.getRole();
		pcObj.putUtfString("role", role.getId());
		
		SFSUserVariable pcUserVar = SFSUserVariable.newInstance("pc", pcObj);
		return pcUserVar;
	}
}
