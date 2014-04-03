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
