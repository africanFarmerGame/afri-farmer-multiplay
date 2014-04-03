package uk.ac.sussex.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.hibernate.Session;
import org.hibernate.SessionFactory;

import uk.ac.sussex.general.SessionFactoryHelper;
import uk.ac.sussex.model.base.*;
import uk.ac.sussex.model.game.Game;

public class BillFactory extends BaseFactory {
	public BillFactory(){
		super(new Bill());
	}
	public Bill fetchFine(Integer fineId) throws Exception {
		return (Bill) this.fetchSingleObject(fineId);
	}
	public List<Bill> fetchHearthFines(Hearth hearth) throws Exception {
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("payee", hearth);
		OrderList order = new OrderList();
		order.addDescending("id");
		List<BaseObject> objects = this.fetchManyObjects(restrictions, order);
		List<Bill> fines = new ArrayList<Bill>();
		for(BaseObject object: objects){
			fines.add((Bill) object);
		}
		return fines;
	}
	public List<Bill> fetchOutstandingHearthFines(Hearth hearth, String fineDuration) throws Exception {
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("payee", hearth);
		restrictions.addEqual("duration", fineDuration);
		restrictions.addEqual("paid", 0);
		OrderList order = new OrderList();
		order.addAscending("id"); //Want to start by paying off the oldest. 
		List<BaseObject> objects = this.fetchManyObjects(restrictions, order);
		List<Bill> fines = new ArrayList<Bill>();
		for(BaseObject object: objects) {
			fines.add((Bill) object);
		}
		return fines;
	}
	public List<Bill> fetchOutstandingDeathDuty(Hearth hearth) throws Exception {
		String query = "select b from Bill b " +					
		"where b.payee = " + hearth.getId().toString() +  
		" and b.paid = 0 " +
		" and b.class = '" + BillDeathDuty.NAME + "'";
		List<BaseObject> objects = this.fetchManyByQuery(query);
		List<Bill> fines = new ArrayList<Bill>();
		for(BaseObject object: objects){
			fines.add((Bill) object);
		}
		return fines;
	}
	public List<Bill> AllOutstandingHearthFines(Hearth hearth) throws Exception {
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("payee", hearth);
		restrictions.addEqual("paid", 0);
		List<BaseObject> objects = this.fetchManyObjects(restrictions);
		List<Bill> bills = new ArrayList<Bill>();
		for(BaseObject object: objects) {
			bills.add((Bill) object);
		}
		return bills;
	}
	public List<Bill> fetchAllGameHearthFines(Game game) throws Exception {
		HearthFactory hf = new HearthFactory();
		Set<Hearth> gameHearths = hf.fetchGameHearths(game);
		List<Bill> bills = new ArrayList<Bill>();
		for (Hearth hearth: gameHearths){
			bills.addAll(this.fetchHearthFines(hearth));
		}
		return bills;
	}
	public Integer countHouseholdUnpaidBills(Hearth hearth) throws Exception {
		Integer pendingBillsCount = 0;
		String query = "select count(*) from Bill b " +					
					"where b.payee = " + hearth.getId().toString() +  
					" and b.paid != " + Bill.BEEN_PAID ;
		
		SessionFactory sessionFactory = SessionFactoryHelper.getSessionFactory();
		Session session = sessionFactory.getCurrentSession();
		try {
			session.getTransaction().begin();
			pendingBillsCount = ((Number) session.createQuery(query).iterate().next()).intValue();
			session.getTransaction().commit();
		} catch (Exception e){
			session.getTransaction().rollback();
			throw e;
		}
		return pendingBillsCount;
	}
	public List<Bill> fetchUnpaidCharacterBill(String billType, AllChars character) throws Exception {
		String query = "select b from Bill b " +					
		"where b.character = " + character.getId().toString() +  
		" and b.paid = 0 " +
		" and b.class = '" + billType + "'";
		List<BaseObject> objects = this.fetchManyByQuery(query);
		List<Bill> bills = new ArrayList<Bill>();
		for(BaseObject object: objects){
			bills.add((Bill) object);
		}
		return bills;
	}
	public List<Bill> fetchSeasonalHouseholdBills(String billType, Hearth payee, SeasonDetail sd) throws Exception {
		String query = "select b from Bill b " +					
		"where b.payee = " + payee.getId().toString() +  
		" and b.season = " + sd.getId().toString() +
		" and b.class = '" + billType + "'";
		List<BaseObject> objects = this.fetchManyByQuery(query);
		List<Bill> bills = new ArrayList<Bill>();
		for(BaseObject object: objects){
			bills.add((Bill) object);
		}
		return bills;
	}
	public static Bill newBill(String billType) throws Exception {
		if(billType.equals(BillPenalty.NAME)){
			return new BillPenalty();
		} else if (billType.equals(BillDeathDuty.NAME)){
			return new BillDeathDuty();
		} else if (billType.equals(BillHospital.NAME)){
			return new BillHospital();
		} else {
			throw new Exception("No bill of that kind available.");
		}
		
	}
	
}
