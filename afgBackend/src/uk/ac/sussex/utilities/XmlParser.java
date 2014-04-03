package uk.ac.sussex.utilities;

import java.io.File;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;


/**
 * 
 * @author em97
 *
 */
public class XmlParser {
	private static final String FILE_LOCATION = "extensions/gameBackend2/text_xml/"; 
	private static final String FILE_EXTENSION = ".xml";
	private Document xmlDoc;
	/**
	 * This should parse the document required and store it. 
	 * Call this before trying to access the document elements. 
	 * 
	 * @param filename
	 * @throws Exception
	 */
	public void readXMLFile(String filename) throws Exception{
		File fXMLFile = new File(filename);
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		DocumentBuilder db = dbf.newDocumentBuilder();
		this.xmlDoc = db.parse(FILE_LOCATION + fXMLFile + FILE_EXTENSION);
	}
	public String fetchTagValue(String tagName, String elementName) throws Exception{
		NodeList nList = this.xmlDoc.getElementsByTagName(elementName);
		if(nList.getLength() != 1){
			throw new Exception("Too many elements of type " + elementName);
		}
		Node node = nList.item(0);
		if(node.getNodeType() == Node.ELEMENT_NODE){
			//Cast the element node to the right type. 
			Element element = (Element) node;
			NodeList nodeTags = element.getElementsByTagName(tagName).item(0).getChildNodes();
			Node nvalue = (Node)nodeTags.item(0);
			return nvalue.getNodeValue();
		} else {
			throw new Exception("Node with name " + elementName + " not of type element.");
		}
	}
}
