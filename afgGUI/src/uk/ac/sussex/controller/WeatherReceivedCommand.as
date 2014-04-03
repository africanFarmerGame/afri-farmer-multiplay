package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.Weather;
	import uk.ac.sussex.view.SeasonsDisplayMediator;
	import uk.ac.sussex.serverhandlers.SeasonsHandlers;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class WeatherReceivedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("WeatherReceivedCommand sez: I got executed.");
			var incoming:IncomingData = note.getBody() as IncomingData;
			var weather:Array = incoming.getParamValue(SeasonsHandlers.WEATHER_LIST) as Array;
			
			var sdMediator:SeasonsDisplayMediator = facade.retrieveMediator(SeasonsDisplayMediator.NAME) as SeasonsDisplayMediator;
			if(sdMediator!= null){
				sdMediator.hideWeather();
				for each (var seasonWeather:Weather in weather){
					sdMediator.setWeather(seasonWeather.getName(), seasonWeather.getSeason());
				}
			}
		}
	}
}
