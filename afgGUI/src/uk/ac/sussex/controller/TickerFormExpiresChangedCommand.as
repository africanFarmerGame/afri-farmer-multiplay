package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.Form;
	import uk.ac.sussex.model.FormProxy;
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import uk.ac.sussex.model.valueObjects.FormField;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class TickerFormExpiresChangedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var expiresField:FormField = note.getBody() as FormField;
			if(expiresField==null){
				throw new Error("TickerFormExpiresChangedCommand ERROR: The note body was null");
			}
			var tickerFormProxy:FormProxy = facade.retrieveProxy(HomeHandlers.SEND_TICKER_FORM) as FormProxy;
			var tickerForm:Form = tickerFormProxy.getForm();
			var enabled:Boolean = (expiresField.getFieldValue()!="0");
			tickerForm.setFieldEnabled(HomeHandlers.TICKER_DURATION, enabled);
			tickerForm.setFieldEnabled(HomeHandlers.TICKER_DURATION_UNIT, enabled);
		}
	}
}
