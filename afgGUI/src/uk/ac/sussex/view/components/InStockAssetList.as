package uk.ac.sussex.view.components {
	import uk.ac.sussex.model.valueObjects.AssetAmount;
	import uk.ac.sussex.model.valueObjects.GameAsset;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class InStockAssetList extends MovieClip {
		private var listObject:TitledTwoColumnScrollingList;
		
		public function InStockAssetList() {
			listObject = new TitledTwoColumnScrollingList();
			this.addChild(listObject);
		}
		public function setTitleLabel(newLabel:String):void {
			listObject.setTitleLabel(newLabel);
		}
		public function addAssets(myAssets:Array):void {
			listObject.setSelectedItem(null);
			listObject.clearList();
			for each (var marketAsset:AssetAmount in myAssets){
				addAsset(marketAsset);
			}
		}
		public function addAsset(newAsset:AssetAmount):void {
			var assetItem:InStockAssetListItem = new InStockAssetListItem();
			assetItem.setAsset(newAsset.getAsset());
			var erroritem:Boolean = newAsset.getAmount()<=0;
			assetItem.itemError(erroritem);
			var mouseovertext:String = newAsset.getAsset().getName();
			if(erroritem){
				mouseovertext += " NO STOCK";
			}
			assetItem.setMouseoverText(mouseovertext);
			
			listObject.addItem(assetItem);
		}
		public function getSelectedAsset():GameAsset {
			var currentItem:InStockAssetListItem = listObject.getSelectedListItem() as InStockAssetListItem;
			if(currentItem!=null){
				return currentItem.getAsset() as GameAsset;
			} 
		}
		public function destroy():void {
			listObject.destroy();
		}
	}
}
