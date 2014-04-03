package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseObject;

public class SeasonNotification extends BaseObject {
	private Integer id;
	private PlayerChar character;
	private SeasonDetail previousSeason;
	private SeasonDetail nextSeason;
	private String previousStage;
	private String nextStage;
	private String notification;
	
	public SeasonNotification() {
		super();
		this.addOptionalParam("Id"); // Optional because generated on save.
		this.addOptionalParam("NextSeason");
		this.addOptionalParam("NextStage");
		this.addOptionalParam("PreviousSeason"); //Because for the first season of the game this will be null.
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getId() {
		return id;
	}

	public void setCharacter(PlayerChar character) {
		this.character = character;
	}

	public PlayerChar getCharacter() {
		return character;
	}

	public void setNotification(String notification) {
		this.notification = notification;
	}

	public String getNotification() {
		return notification;
	}

	public void setPreviousSeason(SeasonDetail previousSeason) {
		this.previousSeason = previousSeason;
	}

	public SeasonDetail getPreviousSeason() {
		return previousSeason;
	}

	public void setNextSeason(SeasonDetail nextSeason) {
		this.nextSeason = nextSeason;
	}

	public SeasonDetail getNextSeason() {
		return nextSeason;
	}

	public void setPreviousStage(String previousStage) {
		this.previousStage = previousStage;
	}

	public String getPreviousStage() {
		return previousStage;
	}

	public void setNextStage(String nextStage) {
		this.nextStage = nextStage;
	}

	public String getNextStage() {
		return nextStage;
	}
	
}
