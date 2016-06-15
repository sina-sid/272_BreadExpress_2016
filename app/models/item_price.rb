class ItemPrice < ActiveRecord::Base
  # Relationships
  belongs_to :item

  # Callbacks
  before_destroy :is_destroyable?
  before_create :set_end_date
  
  # Scopes
  scope :current,  	    -> { where(end_date: nil) }
  scope :for_date,      -> (date) { where("start_date <= ? AND (end_date = ? OR end_date > ?)", date, nil, date) }
  scope :for_item,       -> (item_id) { where("item_id = ?", item_id)}
  scope :chronological, -> { order(start_date: :desc) }

  # Validations
  validates_presence_of :price, :start_date
  validates_numericality_of :price, greater_than: 0
  validates_date :start_date, on_or_before: Date.today
  validates_date :end_date, on_or_after: :start_date, on_or_before: Date.today, allow_blank: true
  validate :item_is_active_in_system

  private
  def is_destroyable?
    @destroyable = false
  end

  def item_is_active_in_system
    all_item_ids = Item.active.map(&:id)
    unless all_item_ids.include?(self.item_id)
      errors.add(:item, "is not an active item in the system")
    end
  end

  def set_end_date
    old_price = ItemPrice.find_by(item_id: self.item_id, end_date: nil)
    if old_price == nil
      return true
    else
      old_price.update_attribute(:end_date, self.start_date.to_date)
    end
  end
end
