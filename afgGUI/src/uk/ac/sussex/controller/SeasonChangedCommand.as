/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.serverhandlers.SeasonsHandlers;
	import uk.ac.sussex.model.valueObjects.*;
	import uk.ac.sussex.model.SeasonsListProxy;
	import uk.ac.sussex.general.ApplicationFacade;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SeasonChangedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("SeasonChangedCommand sez: I has been activated.");
			var incomingData:IncomingData = note.getBody() as IncomingData;
			trace("SeasonChangedCommand sez: my incoming data is " + incomingData.toString());
			var highlightSeason:int = incomingData.getParamValue(SeasonsHandlers.CURRENT_SEASON_DISPLAY) as int;
			var newStageName:String = incomingData.getParamValue(SeasonsHandlers.CURRENT_STAGE_NAME) as String;
			var seasonNotification:SeasonNotification = incomingData.getParamValue(SeasonsHandlers.SEASON_NOTIFICATION) as SeasonNotification;
			trace("SeasonChangedCommand sez: The SeasonNotification variable should be called " + SeasonsHandlers.SEASON_NOTIFICATION);
			trace("SeasonChangedCommand sez: Teh seasonNotification was null " + (seasonNotification==null));
			var seasonChanged:Boolean = false;
			var stageChanged:Boolean = false;
			
			
			var currentGameYear:int = incomingData.getParamValue(SeasonsHandlers.CURRENT_GAME_YEAR) as int;
			sendNotification(SeasonsHandlers.UPDATE_GAME_YEAR, currentGameYear);
			
			var seasonsListProxy:SeasonsListProxy = facade.retrieveProxy(SeasonsListProxy.NAME) as SeasonsListProxy;
			
			if(seasonsListProxy == null){
				trace("SeasonsCurrentCommand sez: We has a problem. The seasonsListProxy is null and it shouldn't be.");
			} else {
				trace("SeasonsCurrentCommand sez: We should be highlighting season " + highlightSeason + " and stage " + currentStageName);
				var currentStage:SeasonStage = seasonsListProxy.getCurrentStage();
				var currentStageName:String = "";
				var currentSeason:Season = seasonsListProxy.getCurrentSeason();
				var currentSeasonNumber:int = -1;
				
				if(currentStage!=null){
					currentStageName = currentStage.getName();
				}
				if(currentSeason!=null){
					currentSeasonNumber = seasonsListProxy.getCurrentSeason().getDisplayOrder();
				}
				
				seasonChanged = (currentSeasonNumber != highlightSeason);
				stageChanged = (currentStageName != newStageName); 
				
				seasonsListProxy.setCurrentSeason(highlightSeason);
				seasonsListProxy.setCurrentStage(newStageName);
			}
			
			sendNotification(ApplicationFacade.REFRESH_STATE);
			
			var message:String;
			if(seasonChanged){
				message = "Welcome to a brand new Season!\n\n";
			} else {
				message = "The game stage has changed. Good luck getting everything done in this stage!\n\n";
			}
			//message.concat(seasonNotification.getNotification());
			if(seasonNotification!=null){
				message += seasonNotification.getNotification();
			}
			sendNotification(ApplicationFacade.DISPLAY_MESSAGE, message);
		}
	}
}
