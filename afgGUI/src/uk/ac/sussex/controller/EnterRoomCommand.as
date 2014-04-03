/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.games.BaseGameFactory;
	import uk.ac.sussex.model.games.BaseGame;
	import uk.ac.sussex.view.ApplicationMediator;
	import uk.ac.sussex.serverhandlers.CommsHandlers;
	import uk.ac.sussex.model.ServerRoomProxy;
	import uk.ac.sussex.model.PlayerCharProxy;
	import org.puremvc.as3.multicore.interfaces.*;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.states.*;
	import uk.ac.sussex.model.PCListProxy;
	import uk.ac.sussex.model.ServerProxy;

	/**
	 * @author em97
	 */
	public class EnterRoomCommand extends SimpleCommand {
		override public function execute(note:INotification):void{
			var roomname:String = note.getBody() as String;
			roomname = roomname.toLowerCase();
			
			var appMediator:ApplicationMediator = facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;
			
			if(roomname == "lobby"){
				appMediator.registerState(new JoinGameGameState(facade));
				appMediator.registerState(new GameSettingsGameState(facade));
				sendNotification(ApplicationFacade.CHANGE_STATE, JoinGameGameState.NAME);
				
			} else {
				//Get the details from the server room proxy. 
				var srp:ServerRoomProxy = facade.retrieveProxy(ServerRoomProxy.NAME) as ServerRoomProxy;
				
				//Also get the character - need to know what role. 
				var myPCProxy:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;
				var banker:Boolean = false;
				if(myPCProxy != null){
					banker = myPCProxy.isBanker();
				}
				
				//Need to check the states are registered for the game.
				if(!appMediator.checkStatesRegistered()){
					var gameType:String = srp.getGameType();
					var baseGameFactory:BaseGameFactory = new BaseGameFactory();
					//Now get the relevant game, and register the damn things. 
					var baseGame:BaseGame = baseGameFactory.getBaseGame(gameType);
					baseGame.registerGameStates(facade, appMediator, banker);
					appMediator.setStatesRegistered(true);
				}
				
				var roomType:String = srp.getRoomType(banker);
				sendNotification(ApplicationFacade.CHANGE_STATE, roomType);
				
				//Also need to clear the talk list of users and add all the new ones.
				var serverProxy:ServerProxy = facade.retrieveProxy(ServerProxy.NAME) as ServerProxy;
				var pcList:Array = serverProxy.getRoomPCs();
				
				var talkList:PCListProxy = facade.retrieveProxy(CommsHandlers.DIR_TALK_LIST) as PCListProxy;
				if(talkList == null){
					talkList = new PCListProxy(CommsHandlers.DIR_TALK_LIST);
					facade.registerProxy(talkList);
				}
				talkList.clearPCList();
				talkList.addManyPCs(pcList);
				
				//Send a message to the room members that you've arrived.
				if(!banker){ 	
					sendNotification(CommsHandlers.SEND_TALK_MESSAGE, myPCProxy.getPlayerDisplayName() + " has arrived.");
				}
			}			
		}
	}
}
