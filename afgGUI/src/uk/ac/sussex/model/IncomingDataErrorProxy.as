package uk.ac.sussex.model {
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamString;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.IncomingDataProxy;

	/**
	 * @author em97
	 */
	public class IncomingDataErrorProxy extends IncomingDataProxy {
		public function IncomingDataErrorProxy(incomingName : String) {
			super(incomingName, ApplicationFacade.INCOMING_ERROR_MESSAGE);
			this.addDataParam(new DataParamString("message"));
		}
	}
}
