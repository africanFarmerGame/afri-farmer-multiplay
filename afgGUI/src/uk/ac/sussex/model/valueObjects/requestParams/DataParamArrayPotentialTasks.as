/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects.requestParams {
	import uk.ac.sussex.model.valueObjects.FormFieldOption;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.ISFSArray;
	import uk.ac.sussex.model.valueObjects.PotentialTask;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArray;

	/**
	 * @author em97
	 */
	public class DataParamArrayPotentialTasks extends DataParamArray {
		public function DataParamArrayPotentialTasks(paramName : String) {
			super(paramName);
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var sfsArray:SFSArray = existingObject.getSFSArray(this.getParamName()) as SFSArray;
			if(sfsArray != null){
				var sfsSize:int = sfsArray.size();
				var myValue:Array = new Array();
				
				for (var i:int = 0; i < sfsSize; i++) {
					var task:PotentialTask = new PotentialTask();
					var taskSFSObj:SFSObject = sfsArray.getSFSObject(i) as SFSObject;
					
					task.setName(taskSFSObj.getUtfString("DisplayName"));
					task.setType(taskSFSObj.getUtfString("Type"));
					var assetsArray:ISFSArray = taskSFSObj.getSFSArray("Assets");
					if(assetsArray != null){
						var assets:Array = new Array();
						var assetsSize:int = assetsArray.size();
						var counter:int;
						for (counter = 0; counter < assetsSize; counter++){
							var assetTO:FormFieldOption = this.translateTaskOptionFromServerParam(assetsArray.getSFSObject(counter));
							assets.push(assetTO);
						}
						task.setAssets(assets);
					}
					
					var locationsArray:ISFSArray = taskSFSObj.getSFSArray("Locations");
					if(locationsArray!=null){
						var locations:Array = new Array();
						var locationsSize:int = locationsArray.size();
						for(counter=0; counter<locationsSize; counter++){
							var locTO:FormFieldOption = this.translateTaskOptionFromServerParam(locationsArray.getSFSObject(counter));
							locations.push(locTO);
						}
						task.setLocations(locations);
					}
					
					var actorsArray:ISFSArray = taskSFSObj.getSFSArray("Actors");
					if(actorsArray != null){
						var actors:Array = new Array();
						var actorsSize:int = actorsArray.size();
						for(counter=0; counter<actorsSize; counter++){
							var actorTO:FormFieldOption = this.translateTaskOptionFromServerParam(actorsArray.getSFSObject(counter));
							actors.push(actorTO);
						}
						task.setActors(actors);
					}
					myValue.push(task);
				}
			}
			this.setParamValue(myValue);
			return existingObject;
		}
		private function translateTaskOptionFromServerParam(toObj:ISFSObject):FormFieldOption{
			var value:int = toObj.getInt("Value");
			var displayName:String = toObj.getUtfString("Name");
			var ffo:FormFieldOption = new FormFieldOption(displayName, value.toString());
			ffo.setType(toObj.getUtfString("Type"));
			ffo.setStatus(toObj.getInt("Status"));
			ffo.setNotes(toObj.getUtfString("Notes"));
			return ffo;
		}
	}
}
