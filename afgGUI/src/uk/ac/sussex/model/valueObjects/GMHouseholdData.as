package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class GMHouseholdData {
		private var hearthId:int;
		private var pendingTaskCount:int;
		private var aDiets:int;
		private var bDiets:int;
		private var cDiets:int;
		private var xDiets:int;
		private var enoughFood:Boolean;
		
		public function GMHouseholdData(){
			
		}
		public function getHearthId():int{
			return hearthId;
		}
		public function setHearthId(newId:int):void {
			this.hearthId = newId;
		}
		public function getPendingTaskCount():int{
			return pendingTaskCount;
		}
		public function setPendingTaskCount(pendingCount:int):void {
			this.pendingTaskCount = pendingCount;
		}
		public function getADiets():int{
			return aDiets;
		}
		public function setADiets(numDiets:int):void {
			this.aDiets = numDiets;
		}
		public function getBDiets():int{
			return bDiets;
		}
		public function setBDiets(numDiets:int):void {
			this.bDiets = numDiets;
		}
		public function getCDiets():int{
			return cDiets;
		}
		public function setCDiets(numDiets:int):void {
			this.cDiets = numDiets;
		}
		public function getXDiets():int{
			return xDiets;
		}
		public function setXDiets(numDiets:int):void {
			this.xDiets = numDiets;
		}
		public function getEnoughFood():Boolean {
			return enoughFood;
		}
		public function setEnoughFood(enough:Boolean):void {
			this.enoughFood = enough;
		}
		public function toString():String{
			return "GMHouseholdData: hearthId " + hearthId + " tasks " + pendingTaskCount + " aDiets " + aDiets + " bDiets " + bDiets + " cDiets " + cDiets + " xDiets " + xDiets + " enough " + enoughFood.toString(); 
		}
	}
}
