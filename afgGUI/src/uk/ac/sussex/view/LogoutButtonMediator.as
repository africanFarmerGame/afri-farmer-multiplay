﻿/**This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	**/package uk.ac.sussex.view {		import org.puremvc.as3.multicore.patterns.mediator.Mediator;	import org.puremvc.as3.multicore.interfaces.*;		import uk.ac.sussex.general.ApplicationFacade;	import uk.ac.sussex.view.components.GameButton;	import uk.ac.sussex.view.components.LogoutButton;	import flash.events.Event;		public class LogoutButtonMediator extends Mediator implements IMediator{		public static const NAME:String = "LogoutButtonMediator";		public static const LOGOUT_BUTTON_XPOS:Number = 800;		public static const LOGOUT_BUTTON_YPOS:Number = 0;				public function LogoutButtonMediator() {			// constructor code			super(NAME, null);		}		public function setPosition(x:Number, y:Number): void {			logoutButton.x = x;			logoutButton.y = y;		}		private function buttonClicked(e:Event) :void {			sendNotification(ApplicationFacade.LOGOUT_REQUEST);		}		//Cast the viewComponent to the correct type.		protected function get logoutButton():LogoutButton {			return viewComponent as LogoutButton;		}		override public function onRegister():void		{			viewComponent = new LogoutButton();			logoutButton.addEventListener(GameButton.BUTTON_CLICK, buttonClicked);			var gameMediator:ApplicationMediator = facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;			var xpos:Number = gameMediator.getLeftWidth() + 5; //+ gameMediator.getRightWidth() - logoutButton.width - 23;			var ypos:Number = gameMediator.getTopHeight() - logoutButton.height;			this.setPosition(xpos, ypos);			sendNotification(ApplicationFacade.ADD_TO_CONTROLS, logoutButton);		}		override public function onRemove():void		{			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, logoutButton);		}	}	}