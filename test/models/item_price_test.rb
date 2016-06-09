require 'test_helper'

class ItemPriceTest < ActiveSupport::TestCase
  # Testing relationships
  should belong_to(:item)

  # Testing validations
  should validate_date(:start_date).on_or_before(:end_date)
  should validate_date(:end_date).on_or_before(Date.today)
  should validate_numericality_of(:price).greater_than_or_equal_to(0)

  # rest with contexts
  context "Within context" do
    setup do
      create_muffins
      create_muffin_prices
    end

    teardown do
      destroy_muffins
      destroy_muffin_prices
    end

    should "display all current prices in system" do
      assert_equal [], ItemPrice.current.all.map{|i| i.item.name}.sort
    end 

    should "display all prices on a particular date" do
      assert_equal [], ItemPrice.for_date(Date.today).all.map{|i| i.price}.sort #display both price and name?
    end

    should "display all prices for a particular item" do
      assert_equal [], ItemPrice.for_item(1).all.map(&:price).sort
    end

    should "display all prices chronologically" do
      assert_equal [], ItemPrice.chronological.all.map(&:end_date) #display both date and name?
    end

    should "automatically set old end_date to new start_date" do
      @choc_muffins_new_price = FactoryGirl.build(:item_price)
      assert_equal Date.today, @choc_muffins_price.end_date
    end

    should "show items are active in system" do
      @choc_muffins_new_price = FactoryGirl.build(:item_price)
      assert @choc_muffins.active
      # need better test for this
      deny @plain_muffins.active
      @plain_muffins_price = FactoryGirl.build(:item_price)
      deny @plain_muffins_price.valid?
    end

    should "not allow record to be destroyed" do
      @choc_muffins_price.destroy
      assert @choc_muffins_price.valid?
    end

  end
end
