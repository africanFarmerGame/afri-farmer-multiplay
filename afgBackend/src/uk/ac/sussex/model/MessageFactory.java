/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
