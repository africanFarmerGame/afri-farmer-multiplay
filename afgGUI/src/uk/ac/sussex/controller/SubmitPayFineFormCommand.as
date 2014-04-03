package uk.ac.sussex.controller {
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.serverhandlers.BankHandlers;
	import uk.ac.sussex.model.valueObjects.Form;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SubmitPayFineFormCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("SubmitPayFineFormCommand sez: Fired!");
			var fineForm:Form = note.getBody() as Form;
			if(fineForm==null){
				throw new Error("The form was null");
			}
			var request:RequestProxy = facade.retrieveProxy(BankHandlers.FINES_PAY + RequestProxy.NAME) as RequestProxy;
			request.setParamValue("FineId", fineForm.getFieldValue(BankHandlers.FINES_ID));
			request.sendRequest();
			sendNotification(ApplicationFacade.SWITCH_SUBMENU_ITEM, BankHandlers.FINES_SUB_MENU_LIST);
		}
	}
}
