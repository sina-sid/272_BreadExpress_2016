class OrderItem < ActiveRecord::Base
  belongs_to :item # not sure about this
  belongs_to :order
end
