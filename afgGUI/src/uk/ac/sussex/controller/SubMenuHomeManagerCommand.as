﻿/**This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	**/package uk.ac.sussex.controller {	import uk.ac.sussex.view.FoodGMOverviewListMediator;	import uk.ac.sussex.view.TasksGMOverviewListMediator;	import uk.ac.sussex.model.valueObjects.SeasonStage;	import uk.ac.sussex.model.SeasonsListProxy;	import uk.ac.sussex.view.GameStatusListMediator;	import uk.ac.sussex.serverhandlers.SeasonsHandlers;	import uk.ac.sussex.view.FormMediator;	import uk.ac.sussex.general.ApplicationFacade;	import uk.ac.sussex.serverhandlers.HomeHandlers;	import org.puremvc.as3.multicore.interfaces.INotification;	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;		public class SubMenuHomeManagerCommand extends SimpleCommand {		private static const TASK_TIME:int = 1;		private static const FOOD_TIME:int = 2; 		private var currentStage:int = 0;				override public function execute( note:INotification ):void {						var subMenuItem:String = note.getBody() as String;			var tickerMediator:FormMediator = facade.retrieveMediator(HomeHandlers.SEND_TICKER_FORM) as FormMediator;			var changeStageForm:FormMediator = facade.retrieveMediator(SeasonsHandlers.CHANGE_STAGE_FORM) as FormMediator;			var statusDisplay:GameStatusListMediator = facade.retrieveMediator(GameStatusListMediator.NAME) as GameStatusListMediator;			var endGameForm:FormMediator = facade.retrieveMediator(HomeHandlers.GM_END_GAME_FORM) as FormMediator;			var taskOverview:TasksGMOverviewListMediator = facade.retrieveMediator(TasksGMOverviewListMediator.NAME) as TasksGMOverviewListMediator;			var foodOverview:FoodGMOverviewListMediator = facade.retrieveMediator(FoodGMOverviewListMediator.NAME) as FoodGMOverviewListMediator;			var displayText:String;						tickerMediator.hideForm();			changeStageForm.hideForm();			statusDisplay.showList(false);			endGameForm.hideForm();			if(taskOverview!=null){				taskOverview.showList(false);			}			if(foodOverview!=null){				foodOverview.showList(false);			}			switch(subMenuItem){				case HomeHandlers.GM_SUB_MENU_TICKER:					displayText = "Ticker \n\n Updates the scrolling text on the bottom of the screen for all players in the game.";					tickerMediator.addToViewArea();					break;				case HomeHandlers.GM_SUB_MENU_CHANGESTAGE:					displayText = "Change Stage \n\nMoves the game to the next stage of play";					changeStageForm.addToViewArea();					break;				case HomeHandlers.GM_SUB_MENU_GAMEOVERVIEW:					displayText = "Game Overview: \n\nShows an overview of the households and their current states.";					statusDisplay.showList(true);					break;				case HomeHandlers.GM_SUB_MENU_ENDGAME:					displayText = "End Game:\n\nCalculates the final positions of the players and households.";					trace("SubMenuHomeManagerCommand sez: Should be about to add the game form.");					endGameForm.addToViewArea();					break;				case HomeHandlers.GM_SUB_MENU_STAGEPROGRESS:					checkStage();					displayText = "Stage Progress:\n\n";					if(currentStage==TASK_TIME){						displayText += "In Task Allocation the table shows the number of tasks set up by each household during the stage.";						displayTasks(taskOverview);					} else if (currentStage == FOOD_TIME){						displayText += "In Food thingy the table shows some other stuff.";						displayFoodOverview(foodOverview);					}								}			sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, displayText);		}				private function checkStage():void {			currentStage = 0;			var seasonsListProxy:SeasonsListProxy = facade.retrieveProxy(SeasonsListProxy.NAME) as SeasonsListProxy;			if(seasonsListProxy!=null){				var thisStage:SeasonStage = seasonsListProxy.getCurrentStage();				if(thisStage != null){					var currentStageName:String = thisStage.getName().toUpperCase();					if(currentStageName.search("TASK")==0){						currentStage = TASK_TIME;					} else if (currentStageName.search("FOOD")==0){						currentStage = FOOD_TIME;					}				}			}		}		private function displayTasks(taskOverview:TasksGMOverviewListMediator):void{			if(taskOverview == null){				//Try again. 				taskOverview = facade.retrieveMediator(TasksGMOverviewListMediator.NAME) as TasksGMOverviewListMediator;				if(taskOverview==null){					throw new Error("I've tried twice, but the task mediator just isn't there.");				}			}			taskOverview.showList(true);		}		private function displayFoodOverview(foodOverview:FoodGMOverviewListMediator):void {			if(foodOverview == null){				foodOverview = facade.retrieveMediator(FoodGMOverviewListMediator.NAME) as FoodGMOverviewListMediator;				if(foodOverview == null){					throw new Error("I've tried twice, but the food mediator isn't there.");				}			}			foodOverview.showList(true);		}	}	}