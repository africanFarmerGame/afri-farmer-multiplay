package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.Diet;
	import uk.ac.sussex.model.DietListProxy;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SaveDietSuccessCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var diet:Diet = incomingData.getParamValue("Diet") as Diet;
			var message:String = incomingData.getParamValue("message") as String;
			trace("SaveDietSuccessCommand sez: The message was " + message + " for dietid " + diet.getId());
			
			var dietListProxy:DietListProxy = facade.retrieveProxy(DietListProxy.NAME) as DietListProxy;
			if(dietListProxy != null){
				dietListProxy.saveDiet(diet);
			} 
		}
	}
}
