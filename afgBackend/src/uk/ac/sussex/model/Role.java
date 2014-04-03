/**
 * 
 */
package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseObject;

/**
 * @author em97
 *
 */
public class Role extends BaseObject {
	private String id;
	private String name;
	
	public static final String MAN = "MAN";
	public static final String WOMAN = "WOMAN";
	public static final String BANKER = "BANKER";
	
	public Role() {
		super();
	}

	/**
	 * @param id the id to set
	 */
	public void setId(String id) {
		this.id = id;
	}

	/**
	 * @return the id
	 */
	public String getId() {
		return id;
	}

	/**
	 * @param name the name to set
	 */
	public void setName(String name) {
		this.name = name;
	}

	/**
	 * @return the name
	 */
	public String getName() {
		return name;
	}
	
	

}
