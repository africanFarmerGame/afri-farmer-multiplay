package uk.ac.sussex.controller {
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.serverhandlers.MarketHandlers;
	import uk.ac.sussex.model.valueObjects.Form;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SubmitBuyFormCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var buyForm:Form = note.getBody() as Form;
			trace("SubmitBuyFormCommand sez: Form " + buyForm.getName() + " has been submitted");
			if(buyForm.getName()==MarketHandlers.BUY_FORM){
				var quantity:String = buyForm.getFieldValue(MarketHandlers.BUY_SELL_QTY);
				var asset:String = buyForm.getFieldValue(MarketHandlers.BUY_SELL_ASSETID);
				if(asset==null||asset==""){
					sendNotification(ApplicationFacade.DISPLAY_ERROR_MESSAGE, "You have not selected an asset to sell.");
				} else if(quantity==null||quantity==""){
					sendNotification(ApplicationFacade.DISPLAY_ERROR_MESSAGE, "You have not set a quantity to buy.");
				} else {
					var request:RequestProxy = facade.retrieveProxy(MarketHandlers.SUBMIT_BUY_REQUEST + RequestProxy.NAME) as RequestProxy;
					request.setParamValue("AssetId", asset);
					request.setParamValue("Quantity", quantity);
					var assetOwner:String = buyForm.getFieldValue(MarketHandlers.BUY_SELL_HOUSEHOLD_PERSONAL);
					if(assetOwner == null || assetOwner == ""){
						assetOwner = "H";
					}
					request.setParamValue("Owner", assetOwner);
					request.sendRequest();
					buyForm.resetForm();
					sendNotification(ApplicationFacade.SWITCH_SUBMENU_ITEM, MarketHandlers.SUB_MENU_STOCKS);
					sendNotification(ApplicationFacade.DISPLAY_MESSAGE, "Your purchase request has been submitted.");
				}
			}
		}
	}
}