class Order < ActiveRecord::Base
  require 'base64'
  require 'credit_card'

  attr_accessor :credit_card_number, :expiration_year, :expiration_month

  # Relationships
  belongs_to :customer
  belongs_to :address
  has_many :order_items

  # Callbacks
  before_destroy :is_destroyable?
  after_destroy :clear_order_items

  # Scopes
  scope :chronological, -> { order(date: :desc) }
  scope :paid,          -> { where.not(payment_receipt: nil) }
  scope :for_customer,  ->(customer_id) { where(customer_id: customer_id) }

  # Validations
  validates_date :date
  validates_numericality_of :grand_total, greater_than_or_equal_to: 0
  validate :customer_is_active_in_system
  validate :address_is_active_in_system
  # validate :credit_card_number_is_valid
  # validate :credit_card_expiration_is_valid

  # Other methods
  def pay
    new_card
    return false unless self.payment_receipt.nil?
    generate_payment_receipt
    self.save!
    self.payment_receipt
  end

  def is_editable?
    false if (self.order_items == nil or self.order_items.unshipped.empty?)
    true 
  end

  def self.not_shipped
    Order.joins(:order_items).where(shipped_on: nil)
  end

  def total_weight
    total = 0
    all_order_items = self.order_items.to_a
    all_order_items.each do |order_item|
      total += order_item.weight
    end
    total
  end

  def shipping_costs
    base = 2.00
    weight = self.total_weight
    if weight <= 5.99
      base
    else
      base+((weight-6.00)*0.25)
    end
  end

  def credit_card_type
    new_card
    return "N/A" unless @credit_card.valid?
    @credit_card.type.name
  end
  
  private
  def new_card
    @credit_card = CreditCard.new(credit_card_number, expiration_year, expiration_month)
  end

  def customer_is_active_in_system
    all_customer_ids = Customer.active.map(&:id)
    unless all_customer_ids.include?(self.customer_id)
      errors.add(:customer, "is not an active customer in the system")
    end
  end

  def address_is_active_in_system
    all_address_ids = Address.active.map(&:id)
    unless all_address_ids.include?(self.address_id)
      errors.add(:address, "is not an active address in the system")
    end
  end

  def generate_payment_receipt
    self.payment_receipt = Base64.encode64("order: #{self.id}; amount_paid: #{self.grand_total}; received: #{self.date}; card: #{@credit_card.type.name} #{credit_card_number.to_s.last(4)}")
  end

  def is_destroyable?
    @destroyable = (self.order_items == nil or self.order_items.shipped.empty?)
  end

  def remove_order_items
    @items = self.order_items
    @items.each {|s| s.destroy} unless @items.empty?
  end

  def clear_order_items
    if @destroyable
      remove_order_items
    end
    @destroyable = nil
  end
end
