package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class DietItem {
		private var id:int;
		private var diet:Diet;
		private var asset:GameAssetFood;
		private var assetId:int;
		private var amount:int;
		
		public function getId():int {
			return id;
		}
		public function setId(newId:int):void {
			this.id = newId;
		}
		public function getDiet():Diet {
			return diet;
		}
		public function setDiet(newDiet:Diet):void {
			this.diet = newDiet;
		}
		public function getAssetId():int {
			return assetId;
		}
		public function setAssetId(newAssetId:int):void {
			this.assetId = newAssetId;
		}
		public function getAsset():GameAssetFood {
			return asset;
		}
		public function setAsset(newAsset:GameAssetFood):void {
			this.asset = newAsset;
			this.setAssetId(newAsset.getId());
		}
		public function getAmount():int {
			return amount;
		}
		public function setAmount(newAmount:int):void {
			this.amount = newAmount;
		}
		public static function sortOnAssetId(aDI:DietItem, bDI:DietItem):int{
			var aId:int = aDI.getAssetId();
			var bId:int = bDI.getAssetId();
			if (aId < bId) return -1;
    		if (aId == bId) return 0;
    		if (aId > bId) return 1;
		}
		public function getCopy():DietItem {
			var item:DietItem =  new DietItem;
			item.setAmount(this.getAmount());
			if(this.asset != null){
				item.setAsset(this.getAsset());
			} else {
				item.setAssetId(this.getAssetId());
			}
			item.setDiet(this.getDiet());
			return item;			
		}
	}
}
