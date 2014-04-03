package uk.ac.sussex.model {
  import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import uk.ac.sussex.model.valueObjects.VillageOverview;
	
  public class VillageOverviewProxy extends Proxy implements IProxy { 
    public static const NAME:String = "VillageOverviewProxy";
		
		public function VillageOverviewProxy() {
			super(NAME, new VillageOverview());
		}
    public function storeData(villageName:String, numAdults:int, numChildren:int, households:int):void {
      villageOverview.setName(villageName);
      villageOverview.setNumAdults(numAdults);
      villageOverview.setNumKids(numChildren);
      villageOverview.setHouseholds(households);
    }
    public function getVillageOverview():VillageOverview {
      return villageOverview;
    }
    private function get villageOverview():VillageOverview{
      return data as VillageOverview;
    }
  }
}