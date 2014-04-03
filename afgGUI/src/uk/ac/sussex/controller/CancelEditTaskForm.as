package uk.ac.sussex.controller {
	import uk.ac.sussex.view.SubMenuMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class CancelEditTaskForm extends SimpleCommand {
		override public function execute(note:INotification):void {
			var subMenuMediator:SubMenuMediator = facade.retrieveMediator(SubMenuMediator.NAME) as SubMenuMediator;
			subMenuMediator.moveToDefaultButton();
		}
	}
}
