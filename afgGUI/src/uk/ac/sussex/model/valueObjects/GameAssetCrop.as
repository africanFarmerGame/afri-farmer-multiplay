/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
