package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseFactory;
import uk.ac.sussex.model.base.BaseObject;

public class LocationFactory extends BaseFactory {
	public LocationFactory() {
		super(new Location());
	}
	public Location fetchLocation(Integer locId) throws Exception{
		BaseObject object = this.fetchSingleObject(locId);
		return (Location) object;
	}
}
