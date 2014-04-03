/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
