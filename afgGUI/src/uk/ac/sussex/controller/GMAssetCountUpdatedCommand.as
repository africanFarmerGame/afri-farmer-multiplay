package uk.ac.sussex.controller {
	import uk.ac.sussex.model.HearthsFinancialStatusProxy;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class GMAssetCountUpdatedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("GMAssetCountUpdatedCommand sez: Here we go, here we go, here we go...");
			var incomingData:IncomingData = note.getBody() as IncomingData;
			if(incomingData==null){
				throw new Error("There was a problem with a lack of incomingdata. ");
			}
			var fsProxy:HearthsFinancialStatusProxy = facade.retrieveProxy(HearthsFinancialStatusProxy.NAME) as HearthsFinancialStatusProxy;
			if(fsProxy != null){
				var hearthId:int = incomingData.getParamValue("HearthId") as int;
				var cashValue:Number = incomingData.getParamValue("HearthCash") as Number;
				var assetValue:Number= incomingData.getParamValue("HearthAssets") as Number;
				fsProxy.updateHouseholdValue(hearthId, cashValue, assetValue);
			}
		}
	}
}
