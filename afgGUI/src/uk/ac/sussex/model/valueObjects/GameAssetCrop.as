package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class GameAssetCrop extends GameAsset {
		private var epYield:int;
		private var lpYield:int;
		private var outputAsset:GameAsset;
		private var maturity:int;
		public function GameAssetCrop() {
			super();
		}
		public function getEPYield():int {
			return epYield;
		}
		public function setEPYield(newYield:int):void {
			this.epYield = newYield;
		}
		public function getLPYield():int {
			return lpYield;
		}
		public function setLPYield(newYield:int):void {
			this.lpYield = newYield;
		}
		public function getOutputAsset():GameAsset{
			return this.outputAsset;
		}
		public function setOutputAsset(newOutputAsset:GameAsset):void {
			this.outputAsset = newOutputAsset;
		}
		public function getMaturity():int {
			return this.maturity;
		}
		public function setMaturity(newMaturity:int):void {
			 this.maturity = newMaturity;
		}
	}
}
