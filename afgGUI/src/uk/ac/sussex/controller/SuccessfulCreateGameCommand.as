package uk.ac.sussex.controller {
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;

	/**
	 * @author em97
	 */
	public class SuccessfulCreateGameCommand extends MacroCommand {
		override protected function initializeMacroCommand():void {
			addSubCommand( DisplayServerMessageCommand );
			addSubCommand( EnterGameCommand );
		}
	}
}
