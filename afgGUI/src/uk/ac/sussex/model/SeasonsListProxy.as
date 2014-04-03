/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model {
	import uk.ac.sussex.model.valueObjects.SeasonStage;
	import uk.ac.sussex.model.valueObjects.Season;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	/**
	 * This will store a list of the seasons to display. It stores them by display order. 
	 * @author em97
	 */
	public class SeasonsListProxy extends Proxy implements IProxy {
		public static const NAME:String = "SeasonsListProxy";
		public static const SEASONS_ADDED:String = "seasonsAdded";
		public static const STAGES_ADDED:String = "StagesAdded";
		public static const CURRENT_SEASON_UPDATED:String = "currentSeasonUpdated";
		public static const CURRENT_STAGE_UPDATED:String = "currentStageUpdated";
		
		private var stagesList:Array;
		private var currentStage:SeasonStage;
		/**
		 * @param data - an array of seasons. 
		 */
		public function SeasonsListProxy() {
			super(NAME, new Array());
		}
		public function addSeason(season:Season):void{
			seasonsList[season.getDisplayOrder()] = season;
		}
		public function setSeasonStages(stages:Array):void {
			stagesList = new Array();
			for each (var stage:Season in stages){
				stagesList.push(stage);
			}
			sendNotification(STAGES_ADDED, stagesList);
		}
		public function addManySeasons(seasons:Array):void {
			for each (var season:Season in seasons){
				this.addSeason(season);	
			}
			sendNotification(SEASONS_ADDED, seasonsList);
		}
		public function getSeasons():Array {
			return seasonsList;
		}
		public function setCurrentSeason(displayNumber:uint):void{
			for each (var season:Season in seasonsList){
				season.setCurrent(displayNumber == season.getDisplayOrder());
			}
			sendNotification(CURRENT_SEASON_UPDATED, displayNumber);
		}
		public function getCurrentSeason():Season {
			for each (var season:Season in seasonsList){
				if(season.getCurrent()){
					return season;
				}
			}
		}
		public function setCurrentStage(currentStage:String):void {
			if(this.getCurrentSeason()!=null){
			
				var currentStages:Array = this.getCurrentSeason().getStages();
			
				for each (var stage:SeasonStage in currentStages){
					if(stage.getName() == currentStage){
						this.currentStage = stage;
						sendNotification(CURRENT_STAGE_UPDATED, stage);
						break;
					}
				}
			}
		}
		public function getCurrentStage():SeasonStage {
			return currentStage;
		}
		public function totalSeasons():uint {
			return seasonsList.length;
		}
		protected function get seasonsList():Array {
			return data as Array;
		}
		
	}
}
