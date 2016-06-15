require 'test_helper'

class ItemPriceTest < ActiveSupport::TestCase
  # Testing relationships
  should belong_to(:item)

  # Testing validations
  should allow_value(Date.today).for(:start_date)
  should allow_value(2.weeks.ago.to_date).for(:start_date)
  should allow_value(2.days.from_now.to_date).for(:start_date)
  should_not allow_value("fred").for(:start_date)
  should_not allow_value(3.14159).for(:start_date)
  should_not allow_value(nil).for(:start_date)

  should allow_value(Date.today).for(:end_date)
  should allow_value(2.weeks.ago.to_date).for(:end_date)
  should allow_value(2.days.from_now.to_date).for(:end_date)
  should allow_value(nil).for(:end_date)
  should_not allow_value("fred").for(:end_date)
  should_not allow_value(3.14159).for(:end_date) 

  should validate_numericality_of(:price).is_greater_than_or_equal_to(0)

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
      assert_equal ["Blueberry Muffins: 15.99", "Chocolate Muffins: 12.99"], ItemPrice.current.all.map{|i| i.item.name + ": " + i.price.to_s}.sort
    end 

    should "display all prices on a particular date" do
      assert_equal ["Chocolate Muffins: 12.99"], ItemPrice.for_date(1.year.ago.to_date).all.map{|i| i.item.name + ": " + i.price.to_s}.sort #display both price and name?
    end

    should "display all prices for a particular item" do
      assert_equal [7.99, 12.99], ItemPrice.for_item(1).all.map(&:price).sort
    end

    should "display all prices chronologically" do
      assert_equal ["Blueberry Muffins: 15.99", "Chocolate Muffins: 12.99", "Plain Muffins: 5.99", "Chocolate Muffins: 7.99"], ItemPrice.chronological.all.map{|i| i.item.name + ": " + i.price.to_s}
    end

    should "automatically set old end_date to new start_date" do
      @choc_muffins_new_price = FactoryGirl.create(:item_price, item: @choc_muffins, price: 1.99, start_date: Date.today)
      assert_equal Date.today, @choc_muffins_price.end_date
      @choc_muffins_new_price.delete
    end

    should "show items are active in system" do
      @choc_muffins_new_price = FactoryGirl.build(:item_price, item: @choc_muffins, price: 1.99, start_date: Date.today)
      assert @choc_muffins.active
  
      deny @plain_muffins.active
      @plain_muffins_price = FactoryGirl.build(:item_price, item: @choc_muffins, price: 1.99, start_date: Date.today)
      deny @plain_muffins_price.valid?
    end

    should "not allow record to be destroyed" do
      @choc_muffins_price.destroy
      assert @choc_muffins_price.valid?
    end

  end
end
