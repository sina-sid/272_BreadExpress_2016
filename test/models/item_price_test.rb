require 'test_helper'

class ItemPriceTest < ActiveSupport::TestCase
  # Testing relationships
  should belong_to(:item)

  # Testing validations
  should validate_date(:start_date).on_or_before(:end_date)
  should validate_numericality_of(:price).greater_than_or_equal_to(0)

  # rest with contexts
  context "Within context" do
    setup do
      create_customers
      create_order_items 
      create_items
      create_item_prices
    end

    teardown do
      destroy_customers
      destroy_order_items
      destroy_items
      destroy_item_prices
    end

    

  end
end
