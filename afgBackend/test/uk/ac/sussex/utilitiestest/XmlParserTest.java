/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
