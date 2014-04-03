/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.gameEventsTest;

import static org.junit.Assert.*;

import org.junit.Test;

import uk.ac.sussex.gameEvents.CoreAnnounceCropHazardEvent;
import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;

public class CoreAnnounceCropHazardEventTest {
	
	@SuppressWarnings("unused")
	@Test
	public void testFireEvent(){
		Game game = fetchGame(1);
		Hearth hearth = createHearth(game);
		Asset maize = fetchAsset(2);
		Asset cotton = fetchAsset(4);
		Asset sorghum = fetchAsset(7);
		Asset horticulture = fetchAsset(11);
		Field field1 = createPlantedField(hearth, horticulture);
		Field field2 = createPlantedField(hearth, sorghum);
		Field field3 = createPlantedField(hearth, cotton);
		Field field4 = createPlantedField(hearth, maize);
		Field field5 = createEmptyField(hearth);
		
		CoreAnnounceCropHazardEvent event = new CoreAnnounceCropHazardEvent(game);
		try {
			event.fireEvent();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Error firing event");
		}
	}
	private Field createEmptyField(Hearth hearth) {
		Field field = new Field();
		field.setHearth(hearth);
		field.setName("testEmptyHazard");
		field.setQuality(3);
		
		try {
			field.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't save empty field");
		}
		return field;
	}
	private Game fetchGame(Integer gameName){
		GameFactory gf = new GameFactory();
		Game game = null;
		try {
			game = gf.fetchGame(gameName);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get the game");
		}
		return game;
	}
	private Hearth createHearth(Game game){
		Hearth hearth = new Hearth();
		hearth.setGame(game);
		hearth.setName("testCropHazards");
		hearth.setHousenumber(100);
		try {
			hearth.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't create the hearth");
		}
		return hearth;
	}
	private Field createPlantedField(Hearth hearth, Asset crop){
		Field field = new Field();
		field.setCrop(crop);
		field.setHearth(hearth);
		field.setName("test" + crop.getName() + "Hazard");
		field.setCropPlanting(Field.EARLY_PLANTING);
		field.setCropAge(2);
		field.setCropHealth(100);
		field.setQuality(3);
		
		try {
			field.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't save field");
		}
		return field;
	}
	private Asset fetchAsset(Integer assetId){
		AssetFactory af = new AssetFactory();
		Asset asset = null;
		try {
			asset = af.fetchAsset(assetId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get the asset");
		}
		return asset;
	}
}
