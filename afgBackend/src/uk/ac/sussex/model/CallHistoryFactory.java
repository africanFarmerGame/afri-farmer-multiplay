package uk.ac.sussex.model;

import java.util.ArrayList;
import java.util.List;

import uk.ac.sussex.model.base.*;

public class CallHistoryFactory extends BaseFactory {
	public CallHistoryFactory() {
		super(new CallHistory());
	}
	public CallHistory fetchCallHistory(Integer callId) throws Exception {
		return (CallHistory) this.fetchSingleObject(callId);
	}
	/**
	 * This function will return the calls initiated by the player.
	 *  
	 * @param pcId
	 * @return List<CallHistory> in descending order of start time. 
	 * @throws Exception
	 */
	public List<CallHistory> fetchPlayerCallMadeHistory(PlayerChar pc) throws Exception {
		RestrictionList rl = new RestrictionList();
		rl.addEqual("callFrom", pc);
		OrderList orders = new OrderList();
		orders.addDescending("started");
		List<BaseObject> objects = this.fetchManyObjects(rl, orders);
		List<CallHistory> calls = new ArrayList<CallHistory>();
		for(BaseObject object: objects){
			calls.add((CallHistory) object);
		}
		return calls;
	}
	/**
	 * This function returns the list of calls that the player has received. 
	 * 
	 * @param pcId
	 * @return List<CallHistory> in descending order of start time. 
	 * @throws Exception
	 */
	public List<CallHistory> fetchPlayerCallReceivedHistory(PlayerChar pc) throws Exception {
		RestrictionList rl = new RestrictionList();
		rl.addEqual("callTo", pc);
		OrderList orders = new OrderList();
		orders.addDescending("started");
		List<BaseObject> objects = this.fetchManyObjects(rl, orders);
		List<CallHistory> calls = new ArrayList<CallHistory>();
		for(BaseObject object: objects){
			calls.add((CallHistory) object);
		}
		return calls;
	}
	public List<CallHistory> fetchUnfinishedCalls(PlayerChar pc) throws Exception {
		String query = "select ch from CallHistory ch " +					
				"where (ch.callFrom = " + pc.getId().toString() +   
				" or ch.callTo = " + pc.getId().toString() + 
				") and ch.finished IS NULL";
		List<BaseObject> objects = this.fetchManyByQuery(query);
		List<CallHistory> calls = new ArrayList<CallHistory>();
		for(BaseObject object: objects) {
			calls.add((CallHistory) object);
		}
		return calls;
	}
}
