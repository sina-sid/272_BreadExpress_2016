class OrderItem < ActiveRecord::Base
  # Relationships
  belongs_to :item # not sure about this
  belongs_to :order

  # Scopes
  scope :shipped, 		-> { where.not(shipped_on: nil) }
  scope :unshipped,     -> { where(shipped_on: nil) }

  # Validations
  validates_numericality_of :quantity, greater_than: 0
  validates_date :shipped_on, on_or_before: Date.today, allow_blank: true
  validate :item_is_active_in_system

  # Methods
  def subtotal(date=Date.today)
    return nil if date > Date.today
    quantity = self.quantity
    price = ItemPrice.find_by("start_date <= ? AND (end_date IS NULL OR end_date > ?)", date, date)
    if price.nil?
      return nil
    else 
      return quantity*price.price
    end
  end

  private
  def item_is_active_in_system
    all_item_ids = Item.active.map(&:id)
    unless all_item_ids.include?(self.item_id)
      errors.add(:item, "is not an active item in the system")
    end
  end

end
