module Contexts
  module OrderItems
    # Context for order_items (assumes order, muffins, pastries context)
    def create_order_items
      create_alexe_o1_order_items
      create_alexe_o2_order_items
      create_alexe_o3_order_items
      create_melanie_o1_order_items
      create_melanie_o2_order_items
      create_anthony_o1_order_items
      create_ryan_o1_order_items
    end

    def destroy_order_items
      destroy_alexe_o1_order_items
      destroy_alexe_o2_order_items
      destroy_alexe_o3_order_items
      destroy_melanie_o1_order_items
      destroy_melanie_o2_order_items
      destroy_anthony_o1_order_items
      destroy_ryan_o1_order_items
    end


    def create_alexe_o1_order_items
      @alexe_o1_apple_pie = FactoryGirl.create(:order_item, order: @alexe_o1, item: @apple_pie, quantity: 4, shipped_on: Date.new(2015,2,16))
    end

    def destroy_alexe_o1_order_items
      @alexe_o1_apple_pie.delete
    end

    def create_alexe_o2_order_items
      @alexe_o2_choc_muffins = FactoryGirl.create(:order_item, order: @alexe_o2, item: @choc_muffins, quantity: 2, shipped_on: 1.day.ago.to_date)
      @alexe_o2_blueberry_muffins = FactoryGirl.create(:order_item, order: @alexe_o2, item: @blueberry_muffins, quantity: 1, shipped_on: 1.day.ago.to_date)
      @alexe_o2_apple_pie = FactoryGirl.create(:order_item, order: @alexe_o2, item: @apple_pie, quantity: 1, shipped_on: nil)
    end
    
    def destroy_alexe_o2_order_items
      @alexe_o2_choc_muffins.delete
      @alexe_o2_blueberry_muffins.delete
      @alexe_o2_apple_pie.delete
    end

    def create_alexe_o3_order_items
      @alexe_o3_choc_muffins = FactoryGirl.create(:order_item, order: @alexe_o3, item: @choc_muffins, quantity: 2, shipped_on: Date.today)
    end

    def destroy_alexe_o3_order_items
      @alexe_o3_choc_muffins.delete
    end

    def create_melanie_o1_order_items
      @melanie_o1_blueberry_muffins = FactoryGirl.create(:order_item, order: @melanie_o1, item: @blueberry_muffins, quantity: 3, shipped_on: nil)
      @melanie_o1_apple_pie = FactoryGirl.create(:order_item, order: @melanie_o1, item: @apple_pie, quantity: 1, shipped_on: 2.days.ago.to_date)
    end

    def destroy_melanie_o1_order_items
      @melanie_o1_blueberry_muffins.delete
      @melanie_o1_apple_pie.delete
    end

    def create_melanie_o2_order_items
      @melanie_o2_blueberry_muffins = FactoryGirl.create(:order_item, order: @melanie_o2, item: @blueberry_muffins, quantity: 5, shipped_on: nil)
      @melanie_o2_apple_pie = FactoryGirl.create(:order_item, order: @melanie_o2, item: @apple_pie, quantity: 1, shipped_on: nil)
    end

    def destroy_melanie_o2_order_items
      @melanie_o2_blueberry_muffins.delete
      @melanie_o2_apple_pie.delete
    end

    def create_anthony_o1_order_items
      @anthony_o1_choc_muffins = FactoryGirl.create(:order_item, order: @anthony_o1, item: @choc_muffins, quantity: 2, shipped_on: Date.today)
    end

    def destroy_anthony_o1_order_items
      @anthony_o1_choc_muffins.delete
    end

    def create_ryan_o1_order_items
      @ryan_o1_choc_muffins = FactoryGirl.create(:order_item, order: @ryan_o1, item: @choc_muffins, quantity: 2, shipped_on: nil)
    end

    def destroy_ryan_o1_order_items
      @ryan_o1_choc_muffins.delete
    end

  end
end