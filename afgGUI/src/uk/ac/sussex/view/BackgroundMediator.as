package uk.ac.sussex.view {
	import uk.ac.sussex.states.VillageGameState;
	import uk.ac.sussex.states.HomeGameState;
	import uk.ac.sussex.view.components.BackgroundMC;
	import uk.ac.sussex.general.ApplicationFacade;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.interfaces.IMediator;

	/**
	 * @author em97
	 */
	public class BackgroundMediator extends Mediator implements IMediator {
		public static const NAME:String = "BackgroundMediator";
		
		private static const HOME_FRAME:String = "HOUSEHOLD";
		private static const VILLAGE_FRAME:String = "VILLAGE";
		private static const DEFAULT_FRAME:String = "DEFAULT";
		
		public function BackgroundMediator() {
			super(NAME, viewComponent);
		}
		override public function listNotificationInterests():Array {
			return [];
		}
		override public function handleNotification (note:INotification):void {
			switch(note.getName()){
			}
		}
		public function setBackground(viewName:String):void {
			switch(viewName){
				case HomeGameState.NAME:
					background.gotoAndStop(HOME_FRAME);
					break;
				case VillageGameState.NAME:
					background.gotoAndStop(VILLAGE_FRAME);
					break;
				default:
					background.gotoAndStop(DEFAULT_FRAME);
			}
		}
		override public function onRegister():void
		{
			viewComponent = new BackgroundMC();
			var appMediator:ApplicationMediator = facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;
			var scaleX:Number = appMediator.getDisplayWidth() / background.width;
			
			background.scaleX = background.scaleY = scaleX;
			
			setBackground("");	
			sendNotification(ApplicationFacade.ADD_TO_BASE, background);
		}
		override public function onRemove():void
		{
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, background);
		}
		protected function get background():BackgroundMC {
			return viewComponent as BackgroundMC;
		}
	}
}
