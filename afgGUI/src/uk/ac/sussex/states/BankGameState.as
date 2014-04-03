package uk.ac.sussex.states {
	import uk.ac.sussex.model.SubMenuListProxy;
	import uk.ac.sussex.controller.SubMenuBankCommand;
	import uk.ac.sussex.serverhandlers.BankHandlers;
	import uk.ac.sussex.view.*;
	import org.puremvc.as3.multicore.interfaces.IFacade;

	/**
	 * @author em97
	 */
	public class BankGameState extends PlayerRoomState implements IGameState {
		public static const NAME:String = "BankGameState";
		public static const LOCATION_NAME:String = "BANK";
		
		public function BankGameState(facade : IFacade) {
			super(facade, NAME);
		}
		override public function displayState():void{
			super.displayState();
			trace("You've reached the Bank Game State");
			this.registerProxies();
			this.registerCommands();
			this.registerMediators();
		}
		override public function cleanUpState():void{
			this.removeCommands();
			this.removeMediators();
			this.removeProxies();
			super.cleanUpState();
		}
		private function registerProxies():void{
			var subMenuProxy:SubMenuListProxy = new SubMenuListProxy();
			facade.registerProxy(subMenuProxy);
			subMenuProxy.addSubMenuItem(BankHandlers.BANK_SUB_MENU_OVERVIEW);
			subMenuProxy.addSubMenuItem(BankHandlers.BANK_SUB_MENU_FINES);
			subMenuProxy.setDefaultMenuItem(BankHandlers.BANK_SUB_MENU_OVERVIEW);
		}
		private function removeProxies():void {
			
		}
		private function registerCommands():void {
			facade.registerCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED, SubMenuBankCommand);
		}
		private function removeCommands():void {
			facade.removeCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED);
		}
		private function registerMediators():void {
			var submenuMediator:SubMenuMediator = new SubMenuMediator();
			facade.registerMediator(submenuMediator);
		
			submenuMediator.moveToDefaultButton();
		}
		private function removeMediators():void {
			facade.removeMediator(SubMenuMediator.NAME);
		}
	}
}
