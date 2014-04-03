package uk.ac.sussex.states {
	import org.puremvc.as3.multicore.interfaces.IFacade;

	/**
	 * @author em97
	 */
	public class FarmManagerGameState extends ManagerRoomState implements IGameState {
		public static const NAME:String = "FarmManagerGameState";
		public static const LOCATION_NAME:String = "FARM";
		
		public function FarmManagerGameState(facade : IFacade) {
			super(facade, NAME);
		}
		override public function displayState():void{
			trace("You've reached the Farm Manager Game State");
			super.displayState();
			//add proxies
			//add mediators
			//add commands
		}
		override public function cleanUpState():void{
			//remove proxies
			//remove mediators
			//remove commands
			super.cleanUpState();
		}
	}
}
