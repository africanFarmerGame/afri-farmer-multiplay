package uk.ac.sussex.model {
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	import uk.ac.sussex.model.valueObjects.PlayerChar;
	/**
	 * @author em97
	 */
	public class PCListProxy extends Proxy implements IProxy {
		
		public static const PLAYER_LIST_UPDATED:String = "PClistUpdated";
		
		public function PCListProxy(listName : String = null) {
			super(listName, new Array());
		}
		public function addManyPCs(addPCList:Array):void {
			if(addPCList != null) {
				for each (var pc:PlayerChar in addPCList){
					
					if(pc == null ){trace ("something's wrong with the pc list!");}
					pcList.push(pc);
				}
				
				sendNotification(PLAYER_LIST_UPDATED, this.proxyName);
			}
		}
		public function addPC(pc:PlayerChar):void{
			pcList.push(pc);
			
			sendNotification(PLAYER_LIST_UPDATED, this.proxyName);
		}
		public function removePC(pc:PlayerChar):void{
			trace("PCListProxy (" + this.proxyName + ") sez: PC " + pc.getFirstName() + " to be removed");
			trace("PCListProxy (" + this.proxyName + ") sez: list length pre " + pcList.length);
			var searchId:uint = pc.getId();
			var currentIndex:uint = 0;
			for each (var item:PlayerChar in pcList){
				if(item.getId() == searchId){
					pcList.splice(currentIndex, 1);
					break;
				}
				currentIndex ++;
			}
			sendNotification(PLAYER_LIST_UPDATED, this.proxyName);
		}
		public function clearPCList():void{
			data = new Array();
			sendNotification(PLAYER_LIST_UPDATED, this.proxyName);
		}
		public function getPC(pcId:int):PlayerChar {
			for each (var pc:PlayerChar in pcList){
				if(pc.getId()==pcId){
					return pc;
				}
			}
			return null;
		}
		/**
		 * I'm keeping this as a separate function to the get pcList, in case I want to do something with it later. 
		 */
		public function getPCList():Array {
			return pcList;
		}
		protected function get pcList():Array {
			return data as Array;
		}
	}
}
