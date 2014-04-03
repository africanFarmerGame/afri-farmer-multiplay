/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects.requestParams {
	import uk.ac.sussex.model.valueObjects.SeasonStage;
	import com.smartfoxserver.v2.entities.data.ISFSArray;
	import uk.ac.sussex.model.valueObjects.Season;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import com.smartfoxserver.v2.entities.data.SFSObject;

	/**
	 * @author em97
	 */
	public class DataParamArraySeasons extends DataParamArray {
		public function DataParamArraySeasons(paramName : String) {
			super(paramName);
		}
		override public function addToServerParam(existingObject:SFSObject):SFSObject {
			var localArray:Array = this.getParamValue() as Array;
			var sfsArray:SFSArray = new SFSArray();
			for each (var item:Season in localArray) {
				var sfsObj:SFSObject = new SFSObject();
				sfsObj.putInt("DisplayOrder", item.getDisplayOrder());
				sfsObj.putUtfString("Name", item.getName());
				sfsArray.addSFSObject(sfsObj);
			}
			existingObject.putSFSArray(this.getParamName(), sfsArray);
			return existingObject;
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var sfsArray:SFSArray = existingObject.getSFSArray(this.getParamName()) as SFSArray;
			if(sfsArray != null){
				var sfsSize:int = sfsArray.size();
				var myValue:Array = new Array();
				
				for (var i:int = 0; i < sfsSize; i++) {
					var season:Season = new Season();
					var seasonSFSObj:SFSObject = sfsArray.getSFSObject(i) as SFSObject;
					season.setName(seasonSFSObj.getUtfString("SeasonName"));
					season.setDisplayOrder(seasonSFSObj.getInt("DisplayOrder"));
					var seasonStages:Array = new Array();
					var seasonStagesObj:ISFSArray = seasonSFSObj.getSFSArray("SeasonStages");
					var stagesSize:int = seasonStagesObj.size();
					trace("DataParamArraySeason sez: This object has " + stagesSize + " stages");
					for (var stageCounter:int = 0; stageCounter < stagesSize; stageCounter ++){
						var stage:SeasonStage = new SeasonStage();
						var stageObj:SFSObject = seasonStagesObj.getSFSObject(stageCounter) as SFSObject;
						stage.setName(stageObj.getUtfString("StageName"));
						stage.setDisplayOrder(stageObj.getInt("DisplayOrder"));
						seasonStages.push(stage);
					}
					season.setStages(seasonStages);
					myValue.push(season);
				}
			}
			this.setParamValue(myValue);
			return existingObject;
		}
	}
}
