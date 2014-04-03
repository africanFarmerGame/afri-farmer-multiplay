package uk.ac.sussex.view {
	import uk.ac.sussex.model.valueObjects.SeasonStage;
	import uk.ac.sussex.model.valueObjects.SubMenuItem;
	import uk.ac.sussex.model.SubMenuListProxy;
	import uk.ac.sussex.model.SeasonsListProxy;
	import flash.events.Event;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.view.components.SubMenu;
	import org.puremvc.as3.multicore.interfaces.*;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	/**
	 * @author em97
	 */
	public class SubMenuMediator extends Mediator implements IMediator {
		public static const NAME:String = "SubMenuMediator";
		public static const SUB_MENU_ITEM_SELECTED:String = "SubMenuItemSelected";
		
		private var subMenuProxy:SubMenuListProxy;
		
		public function SubMenuMediator(viewComponent : Object = null) {
			super(NAME, viewComponent);
		}
		override public function listNotificationInterests():Array {
			return [ApplicationFacade.SWITCH_SUBMENU_ITEM, 
					SeasonsListProxy.CURRENT_STAGE_UPDATED
					];
		}
		override public function handleNotification (note:INotification):void {
			switch (note.getName()){
				case ApplicationFacade.SWITCH_SUBMENU_ITEM:
					var menuItemName:String = note.getBody() as String;
					this.setCurrentSelection(menuItemName);
					break;	
				case SeasonsListProxy.CURRENT_STAGE_UPDATED:
					submenu.clearSubMenu();
					this.displaySubMenuItems();
					this.moveToDefaultButton();
					break;
			}
		}
		public function moveToDefaultButton():void {
			var defaultItem:SubMenuItem = subMenuProxy.getDefaultMenuItem();
			this.setCurrentSelection(defaultItem.getDisplayName());	
		}
		public function setCurrentSelection(buttonName:String):void {
			submenu.setSelected(buttonName);
			sendNotification(SUB_MENU_ITEM_SELECTED, submenu.getSelected());	
		}
		public function getCurrentSelection():String{
			return submenu.getSelected();
		}
		public function getSubmenuWidth():Number {
			return submenu.getScreenWidth();
		}
		private function buttonClicked(e:Event):void {
			sendNotification(SUB_MENU_ITEM_SELECTED, submenu.getSelected());
		}
		private function displaySubMenuItems():void {
				
			if(subMenuProxy==null){
				subMenuProxy = facade.retrieveProxy(SubMenuListProxy.NAME) as SubMenuListProxy;
			}
			if(subMenuProxy!=null){
				var stageName:String = ""; 
				var seasonsListProxy:SeasonsListProxy = facade.retrieveProxy(SeasonsListProxy.NAME) as SeasonsListProxy;
			
				if(seasonsListProxy!=null){
					var thisStage:SeasonStage = seasonsListProxy.getCurrentStage();
					if(thisStage!=null){
						stageName = thisStage.getName();
					}
				}
				var displayItems:Array = subMenuProxy.fetchDisplaySubMenuItems(stageName);
				for each (var displayItem:SubMenuItem in displayItems){
					submenu.addButton(displayItem.getDisplayName());
				}
			}
		}
		
		//Cast the viewComponent to the correct type.
		protected function get submenu():SubMenu {
			return viewComponent as SubMenu;
		}
		override public function onRegister():void
		{
			viewComponent = new SubMenu();
			submenu.addEventListener(SubMenu.BUTTON_CLICKED, buttonClicked);
			var appMediator:ApplicationMediator = facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;
			displaySubMenuItems();
			submenu.y = appMediator.getTopHeight();
			sendNotification(ApplicationFacade.ADD_TO_CONTROLS, submenu);
		}
		override public function onRemove():void
		{
			submenu.removeEventListener(SubMenu.BUTTON_CLICKED, buttonClicked);
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, submenu);
		}
	}
}
