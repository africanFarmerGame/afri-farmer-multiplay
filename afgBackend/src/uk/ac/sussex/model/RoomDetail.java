/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.game.Game;

public class RoomDetail {
	private Game game;
	public RoomDetail(Game game){
		this.game = game;
	}
	public Integer checkRoomState(PlayerChar pc, RoomTypes roomtype) throws Exception{
		//This is going to be different for a banker to a general player.
		if(pc.getRole().getId().equals(Role.BANKER)){
			return 0;
		}
		switch(roomtype){
		case VILLAGE:
			return checkVillage();
		case HOME:
			return checkHome(pc);
		case BANK:
			return checkBank(pc);
		case MARKET:
			return checkMarket();
		case FARM:
			return checkFarm(pc);
		default:
			return -1;
		}
	}
	public Integer checkRoomState(Hearth hearth, RoomTypes roomtype) throws Exception {
		switch(roomtype){
		case VILLAGE:
			return checkVillage();
		case HOME:
			return checkHome(hearth);
		case BANK:
			return checkBank(hearth);
		case MARKET:
			return checkMarket();
		case FARM:
			return checkFarm(hearth);
		default:
			return -1;
		}
	}
	private Integer checkVillage(){
		return 0;
	}
	private Integer checkHome(PlayerChar pc) throws Exception{
		if(pc.getHearth()==null){
			return 0;
		}
		Hearth hearth = fetchPCHearth(pc.getHearth().getId());
		return checkHome(hearth);
	}
	private Integer checkHome(Hearth hearth) throws Exception {
		NPCFactory npcf = new NPCFactory();
		Set<PlayerChar> characters = hearth.getCharacters();
		Set<NPC> babies = new HashSet<NPC>();
		Integer CDiet = 0;
		Integer BDiet = 0;
		Integer total = 0;
		for(PlayerChar character: characters){
			if(character.getAlive().equals(1)){
				total++;
				DietaryLevels diet = DietaryLevels.toOption(character.getDiet()); 
				switch(diet){
				case A:
					break;
				case B:
					BDiet ++;
					break;
				case C:
					CDiet ++;
					break;
				default:
				}
			}
			if(character.getBabyCount()>0){
				babies = npcf.fetchPCBabies(character);
				for (NPC baby: babies){
					if(baby.getAlive().equals(1)){
						total++;
						DietaryLevels diet = DietaryLevels.toOption(character.getDiet()); 
						switch(diet){
						case A:
							break;
						case B:
							BDiet ++;
							break;
						case C:
							CDiet ++;
							break;
						default:
						}
					}
				}
			}
			Set<NPC> npcs = npcf.fetchHearthChildren(hearth);
			for (NPC npc: npcs){
				if(npc.getAlive().equals(1)){
					total++;
					DietaryLevels diet = DietaryLevels.toOption(character.getDiet()); 
					switch(diet){
					case A:
						break;
					case B:
						BDiet ++;
						break;
					case C:
						CDiet ++;
						break;
					default:
					}
				}
				if(npc.getBabyCount()>0){
					babies = npcf.fetchPCBabies(character);
					for (NPC baby: babies){
						if(baby.getAlive().equals(1)){
							total++;
							DietaryLevels diet = DietaryLevels.toOption(character.getDiet()); 
							switch(diet){
							case A:
								break;
							case B:
								BDiet ++;
								break;
							case C:
								CDiet ++;
								break;
							default:
							}
						}
					}
				}
			}
		}
		if(CDiet==0){
			return 0;
		} else if (CDiet >= total) {
			return 2;
		} else {
			return 1;
		}
	}
	
	private Integer checkBank(PlayerChar pc) throws Exception{
		if(pc.getHearth()==null){
			return 0;
		}
		Hearth hearth = fetchPCHearth(pc.getHearth().getId());
		return checkBank(hearth);
	}
	private Integer checkBank(Hearth hearth) throws Exception {
		BillFactory ff = new BillFactory();
		List<Bill> fines = ff.fetchHearthFines(hearth);

		Integer unpaidCount = 0;
		for (Bill fine: fines){
			if(fine.getPaid()==0){
				unpaidCount ++;
				
			}
		}
		if(unpaidCount==0){
			return 0;
		} else if (unpaidCount<2){
			return 1;
		} else {
			return 2;
		}
	}
	private Integer checkMarket(){
		return 0;
	}
	private Integer checkFarm(PlayerChar pc) throws Exception{
		if(pc.getHearth()==null){
			//TODO: Implement a check for the fields that a player may own separately. 
			return 0;
		}
		Hearth hearth = fetchPCHearth(pc.getHearth().getId());
		return checkFarm(hearth);
	}
	private Integer checkFarm(Hearth hearth) throws Exception {
		SeasonDetail seasonDetail = game.getCurrentSeasonDetail();
		
		List<Field> fields = hearth.fetchFields();
		
		Integer sickCrops = 0;
		Integer noCrop = 0;
		Integer unwellCrops = 0;
		Integer totalFields = fields.size();
		Integer currentbugs = 0;
		HazardFactory hf = new HazardFactory();
		for (Field field: fields){
			if(field.getCrop()==null){
				noCrop ++;
			} else {
				Integer cropHealth = field.getCropHealth();
				if(cropHealth < 80 && cropHealth >= 50){
					unwellCrops ++;
				} else if (cropHealth < 50){
					sickCrops ++;
				}
				FieldHazardHistory hazard = hf.fetchCurrentFieldHazard(field, seasonDetail);
				if(hazard!=null){
					currentbugs ++;
				}
			}
		}
		if(totalFields > 0){
			Double noCropFields = (double) (noCrop/totalFields);
			if(noCropFields>0.8||sickCrops>0){
				return 2;
			} else if (currentbugs>0 || noCropFields>0.5 || unwellCrops > 0){
				return 1;
			} else {
				return 0;
			}
		} else {
			return 0;
		}
	}
	private Hearth fetchPCHearth(Integer hearthId) throws Exception {
		HearthFactory hf = new HearthFactory();
		Hearth hearth = hf.fetchHearth(hearthId);
		return hearth;
	}
}
