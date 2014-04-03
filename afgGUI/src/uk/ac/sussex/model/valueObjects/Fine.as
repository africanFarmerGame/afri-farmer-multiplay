package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class Fine {
		private var id:int;
		private var payee:int;
		private var description:String;
		private var earlyRate:Number;
		private var lateRate:Number;
		private var season:int;
		private var paid:Boolean;
		public function Fine(){
			
		}
		public function getId():int {
			return this.id;
		}
		public function setId(newId:int):void {
			this.id = newId;
		}
		public function getPayee():int {
			return payee;
		}
		public function setPayee(newPayee:int):void {
			this.payee = newPayee;
		}
		public function getDescription():String {
			return this.description;
		}
		public function setDescription(newDescription:String):void {
			this.description = newDescription;
		}
		public function getEarlyRate():Number {
			return this.earlyRate;
		}
		public function setEarlyRate(newRate:Number):void {
			this.earlyRate = newRate;
		}
		public function getLateRate():Number {
			return this.lateRate;
		}
		public function setLateRate(newRate:Number):void {
			this.lateRate = newRate;
		}
		public function getSeason():int {
			return season;
		}
		public function setSeason(newSeason:int):void{
			this.season = newSeason;
		}
		public function getPaid():Boolean{
			return paid;
		}
		public function setPaid(newPaid:Boolean):void {
			this.paid = newPaid;
		}
	}
}
