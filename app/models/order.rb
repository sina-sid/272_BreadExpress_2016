class Order < ActiveRecord::Base
  belongs_to :address
  belongs_to :customer
end
