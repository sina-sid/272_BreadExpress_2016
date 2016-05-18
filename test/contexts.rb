# require needed files

require './test/sets/customer_contexts'
require './test/sets/address_contexts'
require './test/sets/order_contexts'

module Contexts
  # explicitly include all sets of contexts used for testing 
  include Contexts::CustomerContexts
  include Contexts::AddressContexts
  include Contexts::OrderContexts

  # create a method that builds all the unit testing contexts
  # all at once, in their proper order
  def build_unit_test_contexts
    create_customers
    create_addresses
    create_orders
  end

  def remove_unit_test_contexts
    remove_customers
    remove_addresses
    remove_orders
  end

end