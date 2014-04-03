package uk.ac.sussex.utilitiestest;

import static org.junit.Assert.*;

import org.junit.Test;

import uk.ac.sussex.utilities.XmlParser;

public class XmlParserTest {

	@Test
	public void testReadXMLFile() {
		XmlParser xmlParser = new XmlParser();
		try{
			xmlParser.readXMLFile("text_xml/Bank.xml");
		} catch (Exception e){
			fail(e.getMessage());
		}
	}

	@Test
	public void testFetchTagValue() {
		XmlParser xmlParser = new XmlParser();
		try{
			xmlParser.readXMLFile("text_xml/Bank.xml");
		} catch (Exception e){
			fail(e.getMessage());
		}
		try {
			String viewTitle = xmlParser.fetchTagValue("title", "view");
			assertEquals("Bank", viewTitle);
			
		} catch (Exception e) {
			e.printStackTrace();
			fail ("Error fetching value: " + e.getMessage());
		}
		
	}

}
