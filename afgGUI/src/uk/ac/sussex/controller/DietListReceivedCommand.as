package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.DietItem;
	import uk.ac.sussex.model.valueObjects.Diet;
	import uk.ac.sussex.model.GameAssetListProxy;
	import uk.ac.sussex.model.DietListProxy;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class DietListReceivedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("DietListReceivedCommand sez: I has been fired " + note.getName());
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var newDiets:Array = incomingData.getParamValue("Diets") as Array;
			var dietListProxy:DietListProxy = facade.retrieveProxy(DietListProxy.NAME) as DietListProxy;
			if(dietListProxy != null){
				dietListProxy.addDiets(newDiets);
			} 
			var galp:GameAssetListProxy = facade.retrieveProxy(GameAssetListProxy.NAME) as GameAssetListProxy;
			if(galp != null){
				for each (var diet:Diet in newDiets){
					var diarray:Array = diet.getDietItems();
					for each (var di:DietItem in diarray){
						di.setAsset(galp.getFoodAsset(di.getAssetId()));
					}
				}
			}
		}
	}
}
