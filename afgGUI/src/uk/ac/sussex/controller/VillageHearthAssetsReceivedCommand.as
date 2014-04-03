package uk.ac.sussex.controller {
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class VillageHearthAssetsReceivedCommand extends SimpleCommand {
		override public function execute( note:INotification ):void {
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var numAdults:int = incomingData.getParamValue("NumberAdults") as int;
			var numChildren:int = incomingData.getParamValue("NumberChildren") as int;
			//var socialStatus:Number = incomingData.getParamValue("SocialStatus") as Number;
			var numFields:int = incomingData.getParamValue("NumberFields") as int;
			var hearthName:String = incomingData.getParamValue("HearthName") as String;
			
			var outputString:String = hearthName + "\n\n";
			outputString += "Adults: " + numAdults + "\n\n";
			outputString += "Children: " + numChildren + "\n\n";
			outputString += "Fields: " + numFields + "\n\n";
			//outputString += "Social Status: " + socialStatus;
			
			sendNotification(ApplicationFacade.DISPLAY_TEMP_INFO_TEXT, outputString);
		}
	}
}
