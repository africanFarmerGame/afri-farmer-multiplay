﻿/**This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	**/package uk.ac.sussex.states {	import uk.ac.sussex.model.valueObjects.requestParams.*;	import uk.ac.sussex.serverhandlers.HomeHandlers;	import uk.ac.sussex.model.*;	import uk.ac.sussex.model.valueObjects.SeasonStage;	import uk.ac.sussex.serverhandlers.FarmHandlers;	import flash.display.Sprite;	import org.puremvc.as3.multicore.interfaces.IFacade;	import uk.ac.sussex.general.ApplicationFacade;	import uk.ac.sussex.view.*;	import uk.ac.sussex.controller.*;	import uk.ac.sussex.states.IGameState;	/**	 * @author em97	 */	public class TaskGameState extends PlayerRoomState implements IGameState {		private var isTaskTime:Boolean; 				public static const NAME:String = "TaskGameState";		private static const DISPLAY_TITLE:String = "Task Management";				public function TaskGameState(facade:IFacade){			//this.facade = facade;			super(facade, NAME, DISPLAY_TITLE);		}				override public function displayState() : void {			//CommsHandlers.registerComponents(this.facade);			//SeasonsHandlers.registerComponents(this.facade);			super.displayState();						checkTaskTime();						this.registerProxies();			this.registerCommands();			this.registerMediators();		}		override public function cleanUpState() : void {			//CommsHandlers.removeComponents(facade);			//SeasonsHandlers.removeComponents(facade);						this.facade.removeProxy(FarmHandlers.GET_POSSIBLE_TASKS + RequestProxy.NAME);			this.facade.removeProxy(FarmHandlers.POSSIBLE_TASKS_RECEIVED + IncomingDataProxy.NAME);			this.facade.removeProxy(FarmHandlers.POSSIBLE_TASKS_ERROR + IncomingDataProxy.NAME);			this.facade.removeProxy(FarmHandlers.TASK_EDIT_FORM);			this.facade.removeProxy(FarmHandlers.TASK_SAVE + RequestProxy.NAME);			this.facade.removeProxy(FarmHandlers.TASK_SAVE_ERROR + IncomingDataProxy.NAME);			this.facade.removeProxy(FarmHandlers.GET_HOUSEHOLD_TASKS + RequestProxy.NAME);			this.facade.removeProxy(FarmHandlers.HOUSEHOLD_TASKS_RECEIVED + IncomingDataProxy.NAME);			this.facade.removeProxy(FarmHandlers.HOUSEHOLD_TASKS_ERROR + IncomingDataProxy.NAME);			this.facade.removeProxy(FarmHandlers.NEW_TASK_RECEIVED + IncomingDataProxy.NAME);			this.facade.removeProxy(FarmHandlers.DELETE_HOUSEHOLD_TASK + RequestProxy.NAME);			this.facade.removeProxy(FarmHandlers.DELETE_TASK_ERROR + IncomingDataProxy.NAME);			this.facade.removeProxy(FarmHandlers.HOUSEHOLD_TASK_DELETED + IncomingDataProxy.NAME);			this.facade.removeProxy(SubMenuListProxy.NAME);						this.facade.removeCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED);			this.facade.removeCommand(ApplicationFacade.INCOMING_ERROR_MESSAGE);			this.facade.removeCommand(ApplicationFacade.INCOMING_MESSAGE);			this.facade.removeCommand(FarmHandlers.POSSIBLE_TASKS_RECEIVED);			this.facade.removeCommand(FarmHandlers.HOUSEHOLD_TASKS_RECEIVED);			this.facade.removeCommand(FarmHandlers.NEW_TASK_RECEIVED);			this.facade.removeCommand(FarmHandlers.TASK_SUBMIT);			this.facade.removeCommand(FarmHandlers.TASK_CANCEL);			this.facade.removeCommand(FarmHandlers.DELETE_HOUSEHOLD_TASK);						this.facade.removeMediator(SubMenuMediator.NAME);			this.facade.removeMediator(FarmHandlers.TASK_EDIT_FORM);			this.facade.removeMediator(TaskListMediator.NAME);						super.cleanUpState();		}		override public function refresh():void {			super.refresh();			//Also refresh the tasks. 			var getTasks:RequestProxy = facade.retrieveProxy(FarmHandlers.GET_HOUSEHOLD_TASKS + RequestProxy.NAME) as RequestProxy;			var serverRoomProxy:ServerRoomProxy = facade.retrieveProxy(ServerRoomProxy.NAME) as ServerRoomProxy;			var roomId:String = serverRoomProxy.getRoomId();			var hearthId:int = int(roomId);			getTasks.setParamValue(HomeHandlers.HEARTH_ID, hearthId);			getTasks.sendRequest();			//And the possible tasks.			var getPossTasks:RequestProxy = facade.retrieveProxy(FarmHandlers.GET_POSSIBLE_TASKS + RequestProxy.NAME) as RequestProxy;			getPossTasks.setParamValue(HomeHandlers.HEARTH_ID, hearthId);			getPossTasks.sendRequest();						//And check the submenu is still displaying the right things. 			facade.removeMediator(SubMenuMediator.NAME);						trace("TaskGameState sez: I is about to be refreshed and check the tasktime");			try{				checkTaskTime();			} catch (error:Error) {				throw new Error("Problem in checkTaskTime: " + error.message);			}						var subMenuMediator:SubMenuMediator = new SubMenuMediator();			facade.registerMediator(subMenuMediator);			if(isTaskTime){				this.registerTaskTimeProxies();				this.registerTaskTimeMediators();			}						try {				subMenuMediator.moveToDefaultButton();			} catch (error:Error) {				throw new Error("Problem in moveToDefaultButton. " + error.message);			}		}		private function checkTaskTime():void {			isTaskTime = false;			var myChar:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;			if(!myChar.isBanker()){				var seasonsListProxy:SeasonsListProxy = facade.retrieveProxy(SeasonsListProxy.NAME) as SeasonsListProxy;				if(seasonsListProxy==null){					throw new Error("The SeasonsListProxy is null in checkTaskTime.");				}				var currentStage:SeasonStage = seasonsListProxy.getCurrentStage();				if(currentStage != null){					trace("TaskGameState sez: Current stage is " + currentStage.getName());					var currentStageName:String = currentStage.getName().toUpperCase();					if(currentStageName.search("TASK")==0){						isTaskTime = true;					}				}			}		}		private function registerProxies():void {			var serverRoomProxy:ServerRoomProxy = facade.retrieveProxy(ServerRoomProxy.NAME) as ServerRoomProxy;			var roomId:String = serverRoomProxy.getRoomId();			var hearthId:int = int(roomId);			var hearthRequestParam:DataParamInt = new DataParamInt(HomeHandlers.HEARTH_ID);			hearthRequestParam.setParamValue(hearthId);			var errorRequestParam:DataParamString = new DataParamString("message");						var farmError:IncomingDataProxy = new IncomingDataProxy(FarmHandlers.FARM_ERROR, ApplicationFacade.INCOMING_ERROR_MESSAGE);			farmError.addDataParam(errorRequestParam);			facade.registerProxy(farmError);						facade.registerProxy(new TaskListProxy());						var getPossTasks:RequestProxy = new RequestProxy(FarmHandlers.GET_POSSIBLE_TASKS);			getPossTasks.addRequestParam(hearthRequestParam);			facade.registerProxy(getPossTasks);			getPossTasks.sendRequest();						var receivePossTasks:IncomingDataProxy = new IncomingDataProxy(FarmHandlers.POSSIBLE_TASKS_RECEIVED, FarmHandlers.POSSIBLE_TASKS_RECEIVED);			receivePossTasks.addDataParam(new DataParamArrayPotentialTasks("PotentialTasks"));			facade.registerProxy(receivePossTasks);						var possTasksError:IncomingDataProxy = new IncomingDataProxy(FarmHandlers.POSSIBLE_TASKS_ERROR, ApplicationFacade.INCOMING_ERROR_MESSAGE);			possTasksError.addDataParam(errorRequestParam);			facade.registerProxy(possTasksError);						var getHouseholdTasks:RequestProxy = new RequestProxy(FarmHandlers.GET_HOUSEHOLD_TASKS);			getHouseholdTasks.addRequestParam(hearthRequestParam);			getHouseholdTasks.setParamValue(HomeHandlers.HEARTH_ID, hearthId);			facade.registerProxy(getHouseholdTasks);			getHouseholdTasks.sendRequest();						var receiveHouseholdTasks:IncomingDataProxy = new IncomingDataProxy(FarmHandlers.HOUSEHOLD_TASKS_RECEIVED, FarmHandlers.HOUSEHOLD_TASKS_RECEIVED);			receiveHouseholdTasks.addDataParam(new DataParamArrayTasks("Tasks"));			facade.registerProxy(receiveHouseholdTasks);						var householdTasksError:IncomingDataProxy = new IncomingDataProxy(FarmHandlers.HOUSEHOLD_TASKS_ERROR, ApplicationFacade.INCOMING_ERROR_MESSAGE);			householdTasksError.addDataParam(errorRequestParam);			facade.registerProxy(householdTasksError);									var receiveNewTask:IncomingDataProxy = new IncomingDataProxy(FarmHandlers.NEW_TASK_RECEIVED, FarmHandlers.NEW_TASK_RECEIVED);			receiveNewTask.addDataParam(new DataParamTask("Task"));			facade.registerProxy(receiveNewTask);						var deleteTask:RequestProxy = new RequestProxy(FarmHandlers.DELETE_HOUSEHOLD_TASK);			deleteTask.addRequestParam(new DataParamInt(FarmHandlers.TASK_ID));			facade.registerProxy(deleteTask);						var deleteTaskSuccess:IncomingDataProxy = new IncomingDataProxy(FarmHandlers.HOUSEHOLD_TASK_DELETED, FarmHandlers.HOUSEHOLD_TASK_DELETED);			deleteTaskSuccess.addDataParam(new DataParamArrayTasks(FarmHandlers.UPDATED_TASKS));			facade.registerProxy(deleteTaskSuccess);						var deleteTaskError:IncomingDataErrorProxy = new IncomingDataErrorProxy(FarmHandlers.DELETE_TASK_ERROR);			facade.registerProxy(deleteTaskError);			if(isTaskTime){				this.registerTaskTimeProxies();			}			var myChar:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;						var subMenuProxy:SubMenuListProxy = new SubMenuListProxy();			facade.registerProxy(subMenuProxy);			subMenuProxy.addSubMenuItem(FarmHandlers.TASK_SUB_MENU_LIST);			if(!myChar.isBanker()){				subMenuProxy.addSubMenuItem(FarmHandlers.TASK_SUB_MENU_NEW, new Array("TASK"));				subMenuProxy.addSubMenuItem(FarmHandlers.TASK_SUB_MENU_EDIT, new Array("TASK"));				subMenuProxy.addSubMenuItem(FarmHandlers.TASK_SUB_MENU_DELETE, new Array("TASK"));			}			subMenuProxy.addSubMenuItem(FarmHandlers.TASK_SUB_MENU_EXIT);			subMenuProxy.setDefaultMenuItem(FarmHandlers.TASK_SUB_MENU_LIST);		}		private function registerCommands():void {			facade.registerCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED, SubMenuTasksCommand);			this.facade.registerCommand(ApplicationFacade.INCOMING_MESSAGE, DisplayServerMessageCommand);			this.facade.registerCommand(ApplicationFacade.INCOMING_ERROR_MESSAGE, DisplayServerErrorMessageCommand);			this.facade.registerCommand(FarmHandlers.POSSIBLE_TASKS_RECEIVED, ReceivedPotentialTasksCommand);			this.facade.registerCommand(FarmHandlers.HOUSEHOLD_TASKS_RECEIVED, ReceivedHouseholdTasksCommand);			this.facade.registerCommand(FarmHandlers.NEW_TASK_RECEIVED, ReceivedNewHouseholdTask);			this.facade.registerCommand(FarmHandlers.DELETE_HOUSEHOLD_TASK, DeleteHouseholdTaskCommand);			this.facade.registerCommand(FarmHandlers.HOUSEHOLD_TASK_DELETED, DeletedTasksReceivedCommand);			if(isTaskTime){				this.facade.registerCommand(FarmHandlers.TASK_TYPE_UPDATED, TaskTypeChangedCommand);				this.facade.registerCommand(FarmHandlers.TASK_SUBMIT, SubmitTaskCommand);				this.facade.registerCommand(FarmHandlers.TASK_CANCEL, CancelEditTaskForm);			}		}		private function registerMediators():void {							//var appMediator:ApplicationMediator = facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;						var submenuMediator:SubMenuMediator = new SubMenuMediator();			facade.registerMediator(submenuMediator);						facade.registerMediator(new TaskListMediator());						if(isTaskTime){				registerTaskTimeMediators();			}						submenuMediator.moveToDefaultButton();		}		private function registerTaskTimeProxies():void{			var saveTask:RequestProxy = facade.retrieveProxy(FarmHandlers.TASK_SAVE + RequestProxy.NAME) as RequestProxy;			if(saveTask == null){ 				saveTask = new RequestProxy(FarmHandlers.TASK_SAVE);				saveTask.addRequestParam(new DataParamInt(FarmHandlers.TASK_ID));				saveTask.addRequestParam(new DataParamInt(FarmHandlers.TASK_HEARTH));				saveTask.addRequestParam(new DataParamString(FarmHandlers.TASK_TYPE));				saveTask.addRequestParam(new DataParamInt(FarmHandlers.TASK_ACTOR));				saveTask.addRequestParam(new DataParamInt(FarmHandlers.TASK_LOCATION));				saveTask.addRequestParam(new DataParamInt(FarmHandlers.TASK_ASSET));				facade.registerProxy(saveTask);			}			var saveTaskError:IncomingDataProxy = facade.retrieveProxy(FarmHandlers.TASK_SAVE_ERROR + IncomingDataProxy.NAME) as IncomingDataProxy;			if(saveTaskError == null){ 					saveTaskError = new IncomingDataProxy(FarmHandlers.TASK_SAVE_ERROR, ApplicationFacade.INCOMING_ERROR_MESSAGE);				saveTaskError.addDataParam(new DataParamString("message"));				facade.registerProxy(saveTaskError);			}			var taskFormProxy:FormProxy = facade.retrieveProxy(FarmHandlers.TASK_EDIT_FORM) as FormProxy;			if(taskFormProxy==null){ 					taskFormProxy = new FormProxy(FarmHandlers.TASK_EDIT_FORM);				facade.registerProxy(taskFormProxy);				taskFormProxy.addBackendData(FarmHandlers.TASK_ID);				taskFormProxy.addBackendData(FarmHandlers.TASK_HEARTH);				taskFormProxy.addDropDown(FarmHandlers.TASK_TYPE, "Type:", null, null, false, FarmHandlers.TASK_TYPE_UPDATED);				taskFormProxy.addDropDown(FarmHandlers.TASK_LOCATION, "Location: ");				taskFormProxy.addDropDown(FarmHandlers.TASK_ASSET, "Resources:");				taskFormProxy.addDropDown(FarmHandlers.TASK_ACTOR, "Assign:");				taskFormProxy.addButton("Save", FarmHandlers.TASK_SUBMIT);				taskFormProxy.addButton("Cancel", FarmHandlers.TASK_CANCEL);			}		}		private function registerTaskTimeMediators():void{			var taskFormMediator:FormMediator = facade.retrieveMediator(FarmHandlers.TASK_EDIT_FORM) as FormMediator;			if(taskFormMediator==null){ 					taskFormMediator = new FormMediator(FarmHandlers.TASK_EDIT_FORM, new Sprite());				facade.registerMediator(taskFormMediator);			}		}			}	}