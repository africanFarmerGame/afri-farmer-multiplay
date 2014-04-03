package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class Weather {
		private var name:String;
		private var season:int;
		
		public function Weather(name:String, season:int):void{
			this.name = name;
			this.season = season;
		}
		public function getName():String {
			return this.name;
		}
		public function getSeason():int {
			return this.season;
		}
	}
}
