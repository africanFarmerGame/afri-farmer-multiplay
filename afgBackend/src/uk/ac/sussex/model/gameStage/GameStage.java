package uk.ac.sussex.model.gameStage;

import java.util.ArrayList;
import java.util.List;
import uk.ac.sussex.gameEvents.GameEvent;

public abstract class GameStage {
	protected String name;
	private List<GameEvent> preStageEvents = new ArrayList<GameEvent>();
	private List<GameEvent> postStageEvents = new ArrayList<GameEvent>();
	
	public String getName(){
		return this.name;
	}
	
	public void addPreStageEvent(GameEvent event){
		preStageEvents.add(event);
	}
	public void addPostStageEvent(GameEvent event){
		postStageEvents.add(event);
	}
	public void firePreStageEvents() throws Exception {
		for(GameEvent event: preStageEvents){
			event.fireEvent();
		}
	}
	public void generatePreStageNotifications() throws Exception {
		for (GameEvent event: preStageEvents){
			event.generateNotifications();
		}
	}
	public void generatePostStageNotifications() throws Exception {
		for (GameEvent event: postStageEvents){
			event.generateNotifications();
		}
	}
	public void firePostStageEvents() throws Exception {
		for(GameEvent event: postStageEvents){
			event.fireEvent();
		}
	}
}
