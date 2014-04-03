/**
 * 
 */
package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseFactory;

/**
 * @author em97
 *
 */
public class RoleFactory extends BaseFactory {

	/**
	 * @param factoryObject
	 */
	public RoleFactory() {
		super(new Role());
	}
	public Role fetchRole(String roleName) throws Exception{
		Role role = null;
		try {
			role = (Role) this.fetchSingleObject(roleName);
		} catch (Exception e) {
			String eMessage = e.getMessage();
			if(eMessage.contains("identifier")){
				throw new Exception ("No role found with that name.");
			} else {
				throw new Exception (eMessage);
			}
		}
		return role;
	}
	public Role fetchRandomRole() throws Exception {
		Role role;
		if(Math.random() > 0.5){
			role = (Role) this.fetchSingleObject("WOMAN");
		} else {
			role = (Role) this.fetchSingleObject("MAN");
		}
		return role;
	}
}
