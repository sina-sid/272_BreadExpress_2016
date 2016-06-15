module Contexts
  module Customers
    # Context for customers, assuming users
    def create_customers
      @alexe   = FactoryGirl.create(:customer, user: @alexe_user, first_name: "Alex", last_name: "Egan", phone: "412-268-8211", email: "aegan@example.com")
      @melanie = FactoryGirl.create(:customer, user: @melanie_user, first_name: "Melanie", last_name: "Freeman")
      @anthony = FactoryGirl.create(:customer, user: @anthony_user, first_name: "Anthony", last_name: "Corletti", phone: "412-268-2323")
      @ryan    = FactoryGirl.create(:customer, user: @ryan_user, first_name: "Ryan", last_name: "Flood")
      @sherry  = FactoryGirl.create(:customer, user: @sherry_user, first_name: "Sherry", last_name: "Chen")
      @sherry.active = false
      @sherry.save!
    end
    
    def destroy_customers
      @alexe.delete
      @melanie.delete
      @anthony.delete
      @ryan.delete 
      @sherry.delete
    end

  end
end