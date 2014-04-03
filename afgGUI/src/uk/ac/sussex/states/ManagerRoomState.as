package uk.ac.sussex.states {
	import org.puremvc.as3.multicore.interfaces.IFacade;
	
	/**
	 * @author em97
	 */
	public class ManagerRoomState extends InGameState implements IGameState {
		
		public function ManagerRoomState(facade:IFacade, name:String){
			super(facade, name);
		}
		override public function displayState() : void {
			super.displayState();

			//Register Proxies
				
			//Register Mediators
						
			//Register Commands
		}

		override public function cleanUpState() : void {
			super.cleanUpState();
			//remove proxies
			//remove mediators
			//remove commands

		}

	}
}
