module Contexts
  module ItemPrices
    # Context for item_prices
    def create_muffin_prices
      # Current prices
      @choc_muffins_price = FactoryGirl.create(:item_price, item: @choc_muffins, price: 12.99, start_date: 1.year.ago.to_date, end_date: nil)
      @blueberry_muffins_price = FactoryGirl.create(:item_price, item: @blueberry_muffins, price: 15.99, start_date: 2.weeks.ago.to_date, end_date: nil)
      # Old prices
      @choc_muffins_old_price = FactoryGirl.create(:item_price, item: @choc_muffins, price: 7.99, start_date: 3.years.ago.to_date, end_date: 1.year_ago.to_date)
      @plain_muffins.active = true
      @plain_muffins.save!
      @plain_muffins_old_price = FactoryGirl.create(:item_price, item: @plain_muffins, price: 5.99, start_date: 2.years.ago.to_date, end_date: 1.year_ago.to_date)
      @plain_muffins.active = false
      @plain_muffins.save!
    end
    
    def destroy_muffin_prices
      @choc_muffins_price
      @blueberry_muffins_price
      @choc_muffins_old_price
      @plain_muffins_old_price
    end

  end
end