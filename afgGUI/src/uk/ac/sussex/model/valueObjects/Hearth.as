package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class Hearth {
		private var id:int;
		private var hearthName:String;
		private var houseNumber:int;
		private var numFields:int;
		private var numAdults:int;
		private var numChildren:int;
		
		public function Hearth(){
			
		}
		public function getId():int {
			return id;
		}
		public function setId(newId:int):void {
			this.id = newId;
		}
		public function getHearthName():String {
			return this.hearthName;
		}
		public function setHearthName(newHearthName:String):void {
			this.hearthName = newHearthName;
		}
		public function getHouseNumber():int {
			return this.houseNumber;
		}
		public function setHouseNumber(newNumber:int):void {
			this.houseNumber = newNumber;
		}
		public function getNumFields():int {
			return this.numFields;
		}
		public function setNumFields(numFields:int):void {
			this.numFields = numFields;
		}
		public function getNumAdults():int {
			return this.numAdults;
		}
		public function setNumAdults(numAdults:int):void {
			this.numAdults = numAdults;
		}
		public function getNumChildren():int {
			return this.numChildren;
		}
		public function setNumChildren(numChildren:int):void {
			this.numChildren = numChildren;
		}
	}
}
