class Customer < ActiveRecord::Base
  has_many :orders
  has_many :addresses

  # Callbacks
  before_save :reformat_phone

  # Validations
  validates_presence_of :first_name, :last_name, :email, :phone
  validates_format_of :phone, with: /\A\(?\d{3}\)?[-. ]?\d{3}[-.]?\d{4}\z/, message: "should be 10 digits (area code needed) and delimited with dashes only"
  validates_format_of :email, :with => /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))\z/i, :message => "is not a valid format"
  
  # Scopes
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :alphabetical, -> { order('last_name, first_name') }

  # Other methods
  def name
  	"#{last_name}, #{first_name}"
  end

  def proper_name
  	"#{first_name} #{last_name}"
  end

  private
  def reformat_phone
    phone = self.phone.to_s  # change to string in case input as all numbers 
    phone.gsub!(/[^0-9]/,"") # strip all non-digits
    self.phone = phone       # reset self.phone to new string
  end
  

end
