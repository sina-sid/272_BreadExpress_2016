class Item < ActiveRecord::Base
  # Relationships
  has_many :order_items
  has_many :item_prices

  # Callbacks
  before_destroy :is_destroyable?
  after_rollback :clear_order_items_and_inactive

  # Scopes
  scope :active,        -> { where(active: true) }
  scope :inactive,      -> { where(active: false) }
  scope :alphabetical,  -> { order(:name) }
  scope :for_category,  -> (category) { where("category = ?", category)}

  # Validations
  validates_inclusion_of :category, in: %w[bread muffins pastries], message: "is not an option"
  validates_presence_of :name, :category, :units_per_item, :weight
  validates_numericality_of :weight, greater_than: 0
  validates_numericality_of :units_per_item, greater_than: 0
  validates_uniqueness_of :name, case_sensitive: false

  # Other methods
  def current_price
  	active_price = self.item_prices.find_by(end_date: nil)
  	return nil if (active_price.nil?)
  	active_price.price
  end

  def price_on_date(date)
    set_price = self.item_prices.find_by("start_date <= ? AND (end_date IS NULL OR end_date > ?)", date, date)
    return nil if (set_price.nil?)
    set_price.price
  end

  # Private methods for callbacks
  private
  def is_destroyable?
    @destroyable = self.order_items.empty?
  end
  
  def convert_to_inactive
    self.update_attribute(:active, false) if !@destroyable.nil? && @destroyable == false
    @destroyable = nil
  end

  def remove_order_items
    @unshipped_and_unpaid.each do |order_item|
      OrderItem.find(order_item.id).destroy
    end
  end

  def find_order_items
    @unshipped_and_unpaid = Array.new
    unshipped = OrderItem.find_by(item_id: self.id, shipped_on: nil).to_a
    unshipped.each do |order_item|
      @unshipped_and_unpaid << order_item if order_item.order.payment_receipt = nil
    end
    remove_order_items unless unshipped_and_unpaid.empty?
  end

  def clear_order_items_and_inactive
    if !@destroyable
      find_order_items
      convert_to_inactive
    end
    @destroyable = nil
  end
end
