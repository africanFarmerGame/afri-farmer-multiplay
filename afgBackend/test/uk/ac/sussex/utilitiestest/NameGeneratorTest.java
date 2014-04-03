/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.utilitiestest;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

import uk.ac.sussex.model.Role;
import uk.ac.sussex.model.RoleFactory;
import uk.ac.sussex.utilities.NameGenerator;

public class NameGeneratorTest {

	@Test
	public void testGenerateName() {
		RoleFactory rf = new RoleFactory();
		Role role = null;
		try {
			role = rf.fetchRole(Role.WOMAN);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get a role");
		}
		
		List<String> excludeNames = new ArrayList<String>();
		excludeNames.add("Mary");
		excludeNames.add("Faith");
		excludeNames.add("Eunice");
		excludeNames.add("Pamela");
		excludeNames.add("Doris");
		excludeNames.add("Margaret");
		excludeNames.add("Florence");
		excludeNames.add("Naomi");
		excludeNames.add("Jackline");
		excludeNames.add("Esther");
		excludeNames.add("Sally");
		excludeNames.add("Selina");
		excludeNames.add("Mercy");
		excludeNames.add("Caroline");
		excludeNames.add("Sharon");
		excludeNames.add("Rose");
		excludeNames.add("Sylvia");
		excludeNames.add("Viola");
		excludeNames.add("Irene");
		excludeNames.add("Hellen");
		String name = NameGenerator.generateName(role, excludeNames);
		
		assertNotNull(name);
		assertTrue(name.equals("Jeruto"));
	}

}
