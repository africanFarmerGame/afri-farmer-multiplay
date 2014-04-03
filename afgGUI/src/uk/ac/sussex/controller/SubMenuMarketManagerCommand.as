package uk.ac.sussex.controller {
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.view.MarketAssetsListMediator;
	import uk.ac.sussex.view.FormMediator;
	import uk.ac.sussex.serverhandlers.MarketHandlers;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class SubMenuMarketManagerCommand extends SimpleCommand {
			
		override public function execute( note:INotification ):void {
			trace("SubMenuMarketManagerCommand sez: We're looking for submenu item " + note.getBody());
			var maListMediator:MarketAssetsListMediator = facade.retrieveMediator(MarketAssetsListMediator.NAME) as MarketAssetsListMediator;
			var subMenuItem:String = note.getBody() as String;
			switch(subMenuItem){
				case MarketHandlers.GM_SUB_MENU_LIST:
					trace("SubMenuMarketManagerCommand sez: Listing out the market assets now.");
					showListText();
					maListMediator.showList(true);
					maListMediator.listenForSelection(false);
					var maFormMediator:FormMediator = facade.retrieveMediator(MarketHandlers.EDIT_ASSET_FORM) as FormMediator;
					maFormMediator.hideForm();
					break;
				case MarketHandlers.GM_SUB_MENU_EDIT:
					trace("SubMenuMarketManagerCommand sez: And now we're trying to edit...");
					displayEdit(maListMediator);
					break;
			}
		}
		private function showListText():void {
			var sideTxt:String = "Market \n";
			sideTxt += "You can see all of the market prices and stocks here. \n\n";
			sideTxt += "You may edit the stock levels and market prices if you wish. However, this may change the balance of the game and is not recommended.";
			sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, sideTxt);
		}
		private function showEditText():void {
			var sideTxt:String = "Edit \n";
			sideTxt += "";
			sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, sideTxt);
		}
		private function displayEdit(maListMediator:MarketAssetsListMediator):void {
			var selectedId:String = maListMediator.getSelectedMAId();
			var sideTxt:String = "Edit \n";
			sideTxt += "Caution: this may change the balance of the game.\n\n";
			
			if(selectedId == null){
				trace("SubMenuMarketManagerCommand sez: We haz no item selected.");
				maListMediator.listenForSelection(true);
				maListMediator.showList(true);
				sideTxt += "Select a task from the list to edit, complete the necessary changes, then click save to confirm.\n";
				sideTxt += "\nClicking cancel will discard any changes you have made and return to the overview.";
				sideTxt += "\n\nIf you need to change the type of task you will need to delete the task and create a new one.";
				sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, sideTxt);
			} else {
				trace("SubMenuMarketManagerCommand sez: We have asset " + selectedId + " selected");
				sideTxt += "Complete the changes you need to make to this task, then click save to confirm.\n";
				sideTxt += "\nClicking cancel will discard any changes you have made and return to the overview.";				
				sideTxt += "\n\nIf you need to change the type of task you will need to cancel this edit, delete the task and create a new one.";
				sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, sideTxt);
				sendNotification(MarketHandlers.EDIT_ASSET_REQUESTED, int(selectedId));
				maListMediator.showList(false);
			}
		}
	}
}
