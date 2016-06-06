class User < ActiveRecord::Base
  has_secure_password
  include BreadExpressHelpers::Validations

  # Relationships  
  has_one :customer # not sure about this

  # Scopes
  scope :active,        -> { where(active: true) }
  scope :inactive,      -> { where(active: false) }
  scope :employees,		-> { where.not(role: 'customer') }
  scope :alphabetical,  -> { order(:username) }
  scope :by_role, 		-> { order(:role) }
  
  # Validations
  validates_uniqueness_of :username, case_sensitive: false
  validates_presence_of :password, on: :create 
  validates_presence_of :password_confirmation, on: :create 
  validates_confirmation_of :password, message: "does not match"
  validates_length_of :password, minimum: 4, message: "must be at least 4 characters long"

  # Other methods
  def role?
  	return false if (self.nil? || self.role.nil?)
    self.role.downcase.to_sym == authorized_role
  end

  # login with username
  def self.authenticate(email, password)
    find_by_username(username).try(:authenticate, password)
  end
  
end
