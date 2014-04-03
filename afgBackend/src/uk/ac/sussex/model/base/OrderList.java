package uk.ac.sussex.model.base;

import java.util.ArrayList;

import org.hibernate.criterion.Order;

public class OrderList extends ArrayList<Order> {
	/**
	 * 
	 */
	private static final long serialVersionUID = 4627804547149468937L;

	public void addAscending(String propertyName){
		this.add(Order.asc(propertyName));
	}
	public void addDescending(String propertyName){
		this.add(Order.desc(propertyName));
	}
}
