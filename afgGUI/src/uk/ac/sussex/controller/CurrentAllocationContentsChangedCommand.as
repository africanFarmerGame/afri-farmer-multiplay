package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.DietItem;
	import uk.ac.sussex.model.valueObjects.GameAsset;
	import uk.ac.sussex.model.GameAssetListProxy;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.valueObjects.Diet;
	import uk.ac.sussex.model.valueObjects.Allocation;
	import uk.ac.sussex.model.valueObjects.HearthAsset;
	import uk.ac.sussex.model.HearthAssetListProxy;
	import uk.ac.sussex.model.AllocationListProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class CurrentAllocationContentsChangedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("CurrentAllocationContentsChangedCommand sez: My trigger has been pulled");
			sendNotification(ApplicationFacade.REVERT_TEMP_INFO_TEXT);
			var sideTextMessage:String = "Allocation Totals:\n\n";
			var allocationLP:AllocationListProxy = facade.retrieveProxy(AllocationListProxy.NAME) as AllocationListProxy;
			var hearthAssetsLP:HearthAssetListProxy = facade.retrieveProxy(HearthAsset.OWNER_HEARTH + HearthAssetListProxy.NAME ) as HearthAssetListProxy;
			var gameAssetsLP:GameAssetListProxy = facade.retrieveProxy(GameAssetListProxy.NAME) as GameAssetListProxy;
			if(gameAssetsLP!=null){
				var foodGameAssets:Array = gameAssetsLP.getFoodAssets();
				if(allocationLP!=null){
					var currentAllocation:Allocation = allocationLP.getCurrentAllocation();
					if(currentAllocation!=null){
						//Work through the allocation
						var allocationTotals:Array = new Array();
						for each (var food1:GameAsset in foodGameAssets){
							allocationTotals[food1.getName()] = 0;
						}
						sideTextMessage += "Allocation: " + currentAllocation.getName() +"\n";
						var currentDiets:Array = currentAllocation.getAllocationDiets();
						for each (var diet:Diet in currentDiets){
							var dietItems:Array = diet.getDietItems();
							for each (var dietItem:DietItem in dietItems)
							{
								allocationTotals[dietItem.getAsset().getName()] += dietItem.getAmount();
							}
							
						}
						for each (var food3:GameAsset in foodGameAssets){
							sideTextMessage += allocationTotals[food3.getName()] + " " + food3.getMeasurement() + "(s) " + food3.getName() + "\n";
						}
						sideTextMessage += "\n";
						//Set up the current hearth amounts;
						if(hearthAssetsLP!=null){
							sideTextMessage += "You currently have: \n";
							for each (var food2:GameAsset in foodGameAssets){
								var hearthAsset:HearthAsset = hearthAssetsLP.fetchHearthAssetByAssetId(food2.getId());
								sideTextMessage += hearthAsset.getAmount() + " " + food2.getMeasurement() + "(s) " + food2.getName() + "\n"; 
							}
							sideTextMessage += "\n";
						}
						
						sendNotification(ApplicationFacade.DISPLAY_TEMP_INFO_TEXT, sideTextMessage);
					} 
				}
				
			}
		}
	}
}
