package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class PotentialTask {
		private var name:String;
		private var locations:Array;
		private var actors:Array;
		private var assets:Array;
		private var type:String;
		public function PotentialTask(){
			
		}
		public function getName():String {
			return name;
		}
		public function setName(newName:String):void {
			this.name = newName;
		}
		public function getLocations():Array {
			return this.locations;
		}
		public function setLocations(newLocations:Array):void {
			this.locations = newLocations.sort(sortOptions);
		}
		public function getActors():Array {
			return this.actors;
		}
		public function setActors(newActors:Array):void {
			this.actors = newActors.sort(sortOptions);
		}
		public function getAssets():Array {
			return this.assets;
		}
		public function setAssets(newAssets:Array):void {
			this.assets = newAssets.sort(sortOptions);
		}
		public function getType():String {
			return type;
		}
		public function setType(newType:String):void {
			this.type = newType;
		}
		private function sortOptions(a:FormFieldOption, b:FormFieldOption):int{
			var aName:String = a.getDisplayName();
			var bName:String = b.getDisplayName();
			if(aName>bName){
				return 1;
			} else if (aName<bName){
				return -1;
			} else {
				return 0;
			}
		}
	}
}
