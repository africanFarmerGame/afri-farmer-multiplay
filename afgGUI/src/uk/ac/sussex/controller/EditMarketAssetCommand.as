package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArrayMarketAsset;
	import uk.ac.sussex.model.FormProxy;
	import uk.ac.sussex.model.valueObjects.MarketAsset;
	import uk.ac.sussex.serverhandlers.MarketHandlers;
	import uk.ac.sussex.view.FormMediator;
	import uk.ac.sussex.model.MarketAssetsListProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class EditMarketAssetCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var assetID:int = note.getBody() as int;
			trace("EditMarketAssetCommand sez: trying to edit asset id "+ assetID);
			
			var assetListProxy:MarketAssetsListProxy = facade.retrieveProxy(MarketAssetsListProxy.NAME) as MarketAssetsListProxy;
			if(assetListProxy==null){
				throw new Error("The MarketAssetsListProxy is null");
			}
			var asset:MarketAsset = assetListProxy.getAsset(assetID);
			if(asset == null){
				throw new Error("We were unable to find asset " + assetID + " in the MarketAssetsListProxy.");
			}
			var assetFormProxy:FormProxy = facade.retrieveProxy(MarketHandlers.EDIT_ASSET_FORM) as FormProxy;
			if(assetFormProxy==null){
				throw new Error("For some reason the Edit Asset Form was not able to be retrieved.");
			}
			assetFormProxy.updateFieldValue(DataParamArrayMarketAsset.FIELD_ASSETNAME, asset.getAsset().getName());
			assetFormProxy.updateFieldValue(DataParamArrayMarketAsset.FIELD_AMOUNT, asset.getAmount().toString());
			assetFormProxy.updateFieldValue(DataParamArrayMarketAsset.FIELD_BUYPRICE, asset.getBuyPrice().toString());
			assetFormProxy.updateFieldValue(DataParamArrayMarketAsset.FIELD_SELLPRICE, asset.getSellPrice().toString());
			assetFormProxy.updateFieldValue(DataParamArrayMarketAsset.FIELD_ID, asset.getId().toString());
			
			var assetEditFormMediator:FormMediator = facade.retrieveMediator(MarketHandlers.EDIT_ASSET_FORM) as FormMediator;
			assetEditFormMediator.addToViewArea();
		}
	}
}
