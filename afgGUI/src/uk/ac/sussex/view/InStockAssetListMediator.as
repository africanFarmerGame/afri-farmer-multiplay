package uk.ac.sussex.view {
	import uk.ac.sussex.model.valueObjects.GameAsset;
	import uk.ac.sussex.model.MarketAssetsListProxy;
	import uk.ac.sussex.model.valueObjects.MarketAsset;
	import flash.events.Event;
	import uk.ac.sussex.view.components.ListItem;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.view.components.InStockAssetList;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	/**
	 * @author em97
	 */
	public class InStockAssetListMediator extends Mediator implements IMediator {
		public static const NAME:String = "InStockAssetListMediator";
		
		public static const STOCK_ITEM_SELECTED:String = "StockItemSelected";
		
		private static const X_POSITION:Number = 550;
		private static const Y_POSITION:Number = 10;
		
		public function InStockAssetListMediator(viewComponent : Object = null) {
			super(NAME, viewComponent);
		}
		override public function listNotificationInterests():Array {
			return [
					];
		}
		override public function handleNotification (note:INotification):void {
			switch(note.getName()){
				case MarketAssetsListProxy.ASSET_ADDED:
					var newAsset:MarketAsset = note.getBody() as MarketAsset;
					inStockAssetList.addAsset(newAsset);
					break;
				case MarketAssetsListProxy.ASSET_UPDATED:
					var updatedAsset:MarketAsset = note.getBody() as MarketAsset;
					trace("InStockAssetListMediator sez: asset updated got fired. Market asset id: " + updatedAsset.getId());
					break;
			}
		}
		public function showList(show:Boolean):void {
		  if(show){
		    sendNotification(ViewAreaMediator.ADD_VIEW_COMPONENT, inStockAssetList);
		  } else {
		    sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, inStockAssetList);
		  }
		}
		public function setListTitle(newTitle:String):void {
			inStockAssetList.setTitleLabel(newTitle);		
		}
		/**
		 * @param assetList this should be a list of AssetAmount.
		 */
		public function setContents(assetList:Array):void{
			inStockAssetList.addAssets(assetList);
		}
		private function itemClicked(e:Event):void {
			trace("InStockAssetListMediator sez: An item done got clicked.");
			var asset:GameAsset = inStockAssetList.getSelectedAsset();
			
			sendNotification(STOCK_ITEM_SELECTED, asset);
		}
		protected function get inStockAssetList():InStockAssetList {
			return viewComponent as InStockAssetList;
		}
		override public function onRegister():void {
			viewComponent = new InStockAssetList();
			inStockAssetList.x = X_POSITION;
			inStockAssetList.y = Y_POSITION;
			inStockAssetList.addEventListener(ListItem.LIST_ITEM_CLICKED, itemClicked);
			sendNotification(ViewAreaMediator.ADD_VIEW_COMPONENT, inStockAssetList);
		}
		override public function onRemove():void {
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, inStockAssetList);
			inStockAssetList.destroy();
		}
	}
}
