package uk.ac.sussex.controller {
	import uk.ac.sussex.model.FinesProxy;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class ReceiveFinesCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("ReceiveFinesCommand sez: I have been triggered");
			var incomingData:IncomingData = note.getBody() as IncomingData;
			if(incomingData == null){
				throw new Error("Command fired with no incoming data");
			}
			var fines:Array = incomingData.getParamValue("Fines") as Array;
			var finesProxy:FinesProxy = facade.retrieveProxy(FinesProxy.NAME) as FinesProxy;
			finesProxy.addFines(fines);
		}
	}
}
