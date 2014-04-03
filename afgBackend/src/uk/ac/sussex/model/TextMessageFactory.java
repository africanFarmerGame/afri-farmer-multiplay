/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.base.BaseFactory;
import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.model.base.RestrictionList;

public class TextMessageFactory extends BaseFactory {

	public TextMessageFactory(){
		super(new TextMessage());
	}
	/**
	 * Gets textmessages for a player that have not been deleted. 
	 * @param receiver
	 * @return
	 * @throws Exception
	 */
	public Set<TextMessage> fetchActivePlayerTexts(PlayerChar receiver) throws Exception {
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("receiver", receiver);
		restrictions.addEqual("deleted", 0);
		List<BaseObject> objects = this.fetchManyObjects(restrictions);
		Set<TextMessage> textmessages = new HashSet<TextMessage>();
		for (BaseObject object : objects ) {
			textmessages.add((TextMessage) object);
		}
		return textmessages;
	}
	
	public TextMessage createTextMessage(PlayerChar sender, PlayerChar receiver, String message) throws Exception {
		TextMessage textMessage = new TextMessage();
		textMessage.setSender(sender);
		textMessage.setReceiver(receiver);
		textMessage.setMessage(message);
		textMessage.setUnread(1);
		textMessage.setDeleted(0);
		textMessage.save();
		return textMessage;
	}
	
	public TextMessage fetchTextMessage(Integer textMessageId) throws Exception {
		TextMessage tm = (TextMessage)this.fetchSingleObject(textMessageId);
		return tm;
	}
}
