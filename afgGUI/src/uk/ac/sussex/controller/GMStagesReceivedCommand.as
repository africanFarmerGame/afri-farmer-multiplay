/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.FormProxy;
	import uk.ac.sussex.serverhandlers.SeasonsHandlers;
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class GMStagesReceivedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("GMStagesReceivedCommand sez: I have been called into action.");
			var data:IncomingData = note.getBody() as IncomingData;
			if(data==null){
				throw new Error("Problem with the incoming data.");
			}
			var currentSeason:String = data.getParamValue(HomeHandlers.GM_CURRENT_SEASON) as String;
			var currentStage:String = data.getParamValue(HomeHandlers.GM_CURRENT_STAGE) as String;
			var nextSeason:String = data.getParamValue(HomeHandlers.GM_NEXT_SEASON) as String;
			var nextStage:String = data.getParamValue(HomeHandlers.GM_NEXT_STAGE) as String;
			
			trace("GMStagesReceivedCommand sez: Current - " + currentSeason + " " + currentStage);
			trace("GMStagesReceivedCommand sez: Next - " + nextSeason + " " + nextStage);
			
			var formProxy:FormProxy = facade.retrieveProxy(SeasonsHandlers.CHANGE_STAGE_FORM) as FormProxy;
			if(currentSeason!=null){
				formProxy.updateFieldValue(SeasonsHandlers.CHANGE_STAGE_CURRENT, currentSeason + " - " + currentStage);
			} else {
				formProxy.updateFieldValue(SeasonsHandlers.CHANGE_STAGE_CURRENT, "No current stage data.");
			}
			if(nextSeason!=null){
				formProxy.updateFieldValue(SeasonsHandlers.CHANGE_STAGE_NEXT, nextSeason + " - " + nextStage);
			} else {
				formProxy.updateFieldValue(SeasonsHandlers.CHANGE_STAGE_NEXT, "No next stage data.");
			}
		}
	}
}
