/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.gameEvents;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;

public class CoreAnnounceHealthHazardEvent extends GameEvent {
	
	private final double PERCENTAGE_ILL = 0.5;
	private final String STARVED = "Starvation";
	
	public CoreAnnounceHealthHazardEvent(Game game) {
		super(game);
	}

	@Override
	public void fireEvent() throws Exception {
		//Go through each hearth in the game, dealing with each character.
		PlayerCharFactory pcf = new PlayerCharFactory();
		NPCFactory npcf = new NPCFactory();
		
		Set<Hearth> hearths = game.fetchHearths();
		for (Hearth hearth: hearths){
			//Kill off any hearth members on X-level diet.
			Set<PlayerChar> pcs = pcf.fetchHearthPCs(hearth);
			Set<NPC> npcs = npcf.fetchHearthChildren(hearth);
			//The hearth assets
			Set <NPC> babies = new HashSet<NPC>();
			//For each hearth member, starting with player chars
			for (PlayerChar pc: pcs){
				if(pc.getAlive().equals(1)){
					if(pc.getBabyCount()>0){
						Set<NPC> pcbabies = npcf.fetchPCBabies(pc);
						babies.addAll(pcbabies);
					}
					DietaryLevels dietLevel = DietaryLevels.toOption(pc.getDiet());
					if(dietLevel.equals(DietaryLevels.X)){
						pc.setAlive(AllChars.DEAD);
						generateDeathDuty(pc, hearth, STARVED);
					} else {
						pc.setAlive(generateHazard(pc, dietLevel, hearth));
					}
					pc.save();
				}
			}
			for(NPC npc:npcs){
				if(npc.getAlive().equals(1)){
					if(npc.getBabyCount()>0){
						Set<NPC> npcbabies = npcf.fetchNPCBabies(npc);
						babies.addAll(npcbabies);
					}
					DietaryLevels dietLevel = DietaryLevels.toOption(npc.getDiet());
					if(dietLevel.equals(DietaryLevels.X)){
						npc.setAlive(AllChars.DEAD);
						generateDeathDuty(npc, hearth, STARVED);
					} else {
						npc.setAlive(generateHazard(npc, dietLevel, hearth));
					}
					npc.save();
				}
			}
			for (NPC baby: babies){
				if(baby.getAlive().equals(1)){
					DietaryLevels dietLevel = DietaryLevels.toOption(baby.getDiet());
					if(dietLevel.equals(DietaryLevels.X)){
						baby.setAlive(0);
						generateDeathDuty(baby, hearth, STARVED);
					} else {
						baby.setAlive(generateHazard(baby, dietLevel, hearth));
					}
					baby.save();
				}
			}
		}
		
	}
	private Integer generateHazard(AllChars character, DietaryLevels dietLevel, Hearth hearth) throws Exception{
		//Let's start from the premise of staying healthy and work from there!
		if(Math.random()<PERCENTAGE_ILL){
			HealthHazardFactory hhf = new HealthHazardFactory();
			HealthHazard hazard = hhf.fetchRandomHealthHazard(dietLevel);
			Integer severity = (int) (Math.floor(Math.random() * 100));
			if(severity >= 0 && severity < hazard.getHospital()){
				generateCharHealthHazard(character, hazard, CharHealthHazard.OUTCOME_HOSPITAL, hearth);
				return AllChars.ILL;
			} else if (severity >= hazard.getHospital() && severity < hazard.getHospital() + hazard.getDeath()){
				generateCharHealthHazard(character, hazard, CharHealthHazard.OUTCOME_DEATH, hearth);
				return AllChars.DEAD;
			} else {
				return AllChars.ALIVE;
			}
		} else {
			return AllChars.ALIVE;
		}
	}
	private void generateCharHealthHazard(AllChars character, HealthHazard hazard, Integer outcome, Hearth hearth) throws Exception{
		CharHealthHazard chh = new CharHealthHazard();
		chh.setCharacter(character);
		chh.setHazard(hazard);
		chh.setSeason(game.getCurrentSeasonDetail());
		chh.setOutcome(outcome);
		
		if(outcome.equals(CharHealthHazard.OUTCOME_HOSPITAL)){
			Bill hospitalBill = generateHospitalBill(character, hazard, hearth);
			chh.setBill(hospitalBill);
		} else {
			Bill deathDuty = generateDeathDuty(character, hearth, hazard.getName());
			chh.setBill(deathDuty);
		}
		chh.save();
	}
	private Bill generateDeathDuty(AllChars character, Hearth hearth, String causeOfDeath) throws Exception{
		Bill deathDuty = BillFactory.newBill(BillDeathDuty.NAME);
		deathDuty.setPayee(hearth);
		deathDuty.setDescription("Funeral costs owing for " + character.getDisplayName() + "("+ causeOfDeath +")");
		deathDuty.setSeason(game.getCurrentSeasonDetail());
		deathDuty.setCharacter(character);
		deathDuty.save();
		return deathDuty;
	}
	private Bill generateHospitalBill(AllChars character, HealthHazard hazard, Hearth hearth) throws Exception {
		Bill hospitalBill = BillFactory.newBill(BillHospital.NAME);
		hospitalBill.setPayee(hearth);
		hospitalBill.setDescription("Hospital bill for " + character.getDisplayName() + ": " + hazard.getName());
		hospitalBill.setEarlyRate(hazard.getMedicineCost());
		hospitalBill.setLateRate(hazard.getMedicineCost());
		hospitalBill.setSeason(game.getCurrentSeasonDetail());
		hospitalBill.setCharacter(character);
		hospitalBill.save();
		return hospitalBill;
	}

	@Override
	public void generateNotifications() throws Exception {
		Set<Hearth> hearths = game.fetchHearths();
		PlayerCharFactory pcf = new PlayerCharFactory();
		NPCFactory npcf = new NPCFactory();
		SeasonNotificationFactory snf = new SeasonNotificationFactory();
		BillFactory billFactory = new BillFactory();
		int totalDeaths = 0;
		int totalIllnesses = 0;
		String gmNotification = "";
		for(Hearth hearth: hearths){
			int hazardCount = 0;
			Set <NPC> babies = new HashSet<NPC>();
			Set<PlayerChar> pcs = pcf.fetchHearthPCs(hearth);
			String notification = "Health Hazards: \n";
			List<Bill> deathDuties = billFactory.fetchOutstandingDeathDuty(hearth);
			hazardCount = deathDuties.size();
			String gmHearthNote = hearth.getName() + " had " + hazardCount + " deaths.\n";
			totalDeaths += hazardCount;
			for(Bill deathDuty: deathDuties){
				notification += deathDuty.getDescription() + "\n";
				gmHearthNote += deathDuty.getDescription() + "\n";
			}
			int illnessCount = 0;
			for (PlayerChar pc : pcs){
				if(pc.getAlive().equals(AllChars.ILL)){
					HealthHazard hazard = fetchCharacterHealthHazard(pc);
					illnessCount ++;
					notification += pc.getDisplayName() + " is unfortunately suffering from " + hazard.getName() + "\n";
				}
				if(pc.getBabyCount()>0){
					Set<NPC> pcbabies = npcf.fetchPCBabies(pc);
					babies.addAll(pcbabies);
				}
			}
			Set<NPC> npcs = npcf.fetchHearthChildren(hearth);
			for(NPC npc: npcs){
				if(npc.getAlive().equals(AllChars.ILL)){
					HealthHazard hazard = fetchCharacterHealthHazard(npc);
					illnessCount ++;
					notification += npc.getDisplayName() + " is unfortunately suffering from " + hazard.getName() + "\n";
				}
				if(npc.getBabyCount()>0){
					Set<NPC> npcbabies = npcf.fetchNPCBabies(npc);
					babies.addAll(npcbabies);
				}
			}
			for(NPC baby: babies){
				if(baby.getAlive().equals(AllChars.ILL)){
					HealthHazard hazard = fetchCharacterHealthHazard(baby);
					illnessCount ++;
					notification += baby.getDisplayName() + " is unfortunately suffering from " + hazard.getName() + "\n";
				}
			}
			if(hazardCount==0&&illnessCount==0){
				notification += "There are no illnesses in your household at this time.\n";
			} 
			totalIllnesses += illnessCount;
			if(illnessCount>0){
				gmHearthNote += hearth.getName() + " has " + illnessCount + " members in hospital.\n";
			} else {
				gmHearthNote += hearth.getName() + " has no illnesses this year.\n";
			}
			gmNotification += gmHearthNote;
			snf.updateSeasonNotifications(notification, pcs);
		}
		snf.updateBankerNotifications("Health Hazards:\nThere were " + totalDeaths + " deaths and " + totalIllnesses + " illnesses in the village.\n" + gmNotification, game);
	}
	private HealthHazard fetchCharacterHealthHazard(AllChars character) throws Exception {
		HealthHazardFactory hhf = new HealthHazardFactory();
		CharHealthHazard charHazard = hhf.fetchHealthHazardByCharacter(character);
		HealthHazard hazard = hhf.fetchHealthHazardById(charHazard.getHazard().getId());
		return hazard;
	}
	
}
