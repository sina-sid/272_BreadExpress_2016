module Contexts
  module OrderItems
    # Context for order_items (assumes order, muffins, pastries context)
    def create_alexe_o2_order_items
      @alexe_o2_choc_muffins = FactoryGirl.create(:order_item, order: @alexe_o2, item: @choc_muffins, quantity: 2, shipped_on: 1.day.ago.to_date)
      @alexe_o2_blueberry_muffins = FactoryGirl.create(:order_item, order: @alexe_o2, item: @blueberry_muffins, quantity: 1, shipped_on: .day.ago.to_date)
      @alexe_o2_apple_pie = FactoryGirl.create(:order_item, order: @alexe_o2, item: @apple_pie, quantity: 1, shipped_on: nil)
    end
    
    def destroy_alexe_o2_order_items
      @alexe_o2_choc_muffins.delete
      @alexe_o2_blueberry_muffins.delete
      @alexe_o2_apple_pie.delete
    end

  end
end