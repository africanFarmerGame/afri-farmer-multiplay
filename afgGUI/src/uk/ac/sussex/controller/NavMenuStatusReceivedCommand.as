package uk.ac.sussex.controller {
	import uk.ac.sussex.view.components.NavMenu;
	import uk.ac.sussex.view.NavMenuMediator;
	import uk.ac.sussex.model.valueObjects.ViewStatus;
	import uk.ac.sussex.serverhandlers.RoomHandlers;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class NavMenuStatusReceivedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("NavMenuStatusReceived sez: all fired up");
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var viewStatusArray:Array = incomingData.getParamValue(RoomHandlers.VIEW_DETAILS) as Array;
			var nmm:NavMenuMediator = facade.retrieveMediator(NavMenuMediator.NAME) as NavMenuMediator;
			for each (var vs:ViewStatus in viewStatusArray){
				var stateStatus:String;
				switch (vs.getStatus()){
					case 0:
						stateStatus = NavMenu.BUTTON_STATE_GREEN;
						break;
					case 1:
						stateStatus = NavMenu.BUTTON_STATE_AMBER;
						break;
					case 2: 
						stateStatus = NavMenu.BUTTON_STATE_RED;
						break;
					default:
						stateStatus = NavMenu.BUTTON_STATE_GREEN;
				}
				nmm.setButtonState(vs.getViewName(), stateStatus);
			}
		}
	}
}
