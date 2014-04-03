package uk.ac.sussex.controller {
	import org.puremvc.as3.multicore.interfaces.INotification;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import uk.ac.sussex.general.ApplicationFacade;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class AfriVillageHearthAssetsReceivedCommand extends SimpleCommand {
		override public function execute( note:INotification ):void {
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var numAdults:int = incomingData.getParamValue("NumberAdults") as int;
			var numChildren:int = incomingData.getParamValue("NumberChildren") as int;
			//var socialStatus:Number = incomingData.getParamValue("SocialStatus") as Number;
			var numFields:int = incomingData.getParamValue("NumberFields") as int;
			var hearthName:String = incomingData.getParamValue("HearthName") as String;
			var hearthHeads:Array = incomingData.getParamValue("HearthHeads") as Array;
			
			var outputString:String = hearthName + "\n";
			if(hearthHeads.length>0){
				outputString += "\nHeads of Household:\n";
				for each (var hearthHead:String in hearthHeads){
					outputString += "   " + hearthHead + "\n";
				}
			}
			
			outputString += "\nAdults: " + numAdults + "\n\n";
			outputString += "Children: " + numChildren + "\n\n";
			outputString += "Fields: " + numFields + "\n\n";
			//outputString += "Social Status: " + socialStatus;
			
			sendNotification(ApplicationFacade.DISPLAY_TEMP_INFO_TEXT, outputString);
		}
	}
}
