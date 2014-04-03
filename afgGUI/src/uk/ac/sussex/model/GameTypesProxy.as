package uk.ac.sussex.model {
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.interfaces.IProxy;

	/**
	 * @author em97
	 */
	public class GameTypesProxy extends Proxy implements IProxy {
		public static const NAME:String = "GameTypesProxy";
		
		public function GameTypesProxy() {
			super(NAME, null);
		}
		public function storeGameTypes(gameTypes:Array):void {
			
		}
		public function getGameTypes():Array {
			return gameTypes;
		}
		override public function onRegister():void{
			data = new Array();
		}
		protected function get gameTypes():Array{
			return data as Array;
		}
	}
}
