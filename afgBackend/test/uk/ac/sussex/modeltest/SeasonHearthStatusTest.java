/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import org.junit.Test;

import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.HearthFactory;
import uk.ac.sussex.model.SeasonDetail;
import uk.ac.sussex.model.SeasonDetailFactory;
import uk.ac.sussex.model.SeasonHearthStatus;

public class SeasonHearthStatusTest {

	@Test
	public void testSave() {
		SeasonHearthStatus shs = new SeasonHearthStatus();
		try {
			shs.save();
			fail("Unexpected success");
		} catch (Exception e) {
			e.printStackTrace();
			String message = e.getMessage();
			assertTrue(message.contains("SeasonHearthStatus|Season|Null||"));
			assertTrue(message.contains("SeasonHearthStatus|Hearth|Null||"));
			assertTrue(message.contains("SeasonHearthStatus|NumPCs|Null||"));
			assertTrue(message.contains("SeasonHearthStatus|DeadFamily|Null||"));
			assertTrue(message.contains("SeasonHearthStatus|NumFields|Null||"));
			assertTrue(message.contains("SeasonHearthStatus|TotalAdults|Null||"));
			assertTrue(message.contains("SeasonHearthStatus|LivingFamily|Null||"));
			assertTrue(message.contains("SeasonHearthStatus|TotalFamily|Null||"));	
		}
		
		shs.setHearth(fetchHearth(78));
		shs.setSeason(fetchSeasonDetail(5));
		shs.setDeadFamily(2);
		shs.setLivingFamily(4);
		shs.setTotalFamily(6);
		shs.setNumFields(3);
		shs.setNumPCs(2);
		shs.setTotalAdults(2);
		try {
			shs.save();
		} catch (Exception e){
			e.printStackTrace();
			fail("Problem saving.");
		}
		assertNotNull(shs.getId());
	}
	private SeasonDetail fetchSeasonDetail(Integer id) {
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		SeasonDetail sd = null;
		try {
			sd = sdf.fetchSeasonDetail(id);
		} catch (Exception e){
			e.printStackTrace();
			fail("Problem fetching seasondetail " + id);
		}
		return sd;
	}
	private Hearth fetchHearth(Integer hearthId){
		HearthFactory hf = new HearthFactory();
		Hearth hearth = null;
		try {
			hearth = hf.fetchHearth(hearthId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unexpected problem fetching hearth " + hearthId);
		}
		return hearth;
	}
}
