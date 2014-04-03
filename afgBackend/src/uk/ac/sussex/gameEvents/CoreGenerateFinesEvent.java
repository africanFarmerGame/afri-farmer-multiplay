package uk.ac.sussex.gameEvents;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.tasks.*;
import uk.ac.sussex.utilities.Logger;

public class CoreGenerateFinesEvent extends GameEvent {

	public CoreGenerateFinesEvent(Game game) {
		super(game);
	}

	@Override
	public void fireEvent() throws Exception {
		HearthFactory hf = new HearthFactory();
		Set<Hearth> hearths = hf.fetchGameHearths(game);
		TaskList taskList = game.fetchTaskList();
		SeasonDetail currentSeason = game.getCurrentSeasonDetail();
		for(Hearth hearth: hearths){
			if(!checkHouseholdTasks(hearth, taskList, currentSeason)){
				generateFine(hearth, "Dereliction of household duties.", 10.00, 15.00, currentSeason);
			}
			if(!checkBabysittingTasks(hearth, taskList, currentSeason)){
				generateFine(hearth, "Neglect of babies in your care.", 10.00, 15.00, currentSeason);
			}
		}
	}
	private Boolean checkHouseholdTasks(Hearth hearth, TaskList tl, SeasonDetail season) throws Exception{
		List<Task> tasks = tl.fetchSeasonalTasks(hearth, TaskHousehold.TASKTYPE, season);
		Iterator<Task> taskIterator = tasks.iterator();
		Integer success = 0;
		while(success==0 && taskIterator.hasNext()){
			Task task = taskIterator.next();
			if(task.getStatus().equals(Task.COMPLETED)){
				success ++;
			}
		}
		Boolean taskOk = (success>0); 
		return taskOk;
	}
	private Boolean checkBabysittingTasks(Hearth hearth, TaskList tl, SeasonDetail season) throws Exception{
		List<Task> tasks = tl.fetchSeasonalTasks(hearth, TaskBabysit.TASKTYPE, season);
		Iterator<Task> taskIterator = tasks.iterator();
		Integer success = 0;
		while(success==0 && taskIterator.hasNext()){
			Task task = taskIterator.next();
			if(task.getStatus().equals(Task.COMPLETED)){
				success ++;
			}
		}
		Boolean taskOk = (success>0);
		
		if(!taskOk){
			//Check that this household has children to sit on. 
			taskOk = !hearth.needsBabysitter();
		}
		return taskOk;
	}
	private void generateFine(Hearth hearth, String description, Double earlyRate, Double lateRate, SeasonDetail season) throws Exception{
		Bill fine = BillFactory.newBill(BillPenalty.NAME);
		fine.setPayee(hearth);
		fine.setDescription(description);
		fine.setEarlyRate(earlyRate);
		fine.setLateRate(lateRate);
		fine.setSeason(season);
		fine.save();
	}

	@Override
	public void generateNotifications() throws Exception {
		Set<Hearth> hearths = game.fetchHearths();
		PlayerCharFactory pcf = new PlayerCharFactory();
		SeasonNotificationFactory snf = new SeasonNotificationFactory();
		List<Bill> allBills = new ArrayList<Bill>();
		SeasonDetail sd = game.getCurrentSeasonDetail();
		BillFactory billFactory = new BillFactory();
		for(Hearth hearth: hearths){
			Set<PlayerChar> pcs = pcf.fetchHearthPCs(hearth);
			String notification = "Penalties:";
			try{
				List<Bill> householdPenalties = billFactory.fetchSeasonalHouseholdBills(BillPenalty.NAME, hearth, sd);
				if(householdPenalties.size()>0){
					allBills.addAll(householdPenalties);
					notification += "\nYour household received the following penalties this season:";
					for(Bill bill: householdPenalties){
						notification += "\n" + bill.getDescription();
					}
					notification += "\nCheck in the bank for the amount owing, and pay early if you can!";
				} else {
					notification += "\nYour household received no penalties this season.";
				}
			} catch(Exception e){
				Logger.ErrorLog("CoreGenerateFinesEvent.generateNotifications", "Problem fetching household fines for hearth " + hearth.getId() + ": " + e.getMessage());
				notification += "\nThere was a problem checking the penalties you received this season. You should check with the bank, just in case.";
			}
			snf.updateSeasonNotifications(notification, pcs);
		}
		
		//Would be best to inform the GM as well. 
		String gmNotification = "Penalties:";
		if(allBills.size()>0){
			Hearth payee = null;
			Integer currentPayeeId = 0;
			for(Bill bill: allBills){
				if(!bill.getPayee().getId().equals(currentPayeeId)){
					Integer newPayeeId = bill.getPayee().getId();
					Iterator<Hearth> hearthIterator = hearths.iterator();
					while(hearthIterator.hasNext()&&(!newPayeeId.equals(currentPayeeId))){
						payee = hearthIterator.next();
						if(payee.getId().equals(newPayeeId)){
							currentPayeeId = payee.getId();
						}
					}
				}
				gmNotification += "\nHearth " + payee.getName() + ": " + bill.getDescription();
			}
		} else {
			gmNotification += "No-one received any penalties this season.";
		}
		snf.updateBankerNotifications(gmNotification, game);
	}
}
