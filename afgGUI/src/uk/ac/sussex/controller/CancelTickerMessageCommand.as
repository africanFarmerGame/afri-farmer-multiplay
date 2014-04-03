package uk.ac.sussex.controller {
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class CancelTickerMessageCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("CancelTickerMessageCommand sez: I has been fired. " + note.getName());
		}
	}
}
