package uk.ac.sussex.handlers;

import java.util.List;
import java.util.Set;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.ISFSExtension;

import uk.ac.sussex.model.Ticker;
import uk.ac.sussex.model.TickerFactory;
import uk.ac.sussex.utilities.GameHelper;
import uk.ac.sussex.utilities.Logger;

public class ClearTickerRunner implements Runnable {
	private ISFSExtension extension;

	public ClearTickerRunner(ISFSExtension gameBackend) {
		extension = gameBackend;
	}

	@Override
	public void run() {
		TickerFactory tf = new TickerFactory();
		Zone currentZone = extension.getParentZone();
		SFSObject outputObj = SFSObject.newInstance();
		try {
			Set<Ticker> activeTickers = tf.fetchActiveTickers();
			for(Ticker ticker:activeTickers){
				Double duration = ticker.getDuration();
				if(duration > 0){
					Long currentTimestamp = System.currentTimeMillis() / 1000;
					Long timerExpiry = (long) (ticker.getTimestamp() + duration);
					if(currentTimestamp > timerExpiry){
						//Need to kill this, and send a clear ticker message to anyone in the right game.
						List<User> users = GameHelper.fetchGameUsers(currentZone, ticker.getGame());
						if((users!= null)&&(users.size()>0)){
							extension.send("ClearTicker", outputObj, users);
						}
						ticker.setActive(0);
						ticker.save();
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			Logger.ErrorLog("ClearTickerRunner.run", "Problem removing ticker objects: " + e.getLocalizedMessage());
		}
	}

}
