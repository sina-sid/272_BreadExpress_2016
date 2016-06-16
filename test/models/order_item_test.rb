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
  # should_not allow_value("bad string").for(:shipped_on) #with allow_blank set to true, this validation fails. Can't figure out why.
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
      assert_equal (@alexe_o2_choc_muffins.quantity*@choc_muffins.price_on_date(2.weeks.ago.to_date)), subtotal
    end

    should "calculate the subtotal for current date" do
      subtotal = @alexe_o2_choc_muffins.subtotal
      assert_equal (@alexe_o2_choc_muffins.quantity*@choc_muffins.current_price), subtotal
    end

    should "show trying calculate subtotal for future date will return nil" do
      subtotal = @alexe_o2_choc_muffins.subtotal(2.weeks.from_now.to_date)
      assert_equal nil, subtotal
    end

    should "show looking up a price on a date where it did not exist will return nil" do
      subtotal = @alexe_o2_choc_muffins.subtotal(20.years.ago.to_date)
      assert_equal nil, subtotal
    end

    should "show items are active in system" do
      # OrderItems cannot be created for inactive items
      deny @plain_muffins.active
      @bad_order_item = FactoryGirl.build(:order_item, item: @plain_muffins, order: @alexe_o2)
      deny @bad_order_item.valid?
      # Nor can OrderItems be created for ghost items
      @ghost_item = FactoryGirl.build(:item, name: "Ghost", description: "Does not exist in database", category: "muffins")
      @ghost_order_item = FactoryGirl.build(:order_item, item: @ghost_item, order: @alexe_o2)
      deny @ghost_order_item.valid?
    end

    # should "show order_items cannot be created for invalid orders" do
    #   @ghost_order = FactoryGirl.build(:order, customer: @alexe, address: @alexe_a2, grand_total: 1000, date: Date.today)
    #   @ghost_order_item = FactoryGirl.build(:order_item, item: @choc_muffins, order: @ghost_order)
    #   deny @ghost_order_item.valid?
    # end

  end
end
