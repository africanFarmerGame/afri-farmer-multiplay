/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.grading;

import java.util.Set;

import uk.ac.sussex.model.DietaryLevels;
import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.HearthFactory;
import uk.ac.sussex.model.NPC;
import uk.ac.sussex.model.NPCFactory;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.utilities.Logger;

public class CoreDietXCriterion extends GradingCriterion {
	public static String TYPE = "COREDIETX";
	
	public CoreDietXCriterion(){
		super();
		this.setType(TYPE);
	}
	/* (non-Javadoc)
	 * @see uk.ac.sussex.model.grading.ICriterion#calculateValue(uk.ac.sussex.model.PlayerChar)
	 */
	@Override
	public void calculateValue(PlayerChar pc, Integer gameYear) {
		CoreDietXCriterion cdxc = new CoreDietXCriterion();
		HearthFactory hf = new HearthFactory();
		PlayerCharFactory pcf = new PlayerCharFactory();
		NPCFactory npcf = new NPCFactory();
		Double totalX = 0.0;
		String dietaryLevelX = DietaryLevels.X.toString();
		if(pc.getHearth()!=null){
			Hearth hearth = null;
			try {
				hearth = hf.fetchHearth(pc.getHearth().getId());
			} catch (Exception e) {
				Logger.ErrorLog("CoreDietXCriterion.calculateValue", "Problem fetching the hearth for pc " + pc.getId() + ": " + e.getMessage());
				return;
			}
			try {
				Set<PlayerChar> pcs = pcf.fetchHearthPCs(hearth);
				for (PlayerChar pc1: pcs){
					if(pc1.getDiet().equals(dietaryLevelX)){
						totalX++;
					}
					if(pc1.getBabyCount()>0){
						Set<NPC> babies = npcf.fetchPCBabies(pc1);
						for (NPC baby: babies){
							if(baby.getDiet().equals(dietaryLevelX)){
								totalX ++;
							}
						}
					}
				}
			} catch (Exception e) {
				Logger.ErrorLog("CoreDietXCriterion.calculateValue", "Problem with the player chars in hearth " + hearth.getId() + ": " + e.getMessage());
			}
			try {
				Set<NPC> npcs = npcf.fetchHearthChildren(hearth);
				for(NPC hearthmember: npcs){
					if(hearthmember.getDiet().equals(dietaryLevelX)){
						totalX ++;
						if(hearthmember.getBabyCount()>0){
							Set<NPC> babies = npcf.fetchNPCBabies(hearthmember);
							for (NPC baby: babies){
								if(baby.getDiet().equals(dietaryLevelX)){
									totalX++;
								}
							}
						}
					}
				}
			} catch (Exception e) {
				Logger.ErrorLog("CoreDietXCriterion.calculateValue", "Problem with the npcs in hearth " + hearth.getId() + ": " + e.getMessage());
			}
			cdxc.setGameYear(gameYear);
			cdxc.setHearth(hearth);
			cdxc.setPc(pc);
			cdxc.setValue(totalX);
			try {
				cdxc.save();
			} catch(Exception e){
				Logger.ErrorLog("CoreDietXCriterion.calculateValue", "Problem saving the total on X diet.");
			}
		}
	}
}
