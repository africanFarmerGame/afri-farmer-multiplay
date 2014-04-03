package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseObject;

public class CallHistory extends BaseObject {
	private Integer id;
	private PlayerChar callFrom;
	private PlayerChar callTo;
	private Long started;
	private Long answered;
	private Long finished;
		
	public CallHistory(){
		super();
		this.addOptionalParam("Id");
		this.addOptionalParam("Answered");
		this.addOptionalParam("Finished");
		this.setStarted(System.currentTimeMillis() / 1000);
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
	 * @return the callFrom
	 */
	public PlayerChar getCallFrom() {
		return callFrom;
	}

	/**
	 * @param callFrom the callFrom to set
	 */
	public void setCallFrom(PlayerChar callFrom) {
		this.callFrom = callFrom;
	}

	/**
	 * @return the callTo
	 */
	public PlayerChar getCallTo() {
		return callTo;
	}

	/**
	 * @param callTo the callTo to set
	 */
	public void setCallTo(PlayerChar callTo) {
		this.callTo = callTo;
	}

	/**
	 * @return the started
	 */
	public Long getStarted() {
		return started;
	}

	/**
	 * @param started the started to set
	 */
	public void setStarted(Long started) {
		this.started = started;
	}

	/**
	 * @return the answered
	 */
	public Long getAnswered() {
		return answered;
	}

	/**
	 * @param answered the answered to set
	 */
	public void setAnswered(Long answered) {
		this.answered = answered;
	}

	/**
	 * @return the finished
	 */
	public Long getFinished() {
		return finished;
	}

	/**
	 * @param finished the finished to set
	 */
	public void setFinished(Long finished) {
		this.finished = finished;
	}
}
