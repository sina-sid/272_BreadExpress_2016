module Contexts
  module Customers
    # Context for customers
    def create_customers
      @alex = FactoryGirl.create(:user, username: "alex", role: "admin")
      @ben = FactoryGirl.create(:user, username: "ben", role: "shipper")
      @bryan = FactoryGirl.create(:user, username: "bryan", role: "baker")
      @anthony = FactoryGirl.create(:user, username: "anthony", role: "customer")
      @harry  = FactoryGirl.create(:user, username: "harry", role: "customer")
    end
    
    def destroy_customers
      @alex.delete
      @ben.delete
      @anthony.delete
      @bryan.delete 
      @harry.delete
    end

  end
end