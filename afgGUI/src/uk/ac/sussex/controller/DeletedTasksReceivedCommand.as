/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.AnyChar;
	import uk.ac.sussex.model.valueObjects.GameAsset;
	import uk.ac.sussex.model.valueObjects.Task;
	import uk.ac.sussex.model.HearthMembersListProxy;
	import uk.ac.sussex.model.GameAssetListProxy;
	import uk.ac.sussex.model.TaskListProxy;
	import uk.ac.sussex.serverhandlers.FarmHandlers;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class DeletedTasksReceivedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("DeletedTasksReceivedCommand sez: I done been triggered");
			var incomingData:IncomingData = note.getBody() as IncomingData;
			
			if(incomingData!= null){
				var tasks:Array = incomingData.getParamValue(FarmHandlers.UPDATED_TASKS) as Array;
				var taskListProxy:TaskListProxy = facade.retrieveProxy(TaskListProxy.NAME) as TaskListProxy;
				var gameAssetLP:GameAssetListProxy = facade.retrieveProxy(GameAssetListProxy.NAME) as GameAssetListProxy;
				var hearthMembersLP:HearthMembersListProxy = facade.retrieveProxy(HearthMembersListProxy.NAME) as HearthMembersListProxy;
				for each (var task:Task in tasks){
					var assetId:int = task.getAsset().getId();
					var asset:GameAsset = gameAssetLP.getGameAsset(assetId);
					task.setAsset(asset);
					if(task.getActor()!=null){
						var actorId:int = task.getActor().getId();
						var actor:AnyChar = hearthMembersLP.getMember(actorId);
						if(actor!=null){
							task.getActor().setRelationship(AnyChar.IMMEDIATE_FAMILY);
						} else {
							task.getActor().setRelationship(AnyChar.NO_RELATION);
						}
						task.setActor(actor);
					}
				}
				
				taskListProxy.addHouseholdTasks(tasks);
			}
		}
	}
}
