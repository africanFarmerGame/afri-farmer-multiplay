package uk.ac.sussex.model.valueObjects {
	import uk.ac.sussex.model.valueObjects.requestParams.*;
	
	/**
	 * @author em97
	 */
	public class UserData {
		private var userName:String;
		private var myParams:Array;
		
		public function UserData(userName:String) {
			this.userName = userName;
			this.myParams = new Array();
			this.addUserParam(new DataParamPlayerChar("pc"));
		}
		
		public function getParamValue(paramName:String){
			var param:DataParam = this.myParams[paramName] as DataParam;
			
			if(param != null){
				return param.getParamValue();
			}
		}
		/** 
		 * Unlike the other data commands, the structure of a user shouldn't change on the fly.
		 * So I'm making this function private to the class, and we'll set up the fields in the constructor. 
		 */
		private function addUserParam(userParam:DataParam):void {
			var paramName:String = userParam.getParamName();
			if(myParams[paramName]==null){
				myParams[paramName] = userParam;
			}
		}
	}
}
