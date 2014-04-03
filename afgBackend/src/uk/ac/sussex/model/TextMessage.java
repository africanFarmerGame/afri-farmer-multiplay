package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseObject;

public class TextMessage extends BaseObject {
	private Integer id;
	private PlayerChar sender;
	private PlayerChar receiver;
	private String message;
	private Long timestamp;
	private Integer unread;
	private Integer deleted;
	
	
	public TextMessage(){
		super();
		this.setTimestamp(System.currentTimeMillis() / 1000);
		this.addOptionalParam("Id");
	}
	/**
	 * @param id the id to set
	 */
	public void setId(Integer id) {
		this.id = id;
	}
	/**
	 * @return the id
	 */
	public Integer getId() {
		return id;
	}
	/**
	 * @param sender the sender to set
	 */
	public void setSender(PlayerChar sender) {
		this.sender = sender;
	}
	/**
	 * @return the sender
	 */
	public PlayerChar getSender() {
		return sender;
	}
	/**
	 * @param receiver the receiver to set
	 */
	public void setReceiver(PlayerChar receiver) {
		this.receiver = receiver;
	}
	/**
	 * @return the receiver
	 */
	public PlayerChar getReceiver() {
		return receiver;
	}
	/**
	 * @param message the message to set
	 */
	public void setMessage(String message) {
		this.message = message;
	}
	/**
	 * @return the message
	 */
	public String getMessage() {
		return message;
	}
	/**
	 * @param timestamp the timestamp to set
	 */
	public void setTimestamp(Long timestamp) {
		this.timestamp = timestamp;
	}
	/**
	 * @return the timestamp
	 */
	public Long getTimestamp() {
		return timestamp;
	}
	/**
	 * @param read the read to set
	 */
	public void setUnread(Integer unread) {
		this.unread = unread;
	}
	/**
	 * @return the read
	 */
	public Integer getUnread() {
		return unread;
	}
	/**
	 * @param deleted the deleted to set
	 */
	public void setDeleted(Integer deleted) {
		this.deleted = deleted;
	}
	/**
	 * @return the deleted
	 */
	public Integer getDeleted() {
		return deleted;
	}

}
