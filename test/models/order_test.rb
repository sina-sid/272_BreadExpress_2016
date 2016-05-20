require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  should belong_to(:customer)
  should belong_to(:address)

  context "Creating a context for orders" do
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

    should "order all orders chronologically" do
      assert_equal [], Order.chronological.map{|o| o.customer.last_name}
    end

    should "show that x orders have been paid for" do
      # assert_equal [], Order.paid.map{|o| o.customer.last_name}
    end

    should "show all orders for a particular customer" do
      assert_equal [22.5, 45.0], Order.by_customer(@abc).map{|o| o.grand_total}
    end

    should "only allow orders to be created for active customers" do
      @rob_order = FactoryGirl.build(:order, customer: @rob, address: @rob_address)
      deny @rob_order.valid?
      @cindy_order3 = FactoryGirl.build(:order, customer: @cindy, address: @cindy_nb_address)
      assert @cindy_order3.valid?
    end

    should "only allow orders to be created for active addresses" do
      @cindy_inactive_address = FactoryGirl.build(:address, recipient: "Abc Def", street_1: "4614 Fifth Avenue", zip: "15213", active: false)
      @cindy_order2 = FactoryGirl.build(:order, customer: @cindy, address: @cindy_inactive_address)
      deny @cindy_order2.valid?
      @cindy_order4 = FactoryGirl.build(:order, customer: @cindy, address: @cindy_nb_address)
      assert @cindy_order4.valid?
    end

    should "check self.pay works" do
    end

  end
end
