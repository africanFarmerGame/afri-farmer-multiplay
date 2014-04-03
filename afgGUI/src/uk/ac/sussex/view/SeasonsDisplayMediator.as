﻿/**This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	**/package uk.ac.sussex.view {	import uk.ac.sussex.model.valueObjects.SeasonStage;	import uk.ac.sussex.model.valueObjects.Season;	import uk.ac.sussex.model.SeasonsListProxy;	import uk.ac.sussex.general.ApplicationFacade;	import uk.ac.sussex.view.components.SeasonsDisplay;	import org.puremvc.as3.multicore.interfaces.*;	import org.puremvc.as3.multicore.patterns.mediator.Mediator;	/**	 * @author em97	 */	public class SeasonsDisplayMediator extends Mediator implements IMediator {		public static const NAME:String = "SeasonsDisplayMediator";		private var seasonsListProxy:SeasonsListProxy;		public function SeasonsDisplayMediator(viewComponent : Object = null) {			super(NAME, viewComponent);		}		override public function listNotificationInterests():Array {			return [SeasonsListProxy.SEASONS_ADDED,					SeasonsListProxy.CURRENT_SEASON_UPDATED, 					SeasonsListProxy.STAGES_ADDED, 					SeasonsListProxy.CURRENT_STAGE_UPDATED];		}		override public function handleNotification (note:INotification):void {			switch (note.getName()){				case SeasonsListProxy.SEASONS_ADDED:				trace("SeasonsDisplayMediator sez: Seasons being added.");					var seasonList:Array = note.getBody() as Array;					if(seasonList != null){						seasonsDisplay.addSeasonLabels(seasonList);					} else {						trace("SeasonsDisplayMediator sez: Danger Will Robinson! The seasons list was empty.");					}					break;				case SeasonsListProxy.STAGES_ADDED:				trace("SeasonsDisplayMediator sez: Stages being added.");					var stagesList:Array = note.getBody() as Array;					if(stagesList != null){											}					break;				case SeasonsListProxy.CURRENT_STAGE_UPDATED:					var currentSeason:Season = seasonsListProxy.getCurrentSeason();					if(currentSeason!=null){						var displayPos:uint = currentSeason.getDisplayOrder();						if(displayPos > 0){							seasonsDisplay.highlightSeason(displayPos);							/**var stages:Array = currentSeason.getStages();							trace("SeasonsDisplayMediator sez: Current stages are " + stages.length);							seasonsDisplay.addStageLabels(currentSeason.getStages());*/							var currentStage:SeasonStage = note.getBody() as SeasonStage;							if(currentStage!= null){								seasonsDisplay.displayStage(currentStage.getName(), displayPos);							}								}					}					break;			}		}		public function setPosition(x:Number, y:Number):void{			seasonsDisplay.x = x;			seasonsDisplay.y = y; 		}		public function setWeather(weather:String, weatherSeason:int):void{			if(weather!=null&&weatherSeason>0){				seasonsDisplay.showWeather(weather, weatherSeason);			} else {				seasonsDisplay.hideWeather();			}		}		public function hideWeather():void {			seasonsDisplay.hideWeather();		}		protected function get seasonsDisplay():SeasonsDisplay {			return viewComponent as SeasonsDisplay;		}		override public function onRegister():void {			var appMediator:ApplicationMediator = facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;						viewComponent = new SeasonsDisplay(appMediator.getLeftWidth(), appMediator.getTopHeight());						seasonsListProxy = facade.retrieveProxy(SeasonsListProxy.NAME) as SeasonsListProxy;			if(seasonsListProxy != null){				seasonsDisplay.addSeasonLabels(seasonsListProxy.getSeasons());			}						sendNotification(ApplicationFacade.ADD_TO_SCREEN, seasonsDisplay);		}		override public function onRemove():void {			seasonsDisplay.destroy();			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, seasonsDisplay);		}	}}