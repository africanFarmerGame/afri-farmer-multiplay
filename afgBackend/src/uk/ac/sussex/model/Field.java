package uk.ac.sussex.model;

public class Field extends Location {
	private Integer quality;
	private PlayerChar owner;
	private Hearth hearth;
	private Asset crop;
	private Integer cropAge;
	private Integer cropHealth;
	private Integer cropPlanting;
	private Asset fertiliser;
	private Integer cropWeeded = 0;
	
	public static final Integer EARLY_PLANTING = 0;
	public static final Integer LATE_PLANTING = 1;
	
	private static final int MAX_HEALTH = 100; 
	
	public Field(){
		super();
		this.addOptionalParam("Id");
		this.addOptionalParam("Quality");
		this.addOptionalParam("Owner");
		this.addOptionalParam("Hearth");
		this.addOptionalParam("Crop");
		this.addOptionalParam("CropAge");
		this.addOptionalParam("CropHealth");
		this.addOptionalParam("CropPlanting");
		this.addOptionalParam("Fertiliser");
	}
	
	@Override
	public String getType(){
		return "FIELD";
	}	
	/**
	 * @param quality the quality to set
	 */
	public void setQuality(Integer quality) {
		this.quality = quality;
	}
	/**
	 * @return the quality
	 */
	public Integer getQuality() {
		return quality;
	}
	/**
	 * @param owner the owner to set
	 */
	public void setOwner(PlayerChar owner) {
		this.owner = owner;
	}
	/**
	 * @return the owner
	 */
	public PlayerChar getOwner() {
		return owner;
	}
	/**
	 * @param hearth the hearth to set
	 */
	public void setHearth(Hearth hearth) {
		this.hearth = hearth;
	}
	/**
	 * @return the hearth
	 */
	public Hearth getHearth() {
		return hearth;
	}

	/**
	 * @return the crop
	 */
	public Asset getCrop() {
		return crop;
	}

	/**
	 * @param crop the crop to set
	 */
	public void setCrop(Asset crop) {
		this.crop = crop;
	}

	/**
	 * @return the cropAge
	 */
	public Integer getCropAge() {
		return cropAge;
	}

	/**
	 * @param cropAge the cropAge to set
	 */
	public void setCropAge(Integer cropAge) {
		this.cropAge = cropAge;
	}

	/**
	 * @return the cropHealth
	 */
	public Integer getCropHealth() {
		return cropHealth;
	}

	/**
	 * @param cropHealth the cropHealth to set
	 */
	public void setCropHealth(Integer cropHealth) {
		if(cropHealth == null){
			this.cropHealth = cropHealth;
		} else if(cropHealth>MAX_HEALTH){
			this.cropHealth = MAX_HEALTH;
		} else if(cropHealth<0) {
			this.cropHealth = 0;
		} else {
			this.cropHealth = cropHealth;
		}
	}

	/**
	 * @return the cropPlanting
	 */
	public Integer getCropPlanting() {
		return cropPlanting;
	}

	/**
	 * @param cropPlanting the cropPlanting to set
	 */
	public void setCropPlanting(Integer cropPlanting) {
		this.cropPlanting = cropPlanting;
	}

	/**
	 * @return the fertiliser
	 */
	public Asset getFertiliser() {
		return fertiliser;
	}

	/**
	 * @param fertiliser the fertiliser to set
	 */
	public void setFertiliser(Asset fertiliser) {
		this.fertiliser = fertiliser;
	}
	/**
	 * @return the cropWeeded
	 */
	public Integer getCropWeeded() {
		return cropWeeded;
	}

	/**
	 * @param cropWeeded the cropWeeded to set
	 */
	public void setCropWeeded(Integer cropWeeded) {
		this.cropWeeded = cropWeeded;
	}

	public void clearCrop(){
		setCrop(null);
		setCropAge(null);
		setCropHealth(null);
		setCropPlanting(null);
		setFertiliser(null);
		setCropWeeded(0);
	}
	public Integer calculatePossibleYield() throws Exception{
		Integer yield;
		AssetFactory af = new AssetFactory();
		AssetCrop fullCrop = (AssetCrop) af.fetchAsset(getCrop().getId());
		
		if(getFertiliser()!=null){
			FertiliserCropEffect fce = af.fetchFertiliserCropEffect(getFertiliser(), fullCrop);
			if(getCropPlanting() == Field.EARLY_PLANTING){
				yield = fce.getEpYield();
			} else {
				yield = fce.getLpYield();
			}
		} else {
			if(this.getCropPlanting()==Field.EARLY_PLANTING){
				yield = fullCrop.getEPYield();
			} else {
				yield = fullCrop.getLPYield();
			}
		} 
		Integer harvestAmount = (int) Math.round(yield*cropHealth/100);
		return harvestAmount;
	}
	public Integer calculateYield(SeasonDetail sd) throws Exception{
		
		HazardFactory hf = new HazardFactory();
		Integer cropHealth = this.getCropHealth();
		FieldHazardHistory fhh = hf.fetchCurrentFieldHazard(this, sd);
		if(fhh!=null){
			CropHazardEffect hazardEffect = hf.fetchCropHazardEffect(fhh.getCropHazardEffect().getId());
			if(fhh.getMitigated()==FieldHazardHistory.MITIGATED){
				cropHealth = cropHealth - hazardEffect.getMitigatedRed();
			} else {
				cropHealth = cropHealth - hazardEffect.getReduction();
			}
		}
		if(cropHealth<0){
			cropHealth = 0;
		}
		this.setCropHealth(cropHealth);
		return calculatePossibleYield();
	}
}
