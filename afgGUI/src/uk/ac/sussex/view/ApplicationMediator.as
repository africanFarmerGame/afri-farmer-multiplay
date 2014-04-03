﻿/**This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	**/package uk.ac.sussex.view {	import uk.ac.sussex.states.LoginGameState;	import uk.ac.sussex.states.StateHandler;	import org.puremvc.as3.multicore.patterns.mediator.Mediator;	import org.puremvc.as3.multicore.interfaces.IMediator;	import org.puremvc.as3.multicore.interfaces.INotification;		import uk.ac.sussex.states.IGameState;	import uk.ac.sussex.general.*;		import flash.display.DisplayObject;		public class ApplicationMediator extends Mediator implements IMediator{		public static const NAME:String = "ApplicationMediator";				public function ApplicationMediator( viewComponent:Object) {			// constructor code			super(NAME, viewComponent);		}		override public function listNotificationInterests():Array {			return [					ApplicationFacade.ADD_TO_BASE,					ApplicationFacade.ADD_TO_BACKGROUND,					ApplicationFacade.REMOVE_FROM_SCREEN,					ApplicationFacade.CHANGE_STATE, 					ApplicationFacade.REVERT_STATE, 					ApplicationFacade.REFRESH_STATE					];		}				override public function handleNotification (note:INotification):void {			switch ( note.getName() ) {				case ApplicationFacade.ADD_TO_BACKGROUND:				case ApplicationFacade.ADD_TO_BASE: 					var child1:DisplayObject = note.getBody() as DisplayObject;					app.addChild(child1);					break;				case ApplicationFacade.REMOVE_FROM_SCREEN:					var child:DisplayObject = note.getBody() as DisplayObject;					if(child.parent != null){						child.parent.removeChild(child);					}					break;				case ApplicationFacade.REVERT_STATE:					app.revertState();					break;				case ApplicationFacade.CHANGE_STATE:					sendNotification(ApplicationFacade.RESET_CONTROLS);										var newState:String = note.getBody() as String;					app.changeState(newState);					changeBackground(newState);					break;				case ApplicationFacade.REFRESH_STATE:					app.refreshState();					break;			}		}				public function registerState(state:IGameState):void{			app.getStateHandler().register(state);		}		public function getDisplayWidth():Number {			return app.getDisplayWidth();		}		public function getDisplayHeight():Number {			return app.getDisplayHeight();		}		public function getLeftWidth():Number {			return app.getLeftWidth();		}		public function getRightWidth():Number {			return app.getRightWidth();		}		public function getTopHeight():Number {			return app.getTopHeight();		}		public function getCentreHeight():Number {			return app.getCentreHeight();		}		public function getBottomHeight():Number {			return app.getBottomHeight();		}		public function checkStatesRegistered():Boolean{			return app.getStatesRegistered();		}		public function setStatesRegistered(registered:Boolean):void {			app.getStateHandler().setStatesRegistered(registered);		}		public function resetStates():void {			var stateHandler:StateHandler = app.getStateHandler();			stateHandler.clearRegisteredStates();			stateHandler.register(new LoginGameState(facade));		}		private function changeBackground(stateName:String):void {			var backgroundMediator:BackgroundMediator = facade.retrieveMediator(BackgroundMediator.NAME) as BackgroundMediator;			backgroundMediator.setBackground(stateName);		}		//Cast the viewComponent to the correct type.		protected function get app():GameGUI {			return viewComponent as GameGUI;		}			}	}