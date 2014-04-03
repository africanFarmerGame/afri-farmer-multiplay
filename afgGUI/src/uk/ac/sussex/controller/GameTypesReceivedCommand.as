package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.Form;
	import uk.ac.sussex.model.valueObjects.FormFieldOption;
	import uk.ac.sussex.model.valueObjects.GameType;
	import uk.ac.sussex.states.GameSettingsGameState;
	import uk.ac.sussex.model.FormProxy;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class GameTypesReceivedCommand extends SimpleCommand {
		override public function execute(note:INotification):void{
			trace("GameTypesReceivedCommand sez: I has been fired doncha know.");
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var gameTypes:Array = incomingData.getParamValue("GameTypes") as Array;
			trace("GameTypesReceivedCommand sez: Now do I have some gametypes? " + (gameTypes!=null));
			
			var formProxy:FormProxy = facade.retrieveProxy(GameSettingsGameState.FORM_GAME_SETTINGS) as FormProxy;
			trace("GameTypesReceivedCommand sez: I should have a formProxy at this point. " + (formProxy!=null));
			var formOptions:Array = new Array();
			var setFieldValue:String = null;
			for each (var gameType:GameType in gameTypes){
				if(setFieldValue==null){
					setFieldValue = gameType.getGameType();
				}
				var formOption:FormFieldOption = new FormFieldOption(gameType.getGameTypeDisplay(), gameType.getGameType());
				formOptions.push(formOption);
			}
			var form:Form = formProxy.getForm();
			form.updatePossibleFieldValues(GameSettingsGameState.FIELD_GAME_TYPE, formOptions);
			form.setFieldValue(GameSettingsGameState.FIELD_GAME_TYPE, setFieldValue);
		}
	}
}
