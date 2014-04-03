package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class HearthAsset extends AssetAmount {
		private var owner:String = "H";
		private var sellOptions:Array;
		public static const OWNER_HEARTH:String = "H";
		public static const OWNER_PC:String = "P";
		
		public function getOwner():String {
			return owner;
		}
		public function setOwner(newOwner:String):void{
			owner = newOwner;
		}
		public function setSellOptions(newSellOptions:Array):void {
			this.sellOptions = newSellOptions;
		}
		public function getSellOptions():Array{
			return this.sellOptions;
		}
	}
}
