package uk.ac.sussex.controller {
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.PlayerCharProxy;
	import uk.ac.sussex.serverhandlers.FarmHandlers;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.model.valueObjects.Form;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SubmitTaskCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var taskform:Form = note.getBody() as Form;
			if(taskform==null){
				throw new Error("SubmitTaskCommand sez: Numpty, you've forgotten what a form submits.");
			}
			var actorId:int = int(taskform.getFieldValue(FarmHandlers.TASK_ACTOR));
			var locId:int = int(taskform.getFieldValue(FarmHandlers.TASK_LOCATION));
			var assetId:int = int(taskform.getFieldValue(FarmHandlers.TASK_ASSET));
			var type:String = taskform.getFieldValue(FarmHandlers.TASK_TYPE);
			//I'm going to need to add a hidden task id field I think. Fair enough. 
			trace("SubmitTaskCommand sez: We have a task of type " + type + " using asset " + assetId);
			var myChar:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;  
			var saveTaskProxy:RequestProxy = facade.retrieveProxy(FarmHandlers.TASK_SAVE + RequestProxy.NAME) as RequestProxy;
			saveTaskProxy.setParamValue(FarmHandlers.TASK_ID, taskform.getFieldValue(FarmHandlers.TASK_ID));
			saveTaskProxy.setParamValue(FarmHandlers.TASK_ACTOR, actorId);
			saveTaskProxy.setParamValue(FarmHandlers.TASK_LOCATION, locId);
			saveTaskProxy.setParamValue(FarmHandlers.TASK_ASSET, assetId);
			saveTaskProxy.setParamValue(FarmHandlers.TASK_TYPE, type);
			saveTaskProxy.setParamValue(FarmHandlers.TASK_HEARTH, myChar.getPCHearthId());
			saveTaskProxy.sendRequest();
			
			sendNotification(ApplicationFacade.SWITCH_SUBMENU_ITEM, FarmHandlers.TASK_SUB_MENU_LIST);
			
		}
	}
}
