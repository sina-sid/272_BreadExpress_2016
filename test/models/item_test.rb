require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  
  # Testing relationships
  should have_many(:order_items)
  should have_many(:item_prices)

  # Testing validations
  should validate_presence_of(:name)
  should validate_presence_of(:category)
  should validate_presence_of(:units_per_item)
  should validate_numericality_of(:weight).is_greater_than(0)
  should validate_numericality_of(:units_per_item).is_greater_than(0)
  should validate_uniqueness_of(:name).case_insensitive

  should allow_value("bread").for(:category)
  should allow_value("pastries").for(:category)
  should allow_value("muffins").for(:category)
  should_not allow_value("bad").for(:category)
  should_not allow_value("hacker").for(:category)
  should_not allow_value(10).for(:category)
  should_not allow_value("vp").for(:category)
  should_not allow_value(nil).for(:category)
  
  # rest with contexts
  context "Within context" do
    setup do
      create_muffins
    end
    
    teardown do
      destroy_muffins
    end

    should "show that scope exists for alphabeticizing items" do
      assert_equal ["Blueberry Muffins", "Chocolate Muffins", "Plain Muffins"], Item.alphabetical.all.map(&:name)
    end

    should "show that there are two active items and one inactive items" do
      assert_equal ["Blueberry Muffins", "Chocolate Muffins"], Item.active.all.map(&:name).sort
      assert_equal ["Plain Muffins"], Item.inactive.all.map(&:name).sort
    end

    should "return all items in a particular category" do
      create_pastries
      assert_equal ["Apple Pie", "Cookie"], Item.for_category("pastries").all.map(&:name).sort
      destroy_pastries
    end

    should "return the current price for an item" do
      create_muffin_prices
      assert_equal 12.99, @choc_muffins.current_price
      destroy_muffin_prices
	  end

  	should "return a previous price for an item" do
      create_muffin_prices
      assert_equal 7.99, @choc_muffins.price_on_date(2.years.ago.to_date)
      destroy_muffin_prices
  	end

  	should "show that items that have been previously shipped cannot be destroyed but are made inactive" do
      create_pastries
      create_alexe_o2_order_items
      deny @choc_muffins.order_items.shipped.to_a.empty?
      deny @choc_muffins.destroy
      @choc_muffins.reload
      deny @choc_muffins.active
      destroy_pastries
  	  destroy_alexe_o2_order_items
  	end

    should "show that items not shipped can be destroyed" do
      create_pastries
      create_alexe_o2_order_items
      assert @cookie.order_items.shipped.to_a.empty?
      assert @cookie.destroy
      destroy_pastries
      destroy_alexe_o2_order_items
    end

    should "show that a destroyed item is not part of unshipped, unpaid orders" do
      create_pastries
      create_customer_users
      create_customers
      create_addresses
      create_orders
      create_alexe_o2_order_items

      # Case 1: Item never shipped
      # Item should be destroyed and no order items should be found containing this item_id

      # Case 2: Item has been shipped, set to inactive
      # Show item is set to inactive
      # Create array of all item_ids from order_items that are unpaid, unshipped
      # Show this array does not include this item's item_id

      # unshipped_items = Item.order_items.
      # cookie_id = @cookie.id
      # @cookie.destroy


      destroy_pastries
      destroy_customer_users
      destroy_customers
      destroy_addresses
      destroy_orders
      destroy_alexe_o2_order_items
    end

  end

end
