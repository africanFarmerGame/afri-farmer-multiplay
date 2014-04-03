package uk.ac.sussex.controller {
	import uk.ac.sussex.serverhandlers.VillageHandlers;
	import uk.ac.sussex.view.SubMenuMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class CancelProposalForm extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("CancelEditTaskForm sez: Fire!");
			var subMenuMediator:SubMenuMediator = facade.retrieveMediator(SubMenuMediator.NAME) as SubMenuMediator;
			subMenuMediator.setCurrentSelection(VillageHandlers.PROP_SUB_MENU_INCOMING);
		}
	}
}
