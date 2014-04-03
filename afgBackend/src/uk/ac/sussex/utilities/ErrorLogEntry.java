/**
 * 
 */
package uk.ac.sussex.utilities;

import uk.ac.sussex.model.base.BaseObject;

/**
 * @author eam31
 *
 */
public class ErrorLogEntry extends BaseObject {
	private Integer id;
	private String message;
	private String function;
	private Long timestamp;
	
	public ErrorLogEntry() {
		super();
		this.setTimestamp(System.currentTimeMillis() / 1000);
		this.addOptionalParam("Id");
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getId() {
		return id;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getMessage() {
		return message;
	}
	public void setFunction(String function) {
		this.function = function;
	}
	public String getFunction() {
		return function;
	}
	public void setTimestamp(Long timestamp) {
		this.timestamp = timestamp;
	}
	public Long getTimestamp() {
		return timestamp;
	}
}
