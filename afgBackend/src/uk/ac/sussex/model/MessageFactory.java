package uk.ac.sussex.model;

import java.util.ArrayList;
import java.util.List;

import uk.ac.sussex.model.base.BaseFactory;
import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.model.base.OrderList;
import uk.ac.sussex.model.base.RestrictionList;

public class MessageFactory extends BaseFactory {

	public MessageFactory() {
		super(new Message());
	}
	public List<Message> fetchPCMessages(PlayerChar pc) throws Exception {
		RestrictionList rl = new RestrictionList();
		rl.addEqual("recipient", pc);
		rl.addEqual("deleted", 0);
		
		OrderList ol = new OrderList();
		ol.addDescending("timestamp");
		
		List<BaseObject> objects = this.fetchManyObjects(rl, ol);
		List<Message> messages = new ArrayList<Message>();
		for(BaseObject object: objects){
			messages.add((Message) object);
		}
		return messages;
	}
	public Message fetchMessage(Integer messageId) throws Exception {
		Message message = (Message) this.fetchSingleObject(messageId);
		return message;
	}
}
