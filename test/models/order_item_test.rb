require 'test_helper'

class OrderItemTest < ActiveSupport::TestCase
  should belong_to(:order)
  should belong_to(:item)

  # Testing validations with matchers
  should validate_numericality_of(:quantity).is_greater_than(0)
  should validate_date(:shipped_on).on_or_before(Date.today)

  context "Within context" do
    setup do 
      create_breads
      create_bread_prices
      create_customer_users
      create_customers
      create_addresses
      create_orders
      create_order_items
    end
    
    teardown do
      destroy_breads
      destroy_bread_prices
      destroy_customer_users
      destroy_customers
      destroy_addresses
      destroy_orders
      destroy_order_items
    end

    should "display all order items that have been shipped" do
      assert_equal [], OrderItem.shipped.all.map{|o| o.item.name}.sort
    end

    should "display all order items that have yet to be shipped" do
      assert_equal [], OrderItem.unshipped.all.map{|o| o.item.name}.sort
    end

    should "calculate the subtotal for past date" do
      subtotal = @honey_wheat.subtotal(2.weeks.ago.to_date)
      assert_equal (@honey_wheat_o1.quantity*@honey_wheat.price_on_date(2.weeks.ago.to_date)), subtotal
    end

    should "calculate the subtotal for current date" do
      subtotal = @honey_wheat.subtotal
      assert_equal (@honey_wheat_o1.quantity*@honey_wheat.current_price), subtotal
    end

    should "calculate subtotal for future date" do
      # wut
    end

    should "show items are active in system" do
      # @choc_muffins_new_price = FactoryGirl.build(:item_price)
      # assert @choc_muffins.active
      # # need better test for this
      # deny @plain_muffins.active
      # @plain_muffins_price = FactoryGirl.build(:item_price)
      # deny @plain_muffins_price.valid?
    end

  end
end
