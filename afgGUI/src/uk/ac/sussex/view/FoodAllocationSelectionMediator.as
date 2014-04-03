package uk.ac.sussex.view {
	import uk.ac.sussex.view.components.FoodAllocationSelection;
	import uk.ac.sussex.general.ApplicationFacade;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	/**
	 * @author em97
	 */
	public class FoodAllocationSelectionMediator extends Mediator implements IMediator {
		public static const NAME:String = "TableTopDisplayMediator";
		
		
		
		public function FoodAllocationSelectionMediator() {
			super(NAME, new FoodAllocationSelection());
		}
		protected function get foodAllocationSelection():FoodAllocationSelection  {
			return viewComponent as FoodAllocationSelection;
		}
		override public function onRegister():void {
			var submenuMediator:SubMenuMediator = facade.retrieveMediator(SubMenuMediator.NAME) as SubMenuMediator;
			
			foodAllocationSelection.x = submenuMediator.getSubmenuWidth();
			foodAllocationSelection.y = 10;
			
			sendNotification(ViewAreaMediator.ADD_VIEW_COMPONENT, foodAllocationSelection);
		}
		override public function onRemove():void {
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, foodAllocationSelection);
		}
	}
}
