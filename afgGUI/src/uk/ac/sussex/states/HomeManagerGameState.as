/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.states {
	import uk.ac.sussex.model.GMHouseholdDataProxy;
	import uk.ac.sussex.model.SubMenuListProxy;
	import uk.ac.sussex.model.valueObjects.SeasonStage;
	import uk.ac.sussex.model.SeasonsListProxy;
	import uk.ac.sussex.model.HearthsViewStatusProxy;
	import uk.ac.sussex.model.IncomingDataErrorProxy;
	//import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.IncomingDataProxy;
	import uk.ac.sussex.model.RequestProxy;
	import flash.display.Sprite;
	import uk.ac.sussex.model.FormProxy;
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import uk.ac.sussex.view.*;
	import uk.ac.sussex.controller.*;
	import uk.ac.sussex.serverhandlers.*;
	import uk.ac.sussex.model.valueObjects.FormFieldOption;
	import uk.ac.sussex.model.valueObjects.requestParams.*;
	
	/**
	 * @author em97
	 */
	public class HomeManagerGameState extends ManagerRoomState implements IGameState {
		public static const NAME:String = "HomeManagerGameState";
		public static const LOCATION_NAME:String = "HOME";
		
		private static const TASK_TIME:int = 1;
		private static const FOOD_TIME:int = 2; 
		private var currentStage:int = 0;
		
		public function HomeManagerGameState(facade : IFacade) {
			super(facade, NAME);
		}
		override public function displayState():void{
			trace("You've reached the Home Manager Game State");
			super.displayState();

			ManagerHandlers.registerComponents(facade);
			
			checkStage();
			
			//add proxies
			this.registerProxies();
			//add commands
			this.registerCommands();
			//add mediators
			this.registerMediators();
		}
		override public function cleanUpState():void{
			
			//remove mediators
			this.removeMediators();
			//remove commands
			this.removeCommands();
			//remove proxies
			this.removeProxies();
			
			ManagerHandlers.removeComponents(facade);
			
			super.cleanUpState();
		}
		override public function refresh():void {
			super.refresh();
			var gmstageInfo:RequestProxy = facade.retrieveProxy(HomeHandlers.FETCH_STAGES + RequestProxy.NAME) as RequestProxy;
			if(gmstageInfo==null){
				throw new Error("gmstageInfo was null.");
			}
			gmstageInfo.sendRequest();
			checkStage();
			if(currentStage == TASK_TIME){
				facade.registerMediator(new TasksGMOverviewListMediator());
				var pendingTasksRequest:RequestProxy = facade.retrieveProxy(HomeHandlers.GM_FETCH_PENDING_TASKS + RequestProxy.NAME) as RequestProxy;
				if(pendingTasksRequest==null){
					throw new Error("pendingTasksRequest was null.");
				}
				pendingTasksRequest.sendRequest();
			} else if (currentStage == FOOD_TIME) {
				var foodOverview:FoodGMOverviewListMediator = facade.retrieveMediator(FoodGMOverviewListMediator.NAME) as FoodGMOverviewListMediator;
				if(foodOverview == null){
					facade.registerMediator(new FoodGMOverviewListMediator());
				}
				
			}
			
		}
		private function registerProxies():void {
			facade.registerProxy(new IncomingDataErrorProxy(HomeHandlers.HOME_ERROR));
			
			var tickerForm:FormProxy = new FormProxy(HomeHandlers.SEND_TICKER_FORM);
			facade.registerProxy(tickerForm);
			tickerForm.addTextField(HomeHandlers.TICKER_MESSAGE, "Message");
			var defaultExpiresOption:FormFieldOption = new FormFieldOption("Yes", "1");
			var expiresOptions:Array = new Array(defaultExpiresOption, new FormFieldOption("No", "0"));
			tickerForm.addRadioButton(HomeHandlers.TICKER_EXPIRES, "Expires", expiresOptions,defaultExpiresOption, false, HomeHandlers.TICKER_EXPIRES_CHANGED);
			tickerForm.addTextField(HomeHandlers.TICKER_DURATION, "Duration", true, "[0-9]+");
			var defaultTimeOption:FormFieldOption = new FormFieldOption("Minutes", "M");
			var timeOptions:Array = new Array (defaultTimeOption, 
											   new FormFieldOption("Hours", "H"),
											   new FormFieldOption("Days", "D"));
			tickerForm.addRadioButton(HomeHandlers.TICKER_DURATION_UNIT, "", timeOptions, defaultTimeOption);
			tickerForm.addButton("Submit", HomeHandlers.TICKER_SUBMIT);
			tickerForm.addButton("Cancel", HomeHandlers.TICKER_CANCEL);
			tickerForm.addButton("Clear Current", HomeHandlers.TICKER_CLEAR);
			
			var tickerRequest:RequestProxy = new RequestProxy(HomeHandlers.SUBMIT_TICKER_REQUEST);
			tickerRequest.addRequestParam(new DataParamString(HomeHandlers.TICKER_MESSAGE));
			tickerRequest.addRequestParam(new DataParamInt(HomeHandlers.TICKER_EXPIRES));
			tickerRequest.addRequestParam(new DataParamNumber(HomeHandlers.TICKER_DURATION));
			tickerRequest.addRequestParam(new DataParamString(HomeHandlers.TICKER_DURATION_UNIT));
			facade.registerProxy(tickerRequest);
			
			facade.registerProxy(new IncomingDataErrorProxy(HomeHandlers.SUBMIT_TICKER_REQUEST_ERROR));
			facade.registerProxy(new RequestProxy(SeasonsHandlers.SUBMIT_STAGE_CHANGE_REQUEST));			
			facade.registerProxy(new RequestProxy(CommsHandlers.TICKER_MESSAGE_CLEAR));
			
			var changeStageFormProxy:FormProxy = new FormProxy(SeasonsHandlers.CHANGE_STAGE_FORM);
			changeStageFormProxy.addDisplayText(SeasonsHandlers.CHANGE_STAGE_CURRENT, "Current Stage");
			changeStageFormProxy.addDisplayText(SeasonsHandlers.CHANGE_STAGE_NEXT, "Next Stage");
			changeStageFormProxy.addButton("Change", SeasonsHandlers.CHANGE_STAGE_SUBMIT);
			facade.registerProxy(changeStageFormProxy);
			
			facade.registerProxy(new IncomingDataErrorProxy(SeasonsHandlers.CHANGE_STAGE_ERROR));
			
			var gameStatuses:RequestProxy = new RequestProxy(RoomHandlers.GET_GAME_STATUSES);
			facade.registerProxy(gameStatuses);
			gameStatuses.sendRequest();
			
			facade.registerProxy(new IncomingDataErrorProxy(RoomHandlers.GET_GAME_STATUSES_ERROR));
			
			var gameStatusesReceived:IncomingDataProxy = new IncomingDataProxy(RoomHandlers.GAME_STATUSES_RECEIVED, RoomHandlers.GAME_STATUSES_RECEIVED);
			gameStatusesReceived.addDataParam(new DataParamArrayHouseholdStatus("AllViewDetails"));
			facade.registerProxy(gameStatusesReceived);
			
			facade.registerProxy(new HearthsViewStatusProxy());
			
			facade.registerProxy(new RequestProxy(HomeHandlers.SUBMIT_END_GAME));
			facade.registerProxy(new IncomingDataErrorProxy(HomeHandlers.END_GAME_ERROR));
			
			var endGameFormProxy:FormProxy = new FormProxy(HomeHandlers.GM_END_GAME_FORM);
			endGameFormProxy.addDisplayText("Warning", "Warning", "This will end the game immediately, and cannot be undone.");
			endGameFormProxy.addButton("End the Game", HomeHandlers.GM_END_GAME_SUBMIT);
			endGameFormProxy.addBackendData("Cancel", HomeHandlers.GM_END_GAME_CANCEL);
			facade.registerProxy(endGameFormProxy);
			
			var gmwhichstageInfo:RequestProxy = new RequestProxy(HomeHandlers.FETCH_STAGES);
			facade.registerProxy(gmwhichstageInfo);
			gmwhichstageInfo.sendRequest();
			
			facade.registerProxy(new IncomingDataErrorProxy(HomeHandlers.FETCH_STAGES_ERROR));
			
			var incomingStageInfo:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.STAGES_RECEIVED, HomeHandlers.STAGES_RECEIVED);
			incomingStageInfo.addDataParam(new DataParamString(HomeHandlers.GM_CURRENT_SEASON));
			incomingStageInfo.addDataParam(new DataParamString(HomeHandlers.GM_CURRENT_STAGE));
			incomingStageInfo.addDataParam(new DataParamString(HomeHandlers.GM_NEXT_SEASON));
			incomingStageInfo.addDataParam(new DataParamString(HomeHandlers.GM_NEXT_STAGE));
			facade.registerProxy(incomingStageInfo);
			
			var subMenuProxy:SubMenuListProxy = new SubMenuListProxy();
			facade.registerProxy(subMenuProxy);
			subMenuProxy.addSubMenuItem(HomeHandlers.GM_SUB_MENU_GAMEOVERVIEW);
			subMenuProxy.addSubMenuItem(HomeHandlers.GM_SUB_MENU_TICKER);
			subMenuProxy.addSubMenuItem(HomeHandlers.GM_SUB_MENU_STAGEPROGRESS, new Array("TASK", "FOOD"));
			subMenuProxy.addSubMenuItem(HomeHandlers.GM_SUB_MENU_CHANGESTAGE);
			subMenuProxy.addSubMenuItem(HomeHandlers.GM_SUB_MENU_ENDGAME);
			subMenuProxy.setDefaultMenuItem(HomeHandlers.GM_SUB_MENU_GAMEOVERVIEW);
			
			var pendingTasksRequest:RequestProxy = new RequestProxy(HomeHandlers.GM_FETCH_PENDING_TASKS);
			facade.registerProxy(pendingTasksRequest);
			pendingTasksRequest.sendRequest();
			
			facade.registerProxy(new IncomingDataErrorProxy(HomeHandlers.GM_FETCH_PENDING_TASKS_ERROR));
			
			var incomingPendingTasks:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.GM_PENDING_TASKS_RECEIVED, HomeHandlers.GM_PENDING_TASKS_RECEIVED);
			incomingPendingTasks.addDataParam(new DataParamArrayGMHouseholdData("TaskCounts"));
			facade.registerProxy(incomingPendingTasks);
			facade.registerProxy(new GMHouseholdDataProxy());
			
			var pendingTasksUpdate:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.GM_PENDING_TASKS_UPDATED, HomeHandlers.GM_PENDING_TASKS_UPDATED);
			pendingTasksUpdate.addDataParam(new DataParamInt("HearthId"));
			pendingTasksUpdate.addDataParam(new DataParamInt("PendingTaskCount"));
			facade.registerProxy(pendingTasksUpdate);
			
			var foodOverviewRequest:RequestProxy = new RequestProxy(HomeHandlers.GM_FETCH_FOOD_OVERVIEW);
			facade.registerProxy(foodOverviewRequest);
			foodOverviewRequest.sendRequest();
			
			facade.registerProxy(new IncomingDataErrorProxy(HomeHandlers.GM_FETCH_FOOD_ERROR));
			
			var incomingFoodOverview:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.GM_FOOD_OVERVIEW_RECEIVED, HomeHandlers.GM_FOOD_OVERVIEW_RECEIVED);
			incomingFoodOverview.addDataParam(new DataParamArrayGMHouseholdData("gm_food_overview"));
			facade.registerProxy(incomingFoodOverview);
			
			var incomingFoodUpdate:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.GM_FOOD_OVERVIEW_UPDATED, HomeHandlers.GM_FOOD_OVERVIEW_UPDATED);
			incomingFoodUpdate.addDataParam(new DataParamGMHouseholdData("gm_food_update"));
			facade.registerProxy(incomingFoodUpdate);
		}
		private function removeProxies():void {
			facade.removeProxy(HomeHandlers.HOME_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(HomeHandlers.SEND_TICKER_FORM);
			facade.removeProxy(HomeHandlers.SUBMIT_TICKER_REQUEST + RequestProxy.NAME);
			facade.removeProxy(HomeHandlers.SUBMIT_TICKER_REQUEST_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(SeasonsHandlers.SUBMIT_STAGE_CHANGE_REQUEST + RequestProxy.NAME);
			facade.removeProxy(SeasonsHandlers.CHANGE_STAGE_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(SeasonsHandlers.CHANGE_STAGE_FORM);
			facade.removeProxy(CommsHandlers.TICKER_MESSAGE_CLEAR + RequestProxy.NAME);
			facade.removeProxy(RoomHandlers.GET_GAME_STATUSES + RequestProxy.NAME);
			facade.removeProxy(RoomHandlers.GET_GAME_STATUSES_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(RoomHandlers.GAME_STATUSES_RECEIVED + IncomingDataProxy.NAME);
			facade.removeProxy(HearthsViewStatusProxy.NAME);
			facade.removeProxy(HomeHandlers.GM_END_GAME_FORM);
			facade.removeProxy(HomeHandlers.END_GAME_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(HomeHandlers.SUBMIT_END_GAME + RequestProxy.NAME);
			facade.removeProxy(HomeHandlers.FETCH_STAGES + RequestProxy.NAME);
			facade.removeProxy(HomeHandlers.FETCH_STAGES_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(HomeHandlers.STAGES_RECEIVED + IncomingDataProxy.NAME);
			facade.removeProxy(SubMenuListProxy.NAME);
			facade.removeProxy(HomeHandlers.GM_FETCH_PENDING_TASKS + RequestProxy.NAME);
			facade.removeProxy(HomeHandlers.GM_FETCH_PENDING_TASKS_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(HomeHandlers.GM_PENDING_TASKS_RECEIVED + IncomingDataProxy.NAME);
			facade.removeProxy(GMHouseholdDataProxy.NAME);
			facade.removeProxy(HomeHandlers.GM_PENDING_TASKS_UPDATED + IncomingDataProxy.NAME);
			facade.removeProxy(HomeHandlers.GM_FETCH_FOOD_OVERVIEW + RequestProxy.NAME);
			facade.removeProxy(HomeHandlers.GM_FETCH_FOOD_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(HomeHandlers.GM_FOOD_OVERVIEW_RECEIVED + IncomingDataProxy.NAME);
			facade.removeProxy(HomeHandlers.GM_FOOD_OVERVIEW_UPDATED + IncomingDataProxy.NAME);
		}
		private function registerCommands():void {
			facade.registerCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED, SubMenuHomeManagerCommand);
			facade.registerCommand(HomeHandlers.TICKER_CANCEL, CancelTickerMessageCommand);
			facade.registerCommand(HomeHandlers.TICKER_SUBMIT, SubmitTickerMessageCommand);
			facade.registerCommand(SeasonsHandlers.CHANGE_STAGE_SUBMIT, SubmitChangeStageCommand);
			facade.registerCommand(HomeHandlers.TICKER_CLEAR, SubmitClearTickerCommand);
			facade.registerCommand(HomeHandlers.TICKER_EXPIRES_CHANGED, TickerFormExpiresChangedCommand);
			facade.registerCommand(RoomHandlers.GAME_STATUSES_RECEIVED, HouseholdStatusesReceivedCommand);
			facade.registerCommand(HomeHandlers.GM_END_GAME_CANCEL, CancelEndGameForm);
			facade.registerCommand(HomeHandlers.GM_END_GAME_SUBMIT, SubmitEndGameForm);
			facade.registerCommand(HomeHandlers.STAGES_RECEIVED, GMStagesReceivedCommand);
			facade.registerCommand(HomeHandlers.GM_PENDING_TASKS_RECEIVED, GMTaskCountReceivedCommand);
			facade.registerCommand(HomeHandlers.GM_PENDING_TASKS_UPDATED, GMTaskCountUpdatedCommand);
			facade.registerCommand(HomeHandlers.GM_FOOD_OVERVIEW_RECEIVED, GMFoodOverviewReceivedCommand);
			facade.registerCommand(HomeHandlers.GM_FOOD_OVERVIEW_UPDATED, GMFoodUpdatedCommand);
		}
		private function removeCommands():void {
			facade.removeCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED);
			facade.removeCommand(HomeHandlers.TICKER_CANCEL);
			facade.removeCommand(HomeHandlers.TICKER_SUBMIT);
			facade.removeCommand(HomeHandlers.TICKER_CLEAR);
			facade.removeCommand(SeasonsHandlers.CHANGE_STAGE_SUBMIT);
			facade.removeCommand(HomeHandlers.TICKER_EXPIRES_CHANGED);
			facade.removeCommand(RoomHandlers.GAME_STATUSES_RECEIVED);
			facade.removeCommand(HomeHandlers.GM_END_GAME_CANCEL);
			facade.removeCommand(HomeHandlers.GM_END_GAME_SUBMIT);
			facade.removeCommand(HomeHandlers.STAGES_RECEIVED);
			facade.removeCommand(HomeHandlers.GM_PENDING_TASKS_RECEIVED);
			facade.removeCommand(HomeHandlers.GM_PENDING_TASKS_UPDATED);
			facade.removeCommand(HomeHandlers.GM_FOOD_OVERVIEW_RECEIVED);
			facade.removeCommand(HomeHandlers.GM_FOOD_OVERVIEW_UPDATED);
		}
		private function registerMediators():void {
			trace("HomeManagerGameState sez: I am adding the buttons");
			var submenuMediator:SubMenuMediator = new SubMenuMediator();
			facade.registerMediator(submenuMediator);
			
			
			var tickerMediator:FormMediator = new FormMediator(HomeHandlers.SEND_TICKER_FORM, new Sprite());
			facade.registerMediator(tickerMediator);
			tickerMediator.setLabelWidth(70);
			
			var changeStageForm:FormMediator = new FormMediator(SeasonsHandlers.CHANGE_STAGE_FORM, new Sprite());
			facade.registerMediator(changeStageForm);
			changeStageForm.setLabelWidth(150);
			
			facade.registerMediator(new GameStatusListMediator());
			
			facade.registerMediator(new FormMediator(HomeHandlers.GM_END_GAME_FORM, new Sprite()));
			
			facade.registerMediator(new TasksGMOverviewListMediator());
			facade.registerMediator(new FoodGMOverviewListMediator());
			//Must be the last thing in registerMediators
			submenuMediator.moveToDefaultButton();
		}
		private function removeMediators():void {
			facade.removeMediator(SubMenuMediator.NAME);
			facade.removeMediator(HomeHandlers.SEND_TICKER_FORM);
			facade.removeMediator(SeasonsHandlers.CHANGE_STAGE_FORM);
			facade.removeMediator(GameStatusListMediator.NAME);
			facade.removeMediator(HomeHandlers.GM_END_GAME_FORM);
			facade.removeMediator(TasksGMOverviewListMediator.NAME);
			facade.removeMediator(FoodGMOverviewListMediator.NAME);
		}
		private function checkStage():void {
			currentStage = 0;
			var seasonsListProxy:SeasonsListProxy = facade.retrieveProxy(SeasonsListProxy.NAME) as SeasonsListProxy;
			if(seasonsListProxy!=null){
				var thisStage:SeasonStage = seasonsListProxy.getCurrentStage();
				if(thisStage != null){
					trace("HomeManagerGameState sez: Current stage is " + thisStage.getName());
					var currentStageName:String = thisStage.getName().toUpperCase();
					if(currentStageName.search("TASK")>=0){
						currentStage = TASK_TIME;
					} else if (currentStageName.search("FOOD")>=0){
						currentStage = FOOD_TIME;
					}
				}
			}
		}
		
	}
}
