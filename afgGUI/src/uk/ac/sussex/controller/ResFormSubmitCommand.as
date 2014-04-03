package uk.ac.sussex.controller {
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.serverhandlers.VillageHandlers;
	import uk.ac.sussex.model.valueObjects.Form;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class ResFormSubmitCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("ResFormSubmitCommand sez: I'm executed");
			var submittedForm:Form = note.getBody() as Form;
			var reqProxy:RequestProxy = facade.retrieveProxy(VillageHandlers.RES_REQUEST+ RequestProxy.NAME) as RequestProxy;
			var resStringId:String = submittedForm.getFieldValue(VillageHandlers.RES_FORM_DEAD);
			var resId:int = int(resStringId);
			if(resId>0){
				reqProxy.setParamValue(VillageHandlers.RES_REQUEST_ID, resId);
				reqProxy.sendRequest();
				submittedForm.resetForm();
				sendNotification(ApplicationFacade.SWITCH_SUBMENU_ITEM, VillageHandlers.SUB_MENU_OVERVIEW);			
			} else {
				sendNotification(ApplicationFacade.DISPLAY_ERROR_MESSAGE, "You need to select a character to resurrect before clicking on the resurrect button.");
			}
		}
	}
}
