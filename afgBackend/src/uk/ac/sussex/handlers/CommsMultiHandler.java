/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

/**
 * 
 */
package uk.ac.sussex.handlers;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.CallHistory;
import uk.ac.sussex.model.CallHistoryFactory;
import uk.ac.sussex.model.Message;
import uk.ac.sussex.model.MessageFactory;
import uk.ac.sussex.model.Player;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
//import uk.ac.sussex.model.Role;
import uk.ac.sussex.model.TextMessage;
import uk.ac.sussex.model.TextMessageFactory;
import uk.ac.sussex.model.Ticker;
import uk.ac.sussex.model.TickerFactory;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.utilities.GameHelper;
import uk.ac.sussex.utilities.Logger;
import uk.ac.sussex.utilities.UserHelper;

import com.smartfoxserver.v2.annotations.MultiHandler;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.variables.UserVariable;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.extensions.SFSExtension;

/**
 * @author em97
 * This class handles all of the comms requests from the clients. 
 */
@MultiHandler
public class CommsMultiHandler extends BaseClientRequestHandler {

	/* (non-Javadoc)
	 * @see com.smartfoxserver.v2.extensions.IClientRequestHandler#handleClientRequest(com.smartfoxserver.v2.entities.User, com.smartfoxserver.v2.entities.data.ISFSObject)
	 */
	@Override
	public void handleClientRequest(User user, ISFSObject params) {
		String requestId = params.getUtfString(SFSExtension.MULTIHANDLER_REQUEST_ID);
        
		try{
	        switch (CommsMultiOption.toOption(requestId)){
	        	case TALK:
	        		this.broadcastTalkMessage(user, params);
	        		break;
	        	case TICKER_ANNOUNCE:
	        		Logger.Log(user.getName(), "Sending a ticker message");
	        		this.sendTickerAnnouncement(user, params);
	        		break;
	        	case CLEAR_TICKER:
	        		Logger.Log(user.getName(), "Clearing the ticker message");
	        		this.sendClearTicker(user);
	        		break;
	        	case FETCH_TICKER:
	        		Logger.Log(user.getName(), "Asked for the current ticker message");
	        		this.fetchTicker(user);
	        		break;
	        	case FETCH_ALL_MEMBERS:
	        		Logger.Log(user.getName(), "Asked for the list of all game players");
	        		this.fetchAllGamePCs(user);
	        		break;
	        	case SEND_SMS_MESSAGE:
	        		Logger.Log(user.getName(), "Sending a textmessage");
	        		this.sendTextMessage(user, params);
	        		break;
	        	case READ_SMS_MESSAGES:
	        		Logger.Log(user.getName(), "Reading their textmessages");
	        		this.readTextMessages(user);
	        		break;
	        	case UPDATE_SMS_MESSAGE:
	        		Logger.Log(user.getName(), "Updating a textmessage");
	        		this.updateTextMessages(user, params);
	        		break;
	        	case TALK_PHONE:
	        		this.sendPhoneMessage(user, params);
	        		break;
	        	case START_CALL:
	        		Integer recipientId = params.getInt("CallToId");
	        		Logger.Log(user.getName(), "Started a call to " + recipientId);
	        		this.startPhoneCall(user, recipientId);
	        		break;
	        	case ANSWER_CALL:
	        		Integer answerId = params.getInt("CallId");
	        		Logger.Log(user.getName(), "Answered a call");
	        		this.answerPhoneCall(user, answerId);
	        		break;
	        	case END_CALL:
	        		Integer callId = params.getInt("CallId");
	        		Logger.Log(user.getName(), "Ended a call " + callId);
	        		this.endPhoneCall(user, callId);
	        		break;
	        	case FETCH_CALL_HISTORY:
	        		Logger.Log(user.getName(), "Fetching the call history.");
	        		this.retrieveCallHistory(user);
	        		break;
	        	case FETCH_MESSAGES:
	        		Logger.Log(user.getName(), "Fetching their messages");
	        		this.retrieveMessages(user);
	        		break;
	        	case UPDATE_MESSAGE:
	        		Logger.Log(user.getName(), "Updating a message");
	        		this.updateMessages(user, params);
	        		break;
	        	default:
	        		ISFSObject errObj = new SFSObject();
	            	errObj.putUtfString("message", "Unable to action request "+requestId);
	            	send("commsError", errObj, user);
	            	Logger.ErrorLog("CommsHandler.handleClientRequest", "User " + user.getName() + " asked for a strange option " +requestId);
	        }
		} catch (Exception e) {
			String errorMsg = e.getMessage();
			Logger.ErrorLog("CommsHandler.handleClientRequest", "Problem with request " + requestId + ": " + errorMsg);
    		ISFSObject errObj = SFSObject.newInstance();
    		errObj.putUtfString("message", "Problem with request: " + errorMsg);
    		send(requestId+"_error", errObj, user);
		}
	}
	
	private void broadcastTalkMessage(User user, ISFSObject params) throws Exception {
		String playermessage = params.getUtfString("playermessage");
		UserVariable pcVariable = user.getVariable("pc");
		if(pcVariable!= null){
			ISFSObject pcDetail = pcVariable.getSFSObjectValue();
			String authorName = pcDetail.getUtfString("firstname") ;
			SFSObject outputObj = SFSObject.newInstance();
			outputObj.putUtfString("playermessage", playermessage);
			outputObj.putUtfString("author", authorName);
			outputObj.putInt("authorid", pcDetail.getInt("id"));
			Room currentRoom = user.getLastJoinedRoom();
			send("talk_received", outputObj, currentRoom.getUserList());
		} else {
			throw new Exception ("Problem with the player character for user " + user.getName());
		}
	}
	private void sendTickerAnnouncement(User user, ISFSObject params) throws Exception{
		
		String tickermessage = params.getUtfString("TickerMessage");
		Integer expires = params.getInt("TickerExpires");
		Double duration = (double) 0;
		if(expires == 1){
			//Need to work out how long it should be going for. 
			String durationUnits = params.getUtfString("TickerDurationUnit");
			Double sentDuration = params.getDouble("TickerDuration");
			if(durationUnits.contentEquals("M")){
				duration = sentDuration * 60;
			} else if (durationUnits.contentEquals("H")) {
				duration = sentDuration * 60 * 60;
			} else if (durationUnits.contentEquals("D")) {
				duration = sentDuration * 60 * 60 * 24;
			}
		}
		PlayerChar sender = UserHelper.fetchUserPC(user);
		TickerFactory tf = new TickerFactory();
		tf.createTicker(sender, tickermessage, duration);
		SFSObject outputObj = SFSObject.newInstance();
		outputObj.putUtfString("Message", tickermessage);
		
		//TODO: check this user has permission to do this. 
		String roomGroupId = GameHelper.fetchGameRoomgroup(sender.getGame());
		Logger.Log(user.getName(), "Attempting to send ticker message " + tickermessage + " to roomgroup " + roomGroupId);

		Zone currentZone = this.getParentExtension().getParentZone();
		
		List<User> users = GameHelper.fetchGameUsers(currentZone, sender.getGame());
		send("TickerMessage", outputObj, users);
	}
	private void sendClearTicker(User user) throws Exception {
		//TODO: check the user should be allowed to clear the ticker. 
		SFSObject outputObj = SFSObject.newInstance();
		Game game = UserHelper.fetchUserGame(user);
		Logger.Log(user.getName(), "Clearing the ticker message for game " + game.getId());
		
		TickerFactory tf = new TickerFactory();
		Ticker ticker = tf.fetchCurrentTicker(game);
		if(ticker!= null){
			ticker.setActive(0);
			ticker.save();
		}
		
		Zone currentZone = this.getParentExtension().getParentZone();
		List<User> users = GameHelper.fetchGameUsers(currentZone, game);
		send("ClearTicker", outputObj, users);
	}
	private void fetchTicker(User user) throws Exception {
		SFSObject outputObj = SFSObject.newInstance();
		Game game = UserHelper.fetchUserGame(user);
		TickerFactory tf = new TickerFactory();
		Ticker ticker = tf.fetchCurrentTicker(game);
		if(ticker==null){
			send("ClearTicker", outputObj, user);
		} else {
			outputObj.putUtfString("Message", ticker.getMessage());
			send("TickerMessage", outputObj, user);
		}
	}
	private void fetchAllGamePCs(User user) throws Exception {
		SFSObject outputObj = SFSObject.newInstance();
		
		Game userGame = UserHelper.fetchUserGame(user);
		PlayerCharFactory pcf = new PlayerCharFactory();
		Set<PlayerChar> allPlayers = pcf.fetchAll(userGame);
		SFSArray playerArray = SFSArray.newInstance();
		for (PlayerChar pc : allPlayers){
			//Only send over the playerchars that actually have a player behind them. 
			if(pc.getPlayer()!= null){
				SFSObject pcObj = SFSObject.newInstance();
				pcObj.putInt("id", pc.getId());
				pcObj.putUtfString("firstname", pc.getName());
				pcObj.putUtfString("familyname", pc.getFamilyName());
				pcObj.putUtfString("role", pc.getRole().getId());
				pcObj.putBool("online", isOnline(pc));
				if(pc.getHearth() != null){
					pcObj.putInt("hearthid", pc.getHearth().getId());
				} else {
					pcObj.putNull("hearthid");	//This should be true for the banker. 
				}
				pcObj.putInt("avatarbody", pc.getAvatarBody());
				playerArray.addSFSObject(pcObj);
			}
		}
		outputObj.putSFSArray("players", playerArray);
		send("AllGamePCs", outputObj, user);
	}
	private void readTextMessages(User user) throws Exception {
		SFSObject outputObj = SFSObject.newInstance();
		
		PlayerChar pc = UserHelper.fetchUserPC(user);
		TextMessageFactory tmf = new TextMessageFactory();
		Set<TextMessage> textMessages = tmf.fetchActivePlayerTexts(pc);
		SFSArray messagesArray = SFSArray.newInstance();
		
		if(textMessages.size()>0){
			//Fetch a list of possible senders. I _think_ it's less costly to do this once than for each.
			PlayerCharFactory pcf = new PlayerCharFactory();
			Set<PlayerChar> possibleSenders = pcf.fetchAll(pc.getGame());
			
			for(TextMessage sms: textMessages){
				SFSObject smsObj = SFSObject.newInstance();
				smsObj.putInt("id", sms.getId());
				PlayerChar smsSender = this.getSender(sms.getSender().getId(), possibleSenders);
				smsObj.putInt("sender", smsSender.getId());
				smsObj.putUtfString("senderName", smsSender.getDisplayName());
				smsObj.putInt("receiver", sms.getReceiver().getId());
				smsObj.putUtfString("message", sms.getMessage());
				smsObj.putLong("timestamp", sms.getTimestamp());
				smsObj.putInt("unread", sms.getUnread());
				smsObj.putInt("deleted", sms.getDeleted());
				messagesArray.addSFSObject(smsObj);
			}
		}
		outputObj.putSFSArray("textMessages", messagesArray);
		send("TextMessages", outputObj, user);
	}
	private void sendTextMessage(User user, ISFSObject params) throws Exception {
		//Need to check the user has the funds.
		PlayerChar pc = UserHelper.fetchUserPC(user);
		//TODO: Check the user has the funds to send a message.
		//Then create the textmessage and store it.
		PlayerCharFactory pcf = new PlayerCharFactory();
		Integer recipientId = params.getInt("Receiver");
		PlayerChar recipient = null;
		try {
			recipient = pcf.fetchPlayerChar(recipientId);
		} catch (Exception e) {
			Logger.ErrorLog("CommsMultiHandler.sendTextMessage", "Problem getting recipient: " + e.getMessage());
			throw new Exception("Unable to find recipient");
		}
		String message = params.getUtfString("Message");
		TextMessageFactory tmf = new TextMessageFactory();
		TextMessage sms = null;
		try {
			sms = tmf.createTextMessage(pc, recipient, message);
		} catch(Exception e) {
			Logger.ErrorLog("CommsMultiHandler.sendTextMessage", "Problem creating message: " + e.getMessage());
			throw new Exception("Unable to create text message");
		}
		SFSObject sendSuccess = SFSObject.newInstance();
		sendSuccess.putUtfString("message", "Text Message was successfully sent to " + recipient.getName() + " " + recipient.getFamilyName());
		send("send_message_success", sendSuccess, user);
		//And see if the recipient is online to receive a notification. 
		Player recipientPlayer = recipient.getPlayer();
		User recipientUser = this.getApi().getUserByName(recipientPlayer.getLoginName());
		if(recipientUser != null){
			SFSObject smsObj = SFSObject.newInstance();
			smsObj.putInt("id", sms.getId());
			smsObj.putInt("sender", pc.getId());
			smsObj.putUtfString("senderName", pc.getName() + " " + pc.getFamilyName());
			smsObj.putInt("receiver", recipientId);
			smsObj.putUtfString("message", sms.getMessage());
			smsObj.putLong("timestamp", sms.getTimestamp());
			smsObj.putInt("unread", sms.getUnread());
			smsObj.putInt("deleted", sms.getDeleted());
			SFSObject outputObj = SFSObject.newInstance();
			outputObj.putSFSObject("textMessage", smsObj);
			send("TextMessage", outputObj, recipientUser);
		}
	}
	private void updateTextMessages(User user, ISFSObject params) throws Exception {
		ISFSObject tmObj = params.getSFSObject("textMessage");
		Integer textMessageId = tmObj.getInt("id");
		TextMessageFactory tmf = new TextMessageFactory();
		TextMessage tm = tmf.fetchTextMessage(textMessageId);
		//I think there are only two fields I want to be able to update: read and deleted. 
		Integer unread  = tmObj.getInt("unread");
		Integer deleted = tmObj.getInt("deleted");
		tm.setDeleted(deleted);
		tm.setUnread(unread);
		tm.save();
	}
	private void updateMessages(User user, ISFSObject params) throws Exception {
		ISFSObject mObj = params.getSFSObject("Message");
		Integer messageId = mObj.getInt("Id");
		MessageFactory mf = new MessageFactory();
		Message m = mf.fetchMessage(messageId);
		//I think there are only two fields I want to be able to update: read and deleted. 
		Integer unread  = mObj.getInt("Unread");
		Integer deleted = mObj.getInt("Deleted");
		m.setDeleted(deleted);
		m.setUnread(unread);
		m.save();
	}
	private void retrieveCallHistory(User user) throws Exception {
		PlayerChar pc = UserHelper.fetchUserPC(user);
		CallHistoryFactory chFactory = new CallHistoryFactory();
		List<CallHistory> outgoingCalls = chFactory.fetchPlayerCallMadeHistory(pc);
		List<CallHistory> incomingCalls = chFactory.fetchPlayerCallReceivedHistory(pc);
		//Fetch a list of possible senders. I _think_ it's less costly to do this once than for each.
		PlayerCharFactory pcf = new PlayerCharFactory();
		Set<PlayerChar> possiblePlayers = pcf.fetchAll(pc.getGame());
		
		SFSArray outgoingArray = SFSArray.newInstance();
		SFSArray incomingArray = SFSArray.newInstance();
		String playerName = pc.getName() + " " + pc.getFamilyName();
		for (CallHistory ch : outgoingCalls){
			PlayerChar recipient = getSender(ch.getCallTo().getId(), possiblePlayers);
			SFSObject chObj = translateCallHistoryToSFS(ch, playerName, recipient.getName() + " " + recipient.getFamilyName());
			outgoingArray.addSFSObject(chObj);
		}
		for (CallHistory ch: incomingCalls){
			PlayerChar caller = getSender(ch.getCallTo().getId(), possiblePlayers);
			SFSObject chObj = translateCallHistoryToSFS(ch, caller.getName() + " " + caller.getFamilyName(), playerName);
			incomingArray.addSFSObject(chObj);
		}
		SFSObject sendObject = SFSObject.newInstance();
		sendObject.putSFSArray("Outgoing", outgoingArray);
		sendObject.putSFSArray("Incoming", incomingArray);
		send("CallHistory", sendObject, user);
	}
	private void startPhoneCall(User user, Integer recipientId) throws Exception {
		PlayerChar caller = UserHelper.fetchUserPC(user);
		if(caller.getId().equals(recipientId)){
			SFSObject sendObj = SFSObject.newInstance();
			sendObj.putUtfString("message", "You just tried to call yourself. You were engaged.");
			send("EndCall", sendObj, user);
		} else {
	
			PlayerCharFactory pcf = new PlayerCharFactory();
			PlayerChar recipient = pcf.fetchPlayerChar(recipientId);
			
			CallHistoryFactory chf = new CallHistoryFactory();
			CallHistory callHistory = new CallHistory();
			callHistory.setCallFrom(caller);
			callHistory.setCallTo(recipient);
			
			List<CallHistory> unfinishedCalls = chf.fetchUnfinishedCalls(recipient);
			
			//And see if the recipient is online to receive a notification. 
			Player recipientPlayer = recipient.getPlayer();
			User recipientUser = this.getApi().getUserByName(recipientPlayer.getLoginName());
			SFSObject sendObj = SFSObject.newInstance();
			if(recipientUser==null){
				//The person you're calling isn't online right now. Stop this foolishness.
				callHistory.setFinished(System.currentTimeMillis() / 1000);
				callHistory.save();
				sendObj.putUtfString("message", recipient.getName() + " " + recipient.getFamilyName() + " is not online to take your call.");
				send("EndCall", sendObj, user);
			} else if(unfinishedCalls!=null && unfinishedCalls.size()>0) {
				//The person you're calling is on another call.
				callHistory.setFinished(System.currentTimeMillis() / 1000);
				callHistory.save();
				sendObj.putUtfString("message", recipient.getName() + " " + recipient.getFamilyName() + " is on another call at the moment.");
				send("EndCall", sendObj, user);
			} else {
				callHistory.save();
				sendObj.putInt("CallFromId", caller.getId());
				sendObj.putUtfString("CallFromName", caller.getName() + " " + caller.getFamilyName());
				sendObj.putInt("CallId", callHistory.getId());
				send("IncomingCall", sendObj,recipientUser);
				SFSObject ringing = SFSObject.newInstance();
				ringing.putUtfString("message", "Ringing...");
				ringing.putInt("CallId", callHistory.getId());
				send("Ringing", ringing, user);
			}
			callHistory.save();
		}
	}
	private void endPhoneCall(User user, Integer callId) throws Exception {
		PlayerChar callEnder = UserHelper.fetchUserPC(user);
		
		List<User> sendToUsers = new ArrayList<User>();
		sendToUsers.add(user);
		//Need to get the call history of the call they were involved in. Would it be easier to send it back and forth? yes.
		CallHistoryFactory chf = new CallHistoryFactory();
		CallHistory callHistory = chf.fetchCallHistory(callId);
		callHistory.setFinished(System.currentTimeMillis() / 1000);
		callHistory.save();
		
		PlayerCharFactory pcf = new PlayerCharFactory();
		Integer participantId = callHistory.getCallFrom().getId();
		if(callEnder.getId().equals(participantId)){
			participantId = callHistory.getCallTo().getId();
		}
		PlayerChar participant = pcf.fetchPlayerChar(participantId);
		Player participantPlayer = participant.getPlayer();
		User participantUser = this.getApi().getUserByName(participantPlayer.getLoginName());
		
		if(participantUser != null){
			sendToUsers.add(participantUser);
		}
		
		SFSObject sendObject = SFSObject.newInstance();
		sendObject.putUtfString("message", "Call ended by " + callEnder.getDisplayName());
		send("EndCall", sendObject, sendToUsers);
	}
	private void answerPhoneCall(User user,Integer answerId) throws Exception {
		//What should happen here?
		CallHistoryFactory chf = new CallHistoryFactory();
		CallHistory callHistory = chf.fetchCallHistory(answerId);
		callHistory.setAnswered(System.currentTimeMillis()/1000);
		callHistory.save();
		
		List<User> sendToUsers = new ArrayList<User>();
		sendToUsers.add(user);
		
		PlayerCharFactory pcf = new PlayerCharFactory();
		PlayerChar caller = pcf.fetchPlayerChar(callHistory.getCallFrom().getId());
		Player callerPlayer = caller.getPlayer();
		User callerUser = this.getApi().getUserByName(callerPlayer.getLoginName());
		if(callerUser!=null){
			sendToUsers.add(callerUser);
		}
		
		SFSObject sendObject = SFSObject.newInstance();
		sendObject.putLong("Answered", callHistory.getAnswered());
		sendObject.putInt("CallId", answerId);
		
		send("CallAnswered", sendObject, sendToUsers);
	}
	private void sendPhoneMessage(User user,ISFSObject params) throws Exception {
		PlayerChar author = UserHelper.fetchUserPC(user);
		
		Integer callId = params.getInt("CallId");
		String message = params.getUtfString("message");
		CallHistoryFactory chf = new CallHistoryFactory();
		CallHistory callHistory = chf.fetchCallHistory(callId);
		
		List<User> sendToUsers = new ArrayList<User>();
		sendToUsers.add(user);
		
		PlayerCharFactory pcf = new PlayerCharFactory();
		Integer callerId = callHistory.getCallFrom().getId();
		if(author.getId().equals(callerId)){
			callerId = callHistory.getCallTo().getId();
		}
		PlayerChar caller = pcf.fetchPlayerChar(callerId);
		Player callerPlayer = caller.getPlayer();
		User callerUser = this.getApi().getUserByName(callerPlayer.getLoginName());
		if(callerUser!=null){
			sendToUsers.add(callerUser);
		}
		SFSObject outputObj = SFSObject.newInstance();
		outputObj.putUtfString("message", message);
		outputObj.putUtfString("author", author.getDisplayName());
		outputObj.putInt("authorid", author.getId());
		
		send("talk_phone_received", outputObj, sendToUsers);
	}
	private PlayerChar getSender(Integer senderId, Set<PlayerChar> possiblePlayers) {
		for(PlayerChar pc : possiblePlayers){
			if(pc.getId().equals(senderId)){
				return pc;
			}
		}
		return null;
	}
	private SFSObject translateCallHistoryToSFS(CallHistory callHistory, String callerName, String receipientName){
		SFSObject chObj = SFSObject.newInstance();
		chObj.putInt("Id", callHistory.getId());
		chObj.putInt("CallFromId", callHistory.getCallFrom().getId());
		chObj.putUtfString("CallFromName", callerName);
		chObj.putInt("CallToId", callHistory.getCallTo().getId());
		chObj.putUtfString("CallToName", receipientName);
		chObj.putLong("Started", callHistory.getStarted());
		if(callHistory.getAnswered()!=null){
			chObj.putLong("Answered", callHistory.getAnswered());
		} else {
			chObj.putNull("Answered");
		}
		if(callHistory.getFinished()!=null){
			chObj.putLong("Finished", callHistory.getFinished());
		} else {
			chObj.putNull("Finished");
		}
		return chObj;
	}
	/**
	private Boolean checkFunds(PlayerChar pc, Double cost) {
		if(pc.getRole().getId().equals(Role.BANKER)){
			return true;
		}
		Boolean hazFunds = false;
		return hazFunds;
	}**/
	private Boolean isOnline(PlayerChar pc) {
		Player player = pc.getPlayer();
		if(player!=null){
			User onlineUser = this.getApi().getUserByName(player.getLoginName());
			return(onlineUser!=null);
		}
		return false;
	}
	private void retrieveMessages(User user) throws Exception {
		PlayerChar pc = UserHelper.fetchUserPC(user);
		MessageFactory messageFactory = new MessageFactory();
		List<Message> messages = messageFactory.fetchPCMessages(pc);
		SFSArray sfsMessages = SFSArray.newInstance();
		for (Message message : messages){
			SFSObject sfsMessage = SFSObject.newInstance();
			sfsMessage.putInt("Id", message.getId());
			sfsMessage.putInt("Recipient", message.getRecipient().getId());
			sfsMessage.putUtfString("Subject", message.getSubject());
			sfsMessage.putUtfString("Body", message.getBody());
			sfsMessage.putInt("Deleted", message.getDeleted());
			sfsMessage.putInt("Unread", message.getUnread());
			sfsMessage.putLong("Timestamp", message.getTimestamp());
			sfsMessages.addSFSObject(sfsMessage);
		}
		SFSObject sendObj = SFSObject.newInstance();
		sendObj.putSFSArray("Messages", sfsMessages);
		send("MessagesReceived", sendObj, user);
	}
}
