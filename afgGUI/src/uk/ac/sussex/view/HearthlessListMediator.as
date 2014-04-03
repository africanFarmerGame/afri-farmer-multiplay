package uk.ac.sussex.view {
	
	import uk.ac.sussex.model.valueObjects.PlayerChar;
	import flash.events.Event;
	import uk.ac.sussex.view.components.HearthlessList;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.serverhandlers.VillageHandlers;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import uk.ac.sussex.model.PCListProxy;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.interfaces.IMediator;

	/**
	 * @author em97
	 */
	public class HearthlessListMediator extends Mediator implements IMediator {
		public static const NAME:String = "HearthlessListMediator";
		public function HearthlessListMediator() {
			super(NAME, null);
		}
		override public function listNotificationInterests():Array {
			return [PCListProxy.PLAYER_LIST_UPDATED
					];
		}
		override public function handleNotification (note:INotification):void {
			switch(note.getName()){
				case PCListProxy.PLAYER_LIST_UPDATED:
					var listName:String = note.getBody() as String;
					trace("HearthlessListMediator sez: Player list " + listName + " got updated");
					
					var listProxy:PCListProxy = facade.retrieveProxy(listName) as PCListProxy;
					if(listName == VillageHandlers.HEARTHLESS_LIST){
						trace("HearthlessListMediator sez: ooooh, look. Hearthless people!");
						hearthlessList.displayHearthless(listProxy.getPCList());
					}
					break;
			}
		}
		private function personSelected(e:Event):void {
			var selectedId:String = hearthlessList.getSelectedHearthlessPerson();
			var listProxy:PCListProxy = facade.retrieveProxy(VillageHandlers.HEARTHLESS_LIST) as PCListProxy;
			var selectedPerson:PlayerChar  = listProxy.getPC(int(selectedId));
			var text:String = selectedPerson.getFirstName() + " " + selectedPerson.getFamilyName();
			text+="\n\nNumber of fields: " + selectedPerson.getFieldCount();
			
			sendNotification(ApplicationFacade.DISPLAY_TEMP_INFO_TEXT, text); 
		}
		private function selectionCleared(e:Event):void {
			sendNotification(ApplicationFacade.REVERT_TEMP_INFO_TEXT);
		}
		//Cast the viewComponent to the correct type.
		protected function get hearthlessList():HearthlessList {
			return viewComponent as HearthlessList;
		}
		override public function onRegister():void
		{
			viewComponent = new HearthlessList();
			
			hearthlessList.x = 675;
			hearthlessList.y = 10;
			hearthlessList.addEventListener(HearthlessList.HEARTHLESS_PERSON_SELECTED, personSelected);
			hearthlessList.addEventListener(HearthlessList.HEARTHLESS_SELECTION_CLEARED, selectionCleared);
			sendNotification(ViewAreaMediator.ADD_VIEW_COMPONENT, hearthlessList);
		}
		override public function onRemove():void
		{
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, hearthlessList);
		}
	}
}
