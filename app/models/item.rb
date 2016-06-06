class Item < ActiveRecord::Base
  # Relationships
  has_many :order_item
  has_many :item_prices

  # Callbacks
  before_destroy :is_destroyable?
  after_rollback :convert_to_inactive

  # Scopes
  scope :active,        -> { where(active: true) }
  scope :inactive,      -> { where(active: false) }
  scope :alphabetical,  -> { order(:name) }
  scope :for_category,  -> (category) { where("category: ?", category)}

  # Validations
  validates_presence_of :name, :category, :units_per_item, :weight
  validates_numericality_of :weight, greater_than: 0
  validates_numericality_of :units_per_item, greater_than: 0
  validates_uniqueness_of :name, case_sensitive: false # what else makes it unique?

  # Other methods
  def current_price
  	active_price = self.item_price.where(end_date: nil) # not sure about this
  	return nil if (active_price == nil || active_price == 0)
  	active_price
  end

  def price_on_date(date)
  	# woah, gotta do some math here
  end

  # Private methods for callbacks
  private
  def is_destroyable?
    @destroyable = self.order_items.empty?
  end
  
  def convert_to_inactive
    make_inactive if !@destroyable.nil? && @destroyable == false
    @destroyable = nil
  end

  def make_inactive
    self.update_attribute(:active, false)
  end
end
