module Contexts
  module Items

    def create_muffins
      @choc_muffins = FactoryGirl.create(:item, name: "Chocolate Muffins", description: "Muffin with Chocolate", category: "muffins", units_per_item: 12, weight: 2.5)
      @blueberry_muffins = FactoryGirl.create(:item, name: "Blueberry Muffins", description: "Healthier.", category: "muffins", units_per_item: 6, weight: 1.5)
      @plain_muffins = FactoryGirl.create(:item, name: "Plain Muffins", description: "Boring.", category: "muffins", units_per_item: 12, weight: 2.0, active: false)
    end

    def create_pastries
      @apple_pie = FactoryGirl.create(:item, name: "Apple Pie", description: "Classic.", category: "pastries", units_per_item: 1, weight: 1.0)
      @cookie = FactoryGirl.create(:item, name: "Cookie", description: "Ambiguous cookie.", category: "pastries", units_per_item: 12, weight: 2.0, active: false)
    end

    def create_bread
      @honey_wheat = FactoryGirl.create(:item)
      @bagel = FactoryGirl.create(:item, name: "Bagel", description: "A bagel.", category: "bread", units_per_item: 1, weight: 0.25, active: false)
    end
    
    def destroy_muffins
      @choc_muffins.delete
      @blueberry_muffins.delete
      @plain_muffins.delete
    end

    def destroy_pastries
      @apple_pie.delete
      @cookie.delete
    end

    def destroy_bread
      @honey_wheat.delete
      @bagel.delete
    end

  end
end