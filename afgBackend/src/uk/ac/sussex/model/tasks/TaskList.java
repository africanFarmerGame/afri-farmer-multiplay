package uk.ac.sussex.model.tasks;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Order;

import uk.ac.sussex.general.SessionFactoryHelper;
import uk.ac.sussex.model.AllChars;
import uk.ac.sussex.model.Asset;
import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.Location;
import uk.ac.sussex.model.SeasonDetail;
import uk.ac.sussex.model.SeasonDetailFactory;
import uk.ac.sussex.model.base.OrderList;
import uk.ac.sussex.model.base.RestrictionList;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;
import uk.ac.sussex.model.seasons.SeasonList;

public abstract class TaskList {
	protected Game game;
	
	public TaskList(Game game){
		this.game = game;
		this.setupPotentialTasks();
	}
	protected abstract void setupPotentialTasks();
	public abstract Task newTaskInstance(String taskType) throws Exception;
	
	protected void addPotentialTask(Task newTask, String seasonId) {
		SeasonList sl = game.fetchSeasonList();
		sl.addTaskToSeason(newTask, seasonId);
	}
	public Set<Task> getPotentialTasks(String seasonId){
		SeasonList sl = game.fetchSeasonList();
		return sl.fetchSeasonalTasks(seasonId);
	}
	
	public List<Task> getHouseholdTasks(Hearth household) throws Exception{

		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("household", household);
		OrderList orders = new OrderList();
		orders.addDescending("id");
		List<Task> objects = fetchMultipleTasks(restrictions, orders);
		
		return objects;
	}
	public List<Task> getCurrentHouseholdTasks(Hearth household) throws Exception {
		GameFactory gf = new GameFactory();
		Game game = gf.fetchGame(household.getGame().getId());
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		SeasonDetail sd = sdf.fetchCurrentSeasonDetail(game);
		
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("household", household);
		restrictions.addEqual("season", sd);
		List<Task> objects = fetchMultipleTasks(restrictions);
		return objects;
	}
	public Task getHouseholdTask(Integer taskId) throws Exception {
		Task object = null;
		SessionFactory sessionFactory = SessionFactoryHelper.getSessionFactory();
		Session session = sessionFactory.getCurrentSession(); 
		
		try {
			session.getTransaction().begin();
			
			object = (Task) session.get(Task.class, taskId);
			session.getTransaction().commit();
		} catch (HibernateException e) {
			e.printStackTrace();
			session.getTransaction().rollback();
			throw (new Exception("hibernate problem! "+e.getMessage()));
		}
		if(object == null){
			throw (new Exception("No task with that identifier: "+ taskId));
		}
		return object;
	}
	public Integer countPendingLocationTasks(Hearth household, Location loc, String taskType) throws Exception {
		Integer pendingTaskCount = 0;
		String query = "select count(*) from Task t " +					
					"where t.household = " + household.getId().toString() +  
					" and t.location = " + loc.getId().toString() + 
					" and t.status = " + Task.PENDING +
					" and t.deleted = 0 " +
					" and t.class = '" + taskType + "'";
		
		SessionFactory sessionFactory = SessionFactoryHelper.getSessionFactory();
		Session session = sessionFactory.getCurrentSession();
		try {
			session.getTransaction().begin();
			pendingTaskCount = ((Number) session.createQuery(query).iterate().next()).intValue();
			session.getTransaction().commit();
		} catch (Exception e){
			session.getTransaction().rollback();
			throw e;
		}
		return pendingTaskCount;
	}
	public Integer countPendingLocationTasks(Hearth household, Location loc) throws Exception {
		Integer pendingTaskCount = 0;
		String query = "select count(*) from Task t " +					
					"where t.household = " + household.getId().toString() +  
					" and t.location = " + loc.getId().toString() + 
					" and t.status = " + Task.PENDING + 
					" and t.deleted = 0";
		
		SessionFactory sessionFactory = SessionFactoryHelper.getSessionFactory();
		Session session = sessionFactory.getCurrentSession();
		try{
			session.getTransaction().begin();
			pendingTaskCount = ((Number) session.createQuery(query).iterate().next()).intValue();
			session.getTransaction().commit();
		} catch (Exception e) {
			session.getTransaction().rollback();
			throw e;
		}
		return pendingTaskCount;
	}

	public Integer countPendingActorTasks(Hearth household, AllChars actor) throws Exception {
		Integer pendingTaskCount = 0;
		String query = "select count(*) from Task t " +					
					"where t.household = " + household.getId().toString() +  
					" and t.actor = " + actor.getId().toString() + 
					" and t.status = " + Task.PENDING +
					" and t.deleted = 0";
		
		SessionFactory sessionFactory = SessionFactoryHelper.getSessionFactory();
		Session session = sessionFactory.getCurrentSession();
		try {
			session.getTransaction().begin();
			pendingTaskCount = ((Number) session.createQuery(query).iterate().next()).intValue();
			session.getTransaction().commit();
		} catch (Exception e){
			session.getTransaction().rollback();
			throw e;
		}
		return pendingTaskCount;
	}
	
	public Integer countPendingAssetAmount(Hearth household, Asset asset) throws Exception {
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("household", household);
		restrictions.addEqual("asset", asset);
		restrictions.addEqual("status", Task.PENDING);
		restrictions.addEqual("deleted", 0);
		List<Task> tasks = fetchMultipleTasks(restrictions);
		Integer assetAmount = 0;
		for(Task task: tasks){
			assetAmount += task.getAssetAmount();
		}
		return assetAmount;
	}
	public List<Task> fetchPendingTasks(Hearth household, String taskType) throws Exception {
		List<Task> pendingTasks = null;
		String query = "select t from Task t " +					
					"where t.household = " + household.getId().toString() +  
					" and t.status = " + Task.PENDING +
					" and t.class = '" + taskType + "'";
		
		SessionFactory sessionFactory = SessionFactoryHelper.getSessionFactory();
		Session session = sessionFactory.getCurrentSession();
		session.getTransaction().begin();
		@SuppressWarnings("rawtypes")
		Iterator results = null;
		try {
			results = session.createQuery(query).iterate();
		} catch (Exception e) {
			session.getTransaction().commit();
			throw e;
		}
		if(results != null){
			pendingTasks = new ArrayList<Task>();
			while(results.hasNext()){
				pendingTasks.add((Task)results.next());
			}
		}
		session.getTransaction().commit();
		return pendingTasks;
	}
	public int countAllPendingTasks(Hearth household) throws Exception {
		String query = "select count(*) from Task t " +					
					"where t.household = " + household.getId().toString() +  
					" and t.status = " + Task.PENDING +
					" and t.deleted = 0";
		
		SessionFactory sessionFactory = SessionFactoryHelper.getSessionFactory();
		Session session = sessionFactory.getCurrentSession();
		int pendingTaskCount;
		try {
			session.getTransaction().begin();
			pendingTaskCount = ((Number) session.createQuery(query).iterate().next()).intValue();
			session.getTransaction().commit();
		} catch (Exception e){
			session.getTransaction().rollback();
			throw e;
		}
		return pendingTaskCount;
	}
	public List<Task> fetchCurrentExternalTasks(Location loc, String taskType) throws Exception {
		SeasonDetail sd = this.game.getCurrentSeasonDetail();
		List<Task> pendingTasks = null;
		String query = "select t from Task t " +					
					"where t.location = " + loc.getId().toString() +  
					" and t.season = " + sd.getId().toString() +
					" and t.class = '" + taskType + "'" +
					" and t.deleted = 0";
		
		SessionFactory sessionFactory = SessionFactoryHelper.getSessionFactory();
		Session session = sessionFactory.getCurrentSession();
		session.getTransaction().begin();
		@SuppressWarnings("rawtypes")
		Iterator results = null;
		try {
			results = session.createQuery(query).iterate();
		} catch (Exception e) {
			session.getTransaction().rollback();
			throw e;
		}
		if(results != null){
			pendingTasks = new ArrayList<Task>();
			while(results.hasNext()){
				pendingTasks.add((Task)results.next());
			}
		}
		session.getTransaction().commit();
		return pendingTasks;
	}
	public List<Task> fetchSeasonalTasks(Hearth hearth, String taskType, SeasonDetail sd) throws Exception{
		String query = "select t from Task t " +
						"where t.household = " + hearth.getId().toString() +
						" and t.season = " + sd.getId().toString() +
						" and t.class = '" + taskType + "'" + 
						" and t.deleted = 0";
		
		List<Task> seasonalTasks = null;
		
		SessionFactory sessionFactory = SessionFactoryHelper.getSessionFactory();
		Session session = sessionFactory.getCurrentSession();
		session.getTransaction().begin();
		@SuppressWarnings("rawtypes")
		Iterator results = null;
		try {
			results = session.createQuery(query).iterate();
		} catch (Exception e) {
			session.getTransaction().commit();
			throw e;
		}
		if(results != null){
			seasonalTasks = new ArrayList<Task>();
			while(results.hasNext()){
				seasonalTasks.add((Task)results.next());
			}
		}
		session.getTransaction().commit();
		return seasonalTasks;
	}
	
	public List<Task> fetchTasksToRenumber(Hearth hearth, Integer tasknumber) throws Exception {
		RestrictionList rl = new RestrictionList();
		rl.addEqual("household", hearth);
		rl.addGTInt("taskNumber", tasknumber);
		rl.addEqual("deleted", 0);
		List<Task> tasks = fetchMultipleTasks(rl);
		return tasks;
	}
	public int calculateNextTaskNumber(Hearth hearth) throws Exception {
		RestrictionList rl = new RestrictionList();
		rl.addEqual("household", hearth);
		rl.addEqual("deleted", 0);
		List<Task> tasks = fetchMultipleTasks(rl);
		return tasks.size()+1;
	}
	@SuppressWarnings("unchecked")
	private List<Task> fetchMultipleTasks(RestrictionList restrictions) throws Exception{
		List<Task> objects = null;
		SessionFactory sessionFactory = SessionFactoryHelper.getSessionFactory();
		Session session = sessionFactory.getCurrentSession(); 
		try{
			session.getTransaction().begin();
			Criteria crit = session.createCriteria(Task.class);
			for (Criterion c: restrictions){
				crit.add(c);
			}
			objects = crit.list();
			session.getTransaction().commit();
		} catch (Exception e) {
			session.getTransaction().rollback();
			throw e;
		}
		return objects;
	}
	@SuppressWarnings("unchecked")
	private List<Task> fetchMultipleTasks(RestrictionList restrictions, OrderList orders) throws Exception{
		List<Task> objects = null;
		SessionFactory sessionFactory = SessionFactoryHelper.getSessionFactory();
		Session session = sessionFactory.getCurrentSession(); 
		try{
			session.getTransaction().begin();
			Criteria crit = session.createCriteria(Task.class);
			for (Criterion c: restrictions){
				crit.add(c);
			}
			for (Order order: orders) {
				crit.addOrder(order);
			}
			objects = crit.list();
			session.getTransaction().commit();
		} catch (Exception e) {
			session.getTransaction().rollback();
			throw e;
		}
		return objects;
	}
}
