/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

/**
 * 
 */
package uk.ac.sussex.model;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.utilities.*;

/**
 * @author em97
 *
 */
public class Hearth extends Location {
	private Game game;
	private Integer housenumber;
	private Set<PlayerChar> characters = new HashSet<PlayerChar>();
	private Double cash;
	
	public Hearth(){
		super();
		this.addOptionalParam("Id");
		this.addOptionalParam("Cash");
	}
	@Override
	public String getType(){
		return "HEARTH";
	}

	/**
	 * @param game the game to set
	 */
	public void setGame(Game game) {
		this.game = game;
	}

	/**
	 * @return the game
	 */
	public Game getGame() {
		return game;
	}

	/**
	 * @param housenumber the housenumber to set
	 */
	public void setHousenumber(Integer housenumber) {
		this.housenumber = housenumber;
	}

	/**
	 * @return the housenumber
	 */
	public Integer getHousenumber() {
		return housenumber;
	}

	/**
	 * @param characters the characters to set
	 */
	public void setCharacters(Set<PlayerChar> characters) {
		this.characters = characters;
	}

	/**
	 * @return the characters
	 */
	public Set<PlayerChar> getCharacters() {
		return characters;
	}
	/**
	 * @param cash the cash to set
	 */
	public void setCash(Double cash) {
		this.cash = cash;
	}

	/**
	 * @return the cash
	 */
	public Double getCash() {
		return cash;
	}

	public Float getSocialStatus() {
		Integer tally = 0;
		Integer numPC = 0;
		for (PlayerChar player : characters) {
			tally += player.getSocialStatus();
			numPC ++;
		}
		Float socialStatus = (float)tally/(float)numPC;
		return socialStatus;
	}
	public Integer fetchFieldCount() {
		Integer fieldCount = 0;
		//Add all the player fields
		for (PlayerChar player : characters) {
			fieldCount += player.getFieldCount();
		}
		//Then add any for the hearth 
		try {
			fieldCount += this.fetchFields().size();
		} catch (Exception e) {
			Logger.ErrorLog("Hearth.fetchFieldCount", "Problem counting errors for hearth " + this.getId() + ": " + e.getMessage());
		}
		
		return fieldCount;
	}
	public Integer fetchNumberOfAdults() {
		Integer numAdults = characters.size();
		//Adults will be attached to the hearth, so I can just look at those.
		try {
			Set<NPC> npcs = this.fetchNPCs();
			for (NPC npc : npcs) {
				if(npc.isAdult()){
					numAdults ++;
				}
			}
			return numAdults;
		} catch (Exception e) {
			Logger.ErrorLog("Hearth.getNumberOfAdults", e.getMessage());
			return numAdults;
		}
	}
	public Integer fetchNumberOfChildren() {
		//This needs hearth children (between 8 and 14 inc) and babies. 
		Integer childCount = 0;
		//This counts the babies with the children. 
		for(PlayerChar character : characters){
			if(character.getRole().getId().equals("WOMAN") ){
				//Check for babies.
				childCount += character.getBabyCount();
			}
		}
		//Also need to work through the hearth kids. 
		try {
			Set<NPC> npcs = this.fetchNPCs();
			for (NPC npc : npcs) {
				if(!npc.isAdult()){
					childCount ++;
				} else {
					if(npc.getRole().getId().equals(Role.WOMAN)){
						childCount += npc.getBabyCount();
					}
				}
			}
		} catch (Exception e) {
			Logger.ErrorLog("Hearth.getNumberOfAdults", e.getMessage());		
		}
		return childCount;
	}
	public List<Field> fetchFields() throws Exception {
		List<Field> fields = new ArrayList<Field>();
		try{
			
			FieldFactory ff = new FieldFactory();
			fields = ff.getHearthFields(this);
			for(PlayerChar character: characters){
				fields.addAll(ff.getPCFields(character));
			}
			
		} catch (Exception e){
			String message = "Error in Hearth.fetchFields: " + e.getMessage();
			throw new Exception(message);
		}
		return fields;
	}
	private Set<NPC> fetchNPCs() throws Exception {
		NPCFactory npcf = new NPCFactory();
		return npcf.fetchHearthChildren(this);
	}
	public Boolean needsBabysitter() throws Exception {
		Boolean hasBabies = false;
		PlayerCharFactory pcf = new PlayerCharFactory();
		NPCFactory npcf = new NPCFactory();
		Set<PlayerChar> pcs= pcf.fetchHearthPCs(this);
		Iterator<PlayerChar> pcIterator = pcs.iterator();
		while(pcIterator.hasNext() && !hasBabies){
			PlayerChar pc = pcIterator.next();
			pc = pcf.fetchPlayerChar(pc.getId());
			Set<NPC> babies = npcf.fetchPCBabies(pc);
			Iterator<NPC> babyIterator = babies.iterator();
			while(babyIterator.hasNext() && !hasBabies){
				NPC baby = babyIterator.next();
				hasBabies = (!baby.getAlive().equals(AllChars.DEAD));
			}
		}
		if(!hasBabies){
			//Best to check the npcs. 
			
			Set<NPC> npcs = npcf.fetchHearthWomen(this);
			Iterator<NPC> npcIterator = npcs.iterator();
			while(npcIterator.hasNext() && !hasBabies){
				NPC npc = npcIterator.next();
				npc = npcf.fetchNPC(npc.getId());
				Set<NPC> babies = npcf.fetchNPCBabies(npc);
				Iterator<NPC> babyIterator = babies.iterator();
				while(babyIterator.hasNext() && !hasBabies){
					NPC baby = babyIterator.next();
					hasBabies = (!baby.getAlive().equals(AllChars.DEAD));
				}
			}
		}
		return hasBabies;
	}
}
