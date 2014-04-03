/**
 * 
 */
package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import org.junit.Test;

import uk.ac.sussex.model.*;

/**
 * @author em97
 *
 */
public class FieldFactoryTest {

	@Test
	public void testCreateHearthField() {
		HearthFactory hf = new HearthFactory();
		Hearth hearth = null;
		try {
			hearth = hf.fetchHearth(1); 
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting a hearth");
		}
		FieldFactory ff = new FieldFactory();
		try {
			Field field = ff.createField(hearth, "test");
			assertNotNull(field);
			assertEquals(hearth, field.getHearth());
			assertNull(field.getOwner());
		} catch (Exception e) {
			e.printStackTrace();
			fail("There was a problem creating the field.");
		}
	}
	
	@Test
	public void testGetFieldById() {
		FieldFactory ff = new FieldFactory();
		try{
			Field field = ff.getFieldById(3);
			assertEquals("TestField1", field.getName());
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting field: " + e.getMessage());
		}
	}
	
	@Test
	public void testSetCropHealth() {
		Field field = new Field();
		field.setCropHealth(101);
		assertEquals((Integer) 100, field.getCropHealth());
		field.setCropHealth(-3);
		assertEquals((Integer) 0, field.getCropHealth());
		field.setCropHealth(50);
		assertEquals((Integer)50, field.getCropHealth());
		field.setCropHealth(null);
		assertNull(field.getCropHealth());
	}
	@Test
	public void testFetchFieldHistory(){
		Field field = fetchField(27);
		FieldFactory fieldFactory = new FieldFactory();
		FieldHistory history = null;
		try {
			history = fieldFactory.fetchSpecificFieldHistory(field, 0);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem with the field history");
		}
		assertNotNull(history);
	}
	private Field fetchField(Integer fieldId){
		FieldFactory fieldFactory = new FieldFactory();
		Field field = null;
		try {
			field = fieldFactory.getFieldById(fieldId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem fetching field " + fieldId);
		}
		return field;
	}
}
