package uk.ac.sussex.view {
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.view.components.SplashScreen;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.interfaces.IMediator;

	/**
	 * @author em97
	 */
	public class SplashMediator extends Mediator implements IMediator {
		public static const NAME:String = "SplashScreenMediator";
		
		public function SplashMediator() {
			// constructor code
			super(NAME, null);
		}
		//Cast the viewComponent to the correct type.
		protected function get splashScreen():SplashScreen {
			return viewComponent as SplashScreen;
		}
		override public function onRegister():void
		{
			viewComponent = new SplashScreen();
			
			sendNotification(ApplicationFacade.ADD_TO_SCREEN, splashScreen);
		}
		override public function onRemove():void
		{
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, splashScreen);
		}
	}
}
