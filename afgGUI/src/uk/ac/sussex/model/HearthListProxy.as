package uk.ac.sussex.model {
	import uk.ac.sussex.model.valueObjects.Hearth;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	/**
	 * @author em97
	 */
	public class HearthListProxy extends Proxy implements IProxy {
		public static const NAME:String = "HearthListProxy";
		public static const HEARTH_ADDED:String = "HearthAdded";
		public function HearthListProxy() {
			super(NAME, new Array());
		}
		public function addHearth(newHearth:Hearth):void {
			var newHearthId:int = newHearth.getId();
			var found:Boolean = false;
			for each (var hearth:Hearth in hearthlist){
				if(hearth.getId()==newHearthId){
					found = true;
					hearth.setHearthName(newHearth.getHearthName());
					hearth.setNumAdults(newHearth.getNumAdults());
					hearth.setNumChildren(newHearth.getNumChildren());
					hearth.setNumFields(newHearth.getNumFields());
				}
			}
			if(!found){
				hearthlist.push(newHearth);
			}
			sendNotification(HEARTH_ADDED, newHearth);
		}
		public function getHearthIds():Array{
			var idList:Array = new Array();
			for each (var hearth:Hearth in hearthlist){
				idList.push(hearth.getId());
			}
			return idList;
		}
		public function getHearthById(hearthId:int):Hearth{
			for each (var hearth:Hearth in hearthlist){
				if(hearth.getId() == hearthId){
					return hearth;
				}
			}
			return null;
		}
		public function getHearthCount():int {
			return this.hearthlist.length;
		}
		public function getHearths():Array {
			return hearthlist.sort(sortOnHearthNumber);
		}
		protected function get hearthlist():Array{
			return data as Array;
		}
		private function sortOnHearthNumber(a:Hearth, b:Hearth):int {
			var aNumber:int = a.getHouseNumber();
			var bNumber:int = b.getHouseNumber();
			if(aNumber>bNumber){
				return 1;
			} else if (aNumber<bNumber){
				return -1;
			} else {
				return 0;
			}
		}
	}
}
