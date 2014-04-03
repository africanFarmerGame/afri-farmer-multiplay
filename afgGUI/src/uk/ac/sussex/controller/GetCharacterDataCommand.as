package uk.ac.sussex.controller {
	import org.puremvc.as3.multicore.interfaces.*;
	import org.puremvc.as3.multicore.patterns.command.*;

	import uk.ac.sussex.model.RequestProxy;
	/**
	 * @author em97
	 */
	public class GetCharacterDataCommand extends SimpleCommand {
		override public function execute(note:INotification): void{
			//Worth a generic get all pc data here? Possibly. 
			var getPlayerCharRequest:RequestProxy = new RequestProxy("player.char_detail");
			facade.registerProxy(getPlayerCharRequest);
			
			getPlayerCharRequest.sendRequest();		
		}

	}
}
