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
      @choc_muffins.destroy
      assert @choc_muffins.valid?
      deny @choc_muffins.active
      destroy_pastries
  	  destroy_alexe_o2_order_items
  	end

    should "show that items not shipped can be destroyed" do
      create_pastries
      create_alexe_o2_order_items
      @cookie.destroy
      deny @cookie.valid?
      destroy_pastries
      destroy_alexe_o2_order_items
    end

    should "show that a destroyed item is not part of unshipped, unpaid orders" do
      # create_pastries
      # create_order_items
      # create_orders

      # @cookie.destroy

      # destroy_pastries
      # destroy_order_items
      # destroy_orders
    end

  end

end
