package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class FinancialStatus {
		private var hearthId:int;
		private var hearthName:String;
		private var assetWorth:Number;
		private var cashWorth:Number;
		private var unpaidBills:int;
		
		public function getHearthId():int{
			return hearthId;
		}
		public function setHearthId(newId:int):void{
			this.hearthId = newId;
		}
		public function getHearthName():String{
			return hearthName;
		}
		public function setHearthName(newName:String):void {
			this.hearthName = newName;
		}
		public function getCashValue():Number{
			return cashWorth;
		}
		public function setCashValue(newValue:Number):void {
			this.cashWorth = newValue;
		}
		public function getAssetValue():Number {
			return this.assetWorth;
		}
		public function setAssetWorth(newValue:Number):void {
			this.assetWorth = newValue;
		}
		public function getUnpaidBills():int{
			return unpaidBills;
		}
		public function setUnpaidBills(unpaid:int):void{
			this.unpaidBills = unpaid;
		}
	}
}
