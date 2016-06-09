class User < ActiveRecord::Base
  has_secure_password

  # Relationships  
  has_one :customer

  # Scopes
  scope :active,        -> { where(active: true) }
  scope :inactive,      -> { where(active: false) }
  scope :employees,		-> { where.not(role: 'customer') }
  scope :alphabetical,  -> { order(:username) }
  scope :by_role, 		-> { order(:role).order(:username) }
  
  # Validations
  validates_uniqueness_of :username, case_sensitive: false
  validates_presence_of :password, on: :create 
  validates_presence_of :password_confirmation, on: :create 
  validates_confirmation_of :password, message: "does not match"
  validates_length_of :password, minimum: 4, message: "must be at least 4 characters long"

  # Other methods
  def role?(authorized_role)
  	return false if (self.nil? || self.role.nil?)
    self.role.downcase.to_sym == authorized_role
  end

  # login with username
  def self.authenticate(username, password)
    find_by_username(username).try(:authenticate, password)
  end
  
end
