class Address < ActiveRecord::Base
  has_many :orders
  belongs_to :customer

  # Callbacks
  before_create :is_duplicate? #shouldn't this be before save?
  before_save :is_active?


  # Validations
  validate_presence_of :recipient, :street_1, :zip
  validates_format_of :zip, with: /\A\d{5}\z/, message: "should be five digits long"
  validates_inclusion_of :state, :in => %w[AL AK AR CA CO CT DE PA OH WV], message: "is not an option"

  # Scopes
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :by_recipient, -> { order('recipient') }
  scope :by_customer, -> { joins(:customer).order('last_name') }
  scope :shipping, -> { where(is_billing: false) } #not sure about this
  scope :billing, -> { where(is_billing: true) }

  # STATES_LIST = [['Alabama', 'AL'],['Alaska', 'AK'],['Arizona', 'AZ'],['Arkansas', 'AR'],['California', 'CA'],['Colorado', 'CO'],['Connectict', 'CT'],['Delaware', 'DE'],['District of Columbia ', 'DC'],['Florida', 'FL'],['Georgia', 'GA'],['Hawaii', 'HI'],['Idaho', 'ID'],['Illinois', 'IL'],['Indiana', 'IN'],['Iowa', 'IA'],['Kansas', 'KS'],['Kentucky', 'KY'],['Louisiana', 'LA'],['Maine', 'ME'],['Maryland', 'MD'],['Massachusetts', 'MA'],['Michigan', 'MI'],['Minnesota', 'MN'],['Mississippi', 'MS'],['Missouri', 'MO'],['Montana', 'MT'],['Nebraska', 'NE'],['Nevada', 'NV'],['New Hampshire', 'NH'],['New Jersey', 'NJ'],['New Mexico', 'NM'],['New York', 'NY'],['North Carolina','NC'],['North Dakota', 'ND'],['Ohio', 'OH'],['Oklahoma', 'OK'],['Oregon', 'OR'],['Pennsylvania', 'PA'],['Rhode Island', 'RI'],['South Carolina', 'SC'],['South Dakota', 'SD'],['Tennessee', 'TN'],['Texas', 'TX'],['Utah', 'UT'],['Vermont', 'VT'],['Virginia', 'VA'],['Washington', 'WA'],['West Virginia', 'WV'],['Wisconsin ', 'WI'],['Wyoming', 'WY']]

  #Other methods

  private
  def is_duplicate?
  	# true if (self.recipient)
  end

  def is_active?
  	self.customer.active == true
  end
end
