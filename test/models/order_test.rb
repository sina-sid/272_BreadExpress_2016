require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  should belong_to(:customer)
  should belong_to(:address)

  context "Creating a context for addresses" do
    setup do
      create_customers
      create_addresses
      create_orders
    end

    teardown do
      remove_customers
      remove_addresses
      remove_orders
    end

    
  end
end
