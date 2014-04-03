package uk.ac.sussex.states {
	import uk.ac.sussex.model.SubMenuListProxy;
	import uk.ac.sussex.serverhandlers.ManagerHandlers;
	import uk.ac.sussex.view.FinesGMOverviewListMediator;
	import uk.ac.sussex.model.FinesProxy;
	import uk.ac.sussex.controller.ReceiveFinesCommand;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArrayFines;
	import uk.ac.sussex.model.IncomingDataProxy;
	import uk.ac.sussex.model.IncomingDataErrorProxy;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.controller.SubMenuFinesManagerCommands;
	import uk.ac.sussex.serverhandlers.BankHandlers;
	import uk.ac.sussex.view.SubMenuMediator;
	import org.puremvc.as3.multicore.interfaces.IFacade;

	/**
	 * @author em97
	 */
	public class FinesManagerGameState extends NavFreeGameState implements IGameState {
		public static const NAME:String = "FinesManagerGameState";
		public static const LOCATION_NAME:String = "Bills";
		
		public function FinesManagerGameState(facade : IFacade) {
			super(facade, NAME, LOCATION_NAME);
		}
		override public function displayState():void{
			trace("FinesManagerGameState sez: You've reached the Fines Manager Game State");
			
			super.displayState();
			ManagerHandlers.registerComponents(facade);
			//add proxies
			this.addProxies();
			//add commands
			this.addCommands();
			//add mediators
			this.addMediators();
		}
		override public function cleanUpState():void{
			//remove mediators
			this.removeMediators();
			//remove commands
			this.removeCommands();
			//remove proxies
			this.removeProxies();
			ManagerHandlers.removeComponents(facade);
			super.cleanUpState();
		}
		private function addProxies():void {
			facade.registerProxy(new IncomingDataErrorProxy(BankHandlers.BANK_ERROR));
			
			var fetchAll:RequestProxy = new RequestProxy(BankHandlers.GM_FINES_FETCH_ALL);
			facade.registerProxy(fetchAll);
			fetchAll.sendRequest();
			
			facade.registerProxy(new IncomingDataErrorProxy(BankHandlers.GM_FINES_FETCH_ALL_ERROR));
			
			var incomingFines:IncomingDataProxy = new IncomingDataProxy(BankHandlers.GM_FINES_ALL_FETCHED, BankHandlers.GM_FINES_ALL_FETCHED);
			incomingFines.addDataParam(new DataParamArrayFines("Fines"));
			facade.registerProxy(incomingFines);
			
			facade.registerProxy(new FinesProxy());
			
			var subMenuProxy:SubMenuListProxy = new SubMenuListProxy();
			facade.registerProxy(subMenuProxy);
			subMenuProxy.addSubMenuItem(BankHandlers.GM_FINES_SUB_MENU_LIST);
			subMenuProxy.addSubMenuItem(BankHandlers.GM_FINES_SUB_MENU_EXIT);
			subMenuProxy.setDefaultMenuItem(BankHandlers.GM_FINES_SUB_MENU_LIST);
		}
		private function removeProxies():void {
			facade.removeProxy(BankHandlers.GM_FINES_FETCH_ALL + RequestProxy.NAME);
			facade.removeProxy(BankHandlers.BANK_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(BankHandlers.GM_FINES_FETCH_ALL_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(BankHandlers.GM_FINES_ALL_FETCHED + IncomingDataProxy.NAME);
			facade.removeProxy(FinesProxy.NAME);
			facade.removeProxy(SubMenuListProxy.NAME);
		}
		private function addCommands():void {
			facade.registerCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED, SubMenuFinesManagerCommands);
			facade.registerCommand(BankHandlers.GM_FINES_ALL_FETCHED, ReceiveFinesCommand);
		}
		private function removeCommands():void {
			facade.removeCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED);
			facade.removeCommand(BankHandlers.GM_FINES_ALL_FETCHED);
		}
		private function addMediators():void {
			
			var subMenuMediator:SubMenuMediator = new SubMenuMediator();
			facade.registerMediator(subMenuMediator);
			
			facade.registerMediator(new FinesGMOverviewListMediator());
			
			subMenuMediator.moveToDefaultButton();
		}
		private function removeMediators():void {
			facade.removeMediator(SubMenuMediator.NAME);
			facade.removeMediator(FinesGMOverviewListMediator.NAME);
		}
	}
}
