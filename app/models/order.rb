class Order < ActiveRecord::Base
  belongs_to :address
  belongs_to :customer

  # Callbacks
  before_save :is_customer_active?
  before_save :is_address_active?

  # Scopes
  scope :chronological, -> { order('date DESC') }
  scope :paid, -> { where('payment_receipt NOT NULL') } # how to check this?
  scope :for_customer, -> (customer_id) { where("customer_id = ?", customer_id) }

  # Other methods
  def self.pay
  	paid_for = Order.paid.map{|o| o.id}
  	unless paid_for.include?(self.id)
  	  payment_receipt = self.payment_receipt
  	  self.payment_receipt = encode64(payment_receipt)
  	  # self.save!
  	end
  end

  private

  def is_customer_active?
    self.customer.active == true
  end

  def is_address_active?
  	self.address.active == true
  end

end
