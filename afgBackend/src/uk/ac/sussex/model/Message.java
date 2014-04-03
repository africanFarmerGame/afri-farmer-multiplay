package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseObject;

public class Message extends BaseObject {
	private Integer id;
	private PlayerChar recipient;
	private String subject;
	private String body; 
	private Long timestamp;
	private Integer unread = 1;
	private Integer deleted = 0;
	
	public Message() {
		super();
		this.setTimestamp(System.currentTimeMillis() / 1000);
		this.addOptionalParam("Id");
	}

	/**
	 * @return the id
	 */
	public Integer getId() {
		return id;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(Integer id) {
		this.id = id;
	}

	/**
	 * @return the recipient
	 */
	public PlayerChar getRecipient() {
		return recipient;
	}

	/**
	 * @param recipient the recipient to set
	 */
	public void setRecipient(PlayerChar recipient) {
		this.recipient = recipient;
	}

	/**
	 * @return the subject
	 */
	public String getSubject() {
		return subject;
	}

	/**
	 * @param subject the subject to set
	 */
	public void setSubject(String subject) {
		this.subject = subject;
	}

	/**
	 * @return the body
	 */
	public String getBody() {
		return body;
	}

	/**
	 * @param body the body to set
	 */
	public void setBody(String body) {
		this.body = body;
	}

	/**
	 * @return the timestamp
	 */
	public Long getTimestamp() {
		return timestamp;
	}

	/**
	 * @param timestamp the timestamp to set
	 */
	public void setTimestamp(Long timestamp) {
		this.timestamp = timestamp;
	}

	/**
	 * @return the unread
	 */
	public Integer getUnread() {
		return unread;
	}

	/**
	 * @param unread the unread to set
	 */
	public void setUnread(Integer unread) {
		this.unread = unread;
	}

	/**
	 * @return the deleted
	 */
	public Integer getDeleted() {
		return deleted;
	}

	/**
	 * @param deleted the deleted to set
	 */
	public void setDeleted(Integer deleted) {
		this.deleted = deleted;
	}
	
}
