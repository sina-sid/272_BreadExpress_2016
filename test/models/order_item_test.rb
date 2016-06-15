require 'test_helper'

class OrderItemTest < ActiveSupport::TestCase
  should belong_to(:order)
  should belong_to(:item)

  # Testing validations with matchers
  should validate_numericality_of(:quantity).is_greater_than(0)

  should allow_value(Date.today).for(:shipped_on)
  should allow_value(1.day.ago.to_date).for(:shipped_on)
  should allow_value(nil).for(:shipped_on)
  should_not allow_value(1.day.from_now.to_date).for(:shipped_on)
  should_not allow_value("bad").for(:shipped_on)
  should_not allow_value(2).for(:shipped_on)
  should_not allow_value(3.14159).for(:shipped_on)

  context "Within context" do
    setup do 
      create_muffins
      create_muffin_prices
      create_pastries
      create_customer_users
      create_customers
      create_addresses
      create_orders
      create_alexe_o2_order_items
    end
    
    teardown do
      destroy_muffins
      destroy_muffin_prices
      destroy_pastries
      destroy_customer_users
      destroy_customers
      destroy_addresses
      destroy_orders
      destroy_alexe_o2_order_items
    end

    should "display all order items that have been shipped" do
      assert_equal ["Blueberry Muffins", "Chocolate Muffins"], OrderItem.shipped.all.map{|o| o.item.name}.sort
    end

    should "display all order items that have yet to be shipped" do
      assert_equal ["Apple Pie"], OrderItem.unshipped.all.map{|o| o.item.name}.sort
    end

    should "calculate the subtotal for past date" do
      subtotal = @alexe_o2_choc_muffins.subtotal(2.weeks.ago.to_date)
      assert_equal (@alexe_o2_choc_muffins.quantity*@alexe_o2_choc_muffins.price_on_date(2.weeks.ago.to_date)), subtotal
    end

    should "calculate the subtotal for current date" do
      subtotal = @alexe_o2_choc_muffins.subtotal
      assert_equal (@alexe_o2_choc_muffins.quantity*@alexe_o2_choc_muffins.current_price), subtotal
    end

    # should "calculate subtotal for future date" do
    # end

    should "show items are active in system" do
      # @alexe_o2_choc_muffins_new_price = FactoryGirl.build(:item_price)
      # assert @alexe_o2_choc_muffins.active
      # # need better test for this
      # deny @plain_muffins.active
      # @plain_muffins_price = FactoryGirl.build(:item_price)
      # deny @plain_muffins_price.valid?
    end

  end
end
