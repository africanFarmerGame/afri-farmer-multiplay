package uk.ac.sussex.controller {
	import uk.ac.sussex.model.*;
	import uk.ac.sussex.model.valueObjects.*;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class ReceivedNewHouseholdTask extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("ReceivedNewHouseholdTask sez: we seem to have received a new household task.");
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var task:Task = incomingData.getParamValue("Task") as Task;
			var taskLP:TaskListProxy = facade.retrieveProxy(TaskListProxy.NAME) as TaskListProxy;
			var gameAssetLP:GameAssetListProxy = facade.retrieveProxy(GameAssetListProxy.NAME) as GameAssetListProxy;
			//Hm. The hearth member list might not be enough. Tricky. It'll do for now. 
			var hearthMembersLP:HearthMembersListProxy = facade.retrieveProxy(HearthMembersListProxy.NAME) as HearthMembersListProxy;
			
			var assetId:int = task.getAsset().getId();
			trace("ReceivedNewHouseholdTask sez: assetId is not null " + (assetId!=null));
			var asset:GameAsset = gameAssetLP.getGameAsset(assetId);
			trace("ReceivedNewHouseholdTask sez: asset is not null " + (asset!=null));
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
			taskLP.addHouseholdTask(task);
		}
	}
}
