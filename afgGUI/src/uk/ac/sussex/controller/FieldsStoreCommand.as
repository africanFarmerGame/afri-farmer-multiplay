/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.GameAsset;
	import uk.ac.sussex.model.GameAssetListProxy;
	import uk.ac.sussex.model.valueObjects.Field;
	import uk.ac.sussex.model.FieldListProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class FieldsStoreCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var fieldList:Array = incomingData.getParamValue("FieldDetails") as Array;
			trace("FieldsStoreCommand sez: I'm about to stack a load of fields in the list.");
			var fieldListProxy:FieldListProxy = facade.retrieveProxy(FieldListProxy.NAME) as FieldListProxy;
			var gameAssetsLP:GameAssetListProxy = facade.retrieveProxy(GameAssetListProxy.NAME) as GameAssetListProxy;

			for each (var field:Field in fieldList){
				if(field.getCrop()!=null){
					var fullCrop:GameAsset = gameAssetsLP.getGameAsset(field.getCrop().getId());
					field.setCrop(fullCrop);
				}
				if(field.getFertiliser()!=null){
					var fullFertiliser:GameAsset = gameAssetsLP.getGameAsset(field.getFertiliser().getId());
					field.setFertiliser(fullFertiliser);
				}
				fieldListProxy.addField(field);
			}
		}
	}
}
