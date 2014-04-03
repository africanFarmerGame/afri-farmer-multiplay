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
