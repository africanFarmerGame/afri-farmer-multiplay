package uk.ac.sussex.model {
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	import uk.ac.sussex.model.valueObjects.UserData;
	import uk.ac.sussex.model.valueObjects.PlayerChar;
	
	/**
	 * @author em97
	 */
	public class UserProxy extends Proxy implements IProxy {
		public static const NAME:String = "UserProxy";
		public function UserProxy(userName : String) {
			super(userName + NAME, new UserData(userName));
		}
		public function getPlayerChar():PlayerChar{
			return userData.getParamValue("pc") as PlayerChar;
		}
		protected function get userData():UserData {
	 		return data as UserData;
	  	}
	}
}
