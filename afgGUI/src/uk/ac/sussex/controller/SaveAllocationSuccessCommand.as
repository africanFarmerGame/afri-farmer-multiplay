package uk.ac.sussex.controller {
	import uk.ac.sussex.model.*;
	import uk.ac.sussex.model.valueObjects.*;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SaveAllocationSuccessCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var allocation:Allocation = incomingData.getParamValue("Allocation") as Allocation;
			var message:String = incomingData.getParamValue("message") as String;
			trace("SaveAllocationSuccessCommand sez: The message was " + message + " for allocationid " + allocation.getId());
			
			var galp:GameAssetListProxy = facade.retrieveProxy(GameAssetListProxy.NAME) as GameAssetListProxy;
			var drlp:DietaryRequirementsProxy = facade.retrieveProxy(DietaryRequirementsProxy.NAME) as DietaryRequirementsProxy;
			var hmlp:HearthMembersListProxy = facade.retrieveProxy(HearthMembersListProxy.NAME) as HearthMembersListProxy;
		
			var diets:Array = allocation.getAllocationDiets();
			for each (var diet:Diet in diets){
				var member:AnyChar = hmlp.getMember(diet.getId());
				diet.setTarget(member.getDietTarget());
				diet.setDietaryRequirements(drlp.getTargetRequirements(diet.getTarget()));
				diet.setName(member.getFirstName() + " " + member.getFamilyName());
				var diarray:Array = diet.getDietItems();
				for each (var di:DietItem in diarray){
					var foodAsset:GameAssetFood = galp.getFoodAsset(di.getAssetId());
					di.setAsset(foodAsset);
				}
				diet.updateNutrientLevels();
			}
			var alp:AllocationListProxy = facade.retrieveProxy(AllocationListProxy.NAME) as AllocationListProxy;
			if(alp != null){
				alp.saveAllocation(allocation);
			} 
		}
	}
}
