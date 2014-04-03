package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.GameAsset;
	import uk.ac.sussex.model.GameAssetListProxy;
	import uk.ac.sussex.model.valueObjects.Field;
	import uk.ac.sussex.model.FieldListProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class FieldsStoreCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var fieldList:Array = incomingData.getParamValue("FieldDetails") as Array;
			trace("FieldsStoreCommand sez: I'm about to stack a load of fields in the list.");
			var fieldListProxy:FieldListProxy = facade.retrieveProxy(FieldListProxy.NAME) as FieldListProxy;
			var gameAssetsLP:GameAssetListProxy = facade.retrieveProxy(GameAssetListProxy.NAME) as GameAssetListProxy;

			for each (var field:Field in fieldList){
				if(field.getCrop()!=null){
					var fullCrop:GameAsset = gameAssetsLP.getGameAsset(field.getCrop().getId());
					field.setCrop(fullCrop);
				}
				if(field.getFertiliser()!=null){
					var fullFertiliser:GameAsset = gameAssetsLP.getGameAsset(field.getFertiliser().getId());
					field.setFertiliser(fullFertiliser);
				}
				fieldListProxy.addField(field);
			}
		}
	}
}
