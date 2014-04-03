/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model {
	import uk.ac.sussex.model.valueObjects.SubMenuItem;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.interfaces.IProxy;

	/**
	 * @author em97
	 */
	public class SubMenuListProxy extends Proxy implements IProxy {
		public static const NAME:String = "SubMenuListProxy";
		
		public function SubMenuListProxy() {
			super(NAME, null);
		}
		public function addSubMenuItem(displayName:String, displayStages:Array = null):void {
			var ordernumber:int = subMenuList.length;
			var menuItem:SubMenuItem = new SubMenuItem(ordernumber, displayName, displayStages);
			subMenuList.push(menuItem);
		}
		public function fetchDisplaySubMenuItems(stageName:String):Array {
			var displayArray:Array = new Array();
			for each (var menuItem:SubMenuItem in subMenuList) {
				if(menuItem.displayThisButton(stageName)){
					displayArray.push(menuItem);
				}
			}
			return displayArray.sort(sortOnOrder);
		}
		public function setDefaultMenuItem(displayName:String):void{
			for each (var menuItem:SubMenuItem in subMenuList){
				menuItem.setMenuDefault(menuItem.getDisplayName()==displayName);
			}
		}
		public function getDefaultMenuItem():SubMenuItem {
			for each(var menuItem:SubMenuItem in subMenuList){
				if(menuItem.getMenuDefault()){
					return menuItem;
				}
			}
		}
		private function sortOnOrder(a:SubMenuItem, b:SubMenuItem):int{
			var aOrder:int = a.getButtonOrder();
			var bOrder:int = b.getButtonOrder();
			if(aOrder<bOrder){
				return -1;
			} else if (aOrder>bOrder) {
				return 1;
			} else {
				return 0;
			}	
		}
		protected function get subMenuList():Array{
			return data as Array;
		}
		override public function onRegister():void {
			trace("SubMenuListProxy sez: I am registered");
			data = new Array();
		}
	}
}
