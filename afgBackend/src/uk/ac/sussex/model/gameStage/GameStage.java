/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
