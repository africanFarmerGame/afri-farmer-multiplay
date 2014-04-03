package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class HearthMember extends AnyChar {
		private var age:uint;
		
		public function getAge():uint {
			return this.age;
		}
		public function setAge(newAge:uint):void {
			this.age = newAge;
		}
		
	}
}
