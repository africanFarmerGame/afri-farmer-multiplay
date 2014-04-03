package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import java.util.List;
import java.util.Set;

import org.junit.Test;

import uk.ac.sussex.model.Asset;
import uk.ac.sussex.model.Field;
import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.HearthFactory;
import uk.ac.sussex.model.PlayerChar;

public class HearthTest {

	/**
	 * Test method for {@link uk.ac.sussex.model.Hearth#getCharacters}.
	 */
	@Test
	public void testGetCharacters() {
		HearthFactory hf = new HearthFactory();
		try {
			Hearth hearth = hf.fetchHearth(2);
			Set<PlayerChar> chars = hearth.getCharacters();
			assertNotNull(chars);
			assertTrue(chars.size()>0);
		}
		catch (Exception e) {
			e.printStackTrace();
			fail("Unexpected error " + e.getMessage());
		}
	}
	
	@Test
	public void testFetchFields() {
		HearthFactory hf = new HearthFactory();
		Hearth hearth = null;
		try {
			hearth = hf.fetchHearth(15);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem fetching hearth");
		}
		try {
			List<Field> fields = hearth.fetchFields();
			assertNotNull(fields);
			//assertEquals( 5, fields.size());
			for (Field field : fields){
				System.out.println("Id: " + field.getId());
				System.out.println(field.getName());
				System.out.println("Quality: " + field.getQuality());
			
				Asset crop = field.getCrop();
				if(crop==null){
					System.out.println("No crop");
				} else {
					System.out.println(crop.getId());
					System.out.println(field.getCropAge());
					System.out.println(field.getCropHealth());
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			fail ("Problem fetching fields");
		}
	}
	
}
