package uk.ac.sussex.gameEvents;

import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
/**
 * This event works best as a pre-stage event for the start of a new year. 
 * @author em97
 *
 */
public class CoreGenerateFieldHistoryEvent extends GameEvent {
	public CoreGenerateFieldHistoryEvent(Game game) {
		super(game);
	}
	
	@Override
	public void fireEvent() throws Exception {
		FieldFactory ff = new FieldFactory();
		HearthFactory hf = new HearthFactory();
		PlayerCharFactory pcf = new PlayerCharFactory();
		
		Set<Hearth> hearths = hf.fetchGameHearths(game);
		for (Hearth hearth : hearths){
			List<Field> fields = ff.getHearthFields(hearth);
			for(Field field: fields){
				ff.createHearthFieldHistory(field, hearth);
			}
		}
		
		Set<PlayerChar> pcs = pcf.fetchGamePCs(game);
		for(PlayerChar pc: pcs){
			List<Field> fields = ff.getPCFields(pc);
			for(Field field: fields){
				ff.createPCFieldHistory(field, pc);
			}
		}
		//TODO do this for the game manager fields as well. 
	}

	@Override
	public void generateNotifications() throws Exception {
		// TODO Auto-generated method stub

	}

}
