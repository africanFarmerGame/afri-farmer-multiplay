package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class AssetAmount {
		private var id: int;
		private var amount:Number;
		private var asset:GameAsset;
		public function getId():int {
			return id;
		}
		public function setId(newId:int):void {
			this.id = newId;
		}
		public function getAsset():GameAsset {
			return this.asset; 
		}
		public function setAsset(newAsset:GameAsset):void {
			this.asset = newAsset;
		}
		public function getAmount():Number {
			return this.amount;
		}
		public function setAmount(newAmount:Number):void {
			this.amount = newAmount;
		}
	}
}
